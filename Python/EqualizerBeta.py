######################################
# Paul Meaney
# FYP
# NUIG
# Electronic and Computer Engineering
# 2017
# paulmeaney1@gmail.com
#####################################

import logging
import time
import threading
import thread
# import wave #not supported by vicilab - also not used in this code
import binascii
from EqualizerBeta_layout import Ui_EqualizerBeta
from PySide import QtGui, QtCore

LOG = logging.getLogger(__name__)

class EqualizerBeta(Ui_EqualizerBeta, QtCore.QObject):

    def __init__(self, parent=None, config=None):
        super(EqualizerBeta, self).__init__()
        self.config = config
        self.parent = parent
        self.widget = QtGui.QWidget()
        self.widget.object = self
        self.output_buffer = []
        self.raw_wave = []
        self.input_data = []
        self.lock = threading.Lock()
        self.filter_layout = ["low", "att"];
        self.setup()


    def deserialize(self, data):
        pass

    def serialize(self):
        pass

    def bundle_data(self):
        return []

    def unbundle_data(self, data):
        pass
# This function is called when the GUI opens first time
# All the graphical elements are wired up to functions
    def setup(self):
        Ui_EqualizerBeta.setupUi(self, self.widget)
        self.selectFileButton.clicked.connect(self.select_input_file)
        self.selectOutputButton.clicked.connect(self.select_output_file)
        self.LowFreqButton.clicked.connect(self.low_freq_select)
        self.MidFreqButton.clicked.connect(self.mid_freq_select)
        self.HighFreqButton.clicked.connect(self.high_freq_select)
        self.attenuateButton.clicked.connect(self.attenuate_select)
        self.passThroughButton.clicked.connect(self.pass_through_select)
        self.amplifyButton.clicked.connect(self.amplify_select)
        self.startbutton.clicked.connect(self.start_process)
        # self.resetButton.clicked.connect(self.reset_system)
        # self.impulseButton.clicked.connect(self.impulse_response)
        self.progressText.hide()
        self.low_freq_amp_img.hide()
        self.low_freq_pass_img.hide()
        self.low_freq_att_img.show()
        self.mid_freq_amp_img.hide()
        self.mid_freq_pass_img.show()
        self.mid_freq_att_img.hide()
        self.high_freq_amp_img.hide()
        self.high_freq_pass_img.show()
        self.high_freq_att_img.hide()
        self.LowFreqButton.setChecked(True)
        self.MidFreqButton.setChecked(False)
        self.HighFreqButton.setChecked(False)
        self.attenuateButton.setChecked(True)
        self.passThroughButton.setChecked(False)
        self.amplifyButton.setChecked(False)

    #Fuction to select File
    # opens file view box and parses in the filename
    # then calls two different functions to extract the data from the file
    def select_input_file(self):
        self.SelectFileLabel.setText("clicked")
        inputFileName = str(QtGui.QFileDialog.getOpenFileName())
        f_name = inputFileName.split('\'')
        inputFileName = f_name[1]
        self.SelectFileLabel.setText(inputFileName)
        self.raw_wave = self.read_in_file(inputFileName)
        self.input_data = self.read_in_wav_file(inputFileName)
        # print "here"


    # Opens the dialog box to retrieve filename of the write out file
    def select_output_file(self):
        outputFileName = str(QtGui.QFileDialog.getOpenFileName())
        f_name = outputFileName.split('\'')
        outputFileName = f_name[1]
        self.write_out_file(outputFileName)


    #Fuctions to select EQ Function
    def low_freq_select(self):
        self.LowFreqButton.setChecked(True)
        self.MidFreqButton.setChecked(False)
        self.HighFreqButton.setChecked(False)
        self.filter_layout[0] = "low"
        self.set_freq_graphic()
        self.parent.send_command("set 0 frequencySelect EQ_top ")

    def mid_freq_select(self):
        self.MidFreqButton.setChecked(True)
        self.LowFreqButton.setChecked(False)
        self.HighFreqButton.setChecked(False)
        self.filter_layout[0] = "mid"
        self.set_freq_graphic()
        self.parent.send_command("set 1 frequencySelect EQ_top ")


    def high_freq_select(self):
        self.HighFreqButton.setChecked(True)
        self.MidFreqButton.setChecked(False)
        self.LowFreqButton.setChecked(False)
        self.filter_layout[0] = "high"
        self.set_freq_graphic()
        self.parent.send_command("set 3 frequencySelect EQ_top")

    def attenuate_select(self):
        self.attenuateButton.setChecked(True)
        self.passThroughButton.setChecked(False)
        self.amplifyButton.setChecked(False)
        self.filter_layout[1] = "att"
        self.set_freq_graphic()
        self.parent.send_command("set 0 operationSelect EQ_top")

    def pass_through_select(self):
        self.passThroughButton.setChecked(True)
        self.attenuateButton.setChecked(False)
        self.amplifyButton.setChecked(False)
        self.filter_layout[1] = "pass"
        self.set_freq_graphic()
        self.parent.send_command("set 1 operationSelect EQ_top")

    def amplify_select(self):
        self.amplifyButton.setChecked(True)
        self.attenuateButton.setChecked(False)
        self.passThroughButton.setChecked(False)
        self.filter_layout[1] = "amp"
        self.set_freq_graphic()
        self.parent.send_command("set 3 operationSelect EQ_top")

    def set_freq_graphic(self):
        self.low_freq_amp_img.hide()
        self.low_freq_pass_img.hide()
        self.low_freq_att_img.hide()
        self.mid_freq_amp_img.hide()
        self.mid_freq_pass_img.hide()
        self.mid_freq_att_img.hide()
        self.high_freq_amp_img.hide()
        self.high_freq_pass_img.hide()
        self.high_freq_att_img.hide()
        if self.filter_layout == ["low", "att"]:
            self.low_freq_att_img.show()
            self.mid_freq_pass_img.show()
            self.high_freq_pass_img.show()

        elif self.filter_layout == ["low", "pass"]:
            self.low_freq_pass_img.show()
            self.mid_freq_pass_img.show()
            self.high_freq_pass_img.show()

        elif self.filter_layout == ["low", "amp"]:
            self.low_freq_amp_img.show()
            self.mid_freq_pass_img.show()
            self.high_freq_pass_img.show()
        elif self.filter_layout == ["mid", "att"]:
            self.low_freq_pass_img.show()
            self.mid_freq_att_img.show()
            self.high_freq_pass_img.show()

        elif self.filter_layout == ["mid", "pass"]:
            self.low_freq_pass_img.show()
            self.mid_freq_pass_img.show()
            self.high_freq_pass_img.show()

        elif self.filter_layout == ["mid", "amp"]:
            self.low_freq_pass_img.show()
            self.mid_freq_amp_img.show()
            self.high_freq_pass_img.show()

        elif self.filter_layout == ["high", "att"]:
            self.low_freq_pass_img.show()
            self.mid_freq_pass_img.show()
            self.high_freq_att_img.show()

        elif self.filter_layout == ["high", "pass"]:
            self.low_freq_pass_img.show()
            self.mid_freq_pass_img.show()
            self.high_freq_pass_img.show()

        elif self.filter_layout == ["high", "amp"]:
            self.low_freq_pass_img.show()
            self.mid_freq_pass_img.show()
            self.high_freq_amp_img.show()



    # This function is called to start the filtering process.
    # The FPGA write commands are called in a separate thread to prevent the GUI
    # from stalling.
    def start_process(self):
        data = self.input_data
        self.SelectFileLabel.setText("Running")
        self.parent.send_command("clear_reset")
        self.parent.send_command("set 1 ce EQ_top")
        self.parent.send_command("step_clock 1")
        # self.output_buffer = self.write_to_fpga(data)
        thread.start_new_thread(self.write_to_fpga, (data,))


        # self.write_fir(data[0])
        # time.sleep(1)
        # for i in range (1, len(data)-1):
        #     self.write_fir(data[i])
        #     time.sleep(1)
        # self.stop_clock()

        # was creating a new thread for each write - caused massive pressure in system lead to crashing
        #     threading.Timer(i, self.write_fir, [data[i]]).start()
        #
        # threading.Timer(len(data) + 1, self.stop_clock, []).start()

    def write_to_fpga(self, data):
        byte_array = []
        # thread.start_new_thread(self.update_progress, (len(data),))
        self.progressText.show()
        data_to_fpga = ""
        print "length of data is {} samples".format(len(data))
        for i in range (0, len(data)):
            # first concatenate every 7 elements
            data_to_fpga = data_to_fpga + data[i];
            if (i + 1) % 7 == 0:
                # print "data in {}".format(data_to_fpga)
                self.write_fir(data_to_fpga)
                self.parent.send_command("step_clock 8")
                fir_out = self.parent.send_command('read DatOut', block=True)['data']
                self.output_val.setText("{}".format(fir_out))
                if len(fir_out) < 28:
                    fir_out = ''.join('0'*(28-len(fir_out)) + fir_out)

                # print "{} fpga output is {}".format(i, fir_out)
                # THis line splits the ouput into 16 bit frames
                output_frames = [fir_out[j:j+4] for j in range(0, len(fir_out), 4)]
                # print "outputframes {}".format(output_frames)
                for k in range(0, len(output_frames)):
                    byte_array.append(output_frames[k])
                data_to_fpga = ""

            # print 'input ' + self.parent.send_command('read FIRDatIn', block=True)['data']
            progress = (i*100)/len(data)
            self.progressText.setText("{}%".format(progress))
            # self.progress = i
            # self.update_progress(len(data))
            # print 'output {}'.format(fir_out)
# this part deals with the leftover frames if the number of total frames is not a factor of 7

        if len(data) % 7 != 0:
            r_bit = len(data_to_fpga) - 28
            data_to_fpga = data_to_fpga + "0"*r_bit;
            self.write_fir(data_to_fpga);
            val = len(data_to_fpga)/4;
            self.parent.send_command("step_clock {}".format(val))
            fir_out = self.parent.send_command('read DatOut', block=True)['data']
            self.output_val.setText("{}".format(fir_out))
            if len(fir_out) == 27:
                fir_out = ''.join('0' + fir_out)
            elif len(fir_out) == 26:
                fir_out = ''.join('00' + fir_out)
            elif len(fir_out) == 23:
                fir_out = ''.join('000' + fir_out)
            # THis line splits the ouput into 16 bit frames
            output_frames = [fir_out[j:j+4] for j in range(0, len(fir_out), 4)]
            for k in range(0, len(output_frames)):
                byte_array.append(output_frames[k])
            data_to_fpga = ""


        # print "out data is {}".format(byte_array)

        self.parent.send_command("step_clock 1")
        self.parent.send_command("set 0 ce EQ_top")
        self.parent.send_command("assert_reset")
        self.write_fir("0")
        self.parent.send_command("step_clock 1")
        self.SelectFileLabel.setText("Complete")
        self.progressText.hide()
        print 'done'
        self.output_buffer = byte_array
        # print self.parent.send_command('read Filter.FIRStage', block=True)['data']








# Unused function - original used to trigger an impulse_response
# Left in so you can see examples of other functions being used as guidance
    # def impulse_response(self):
    #     self.parent.send_command("set 17D7840 delayVal EQ_top") #1sec
    #     self.parent.send_command("clear_reset")
    #     self.parent.send_command("set 1 ce EQ_top")
    #     self.parent.send_command("set 0001 FIRDatIn EQ_top")
    #     self.Input_val.setText("0001")
    #     self.parent.send_command("start_clock")
    #
    #
    #
    #     # threading.Timer(15, self.stop_clock, []).start()
    #     #
    #     # threading.Timer(1.5, self.write_fir, ["00"]).start()
    #
    #     """
    #     self.process = Timer(15.0, self.stop_clock())
    #     self.process.start()
    #     self.t = Timer(3.0, self.write_fir("00"))
    #     self.t.start()
    #     """
    #     #self.delay()
    #     #self.parent.send_command("set 00 FIRDatIn FIRFilter4Tap")
    #     #self.Input_val.setText("00")
    #     #time.sleep(10)


# read in wave file
# skip header then reverse bytes in every 16bit frame (little endian byte ordering)

    def read_in_wav_file(self, file_name):
        f = open(file_name, 'rb')
        frame = ''
        output_data = []
        try:
            f.seek(44)
            byte = f.read(1)
            while byte != '':
                frame = byte
                byte = f.read(1)
                frame = byte + frame
                output_data.append(frame.encode('hex'))
                frame = ''
                byte = f.read(1)
        finally:
            f.close()
            return output_data

# This function reads in the full file header and data, no reording
# Can be used to read in data files not in wav format
    def read_in_file(self, file_name):
        f = open(file_name, "rb")
        output_array = []
        try:
            frame = f.read(2)
            print type(frame)
            print frame
            while frame != "":
                output_array.append(str(frame).encode("hex"))
                frame = f.read(2)
        finally:
            f.close()
            return output_array
# THis function writes data to wave file, reorders 16 bit frame to little endian byte order
    def write_out_file(self, file_name):
        outfile = open(file_name, "wb")
        for s in range(0, 22):
            outfile.write(binascii.unhexlify(self.raw_wave[s]))
        output = self.output_buffer
        for i in range(0, len(output)):
            frame = output[i];
            frame = frame[2:] + frame[:2]
            outfile.write(binascii.unhexlify(frame))
        outfile.close()
        print "File written to {}".format(outfile)
        self.output_val.setText("File Written Successfully")

# Converts a hex value to a string
    def hex_to_string(self, hex_val):
        string = str(hex_val).encode("hex")
        return string

    def delay(self):
        time.sleep(2)

    def write_fir(self, val):
        self.parent.send_command("set " + val + " DatIn EQ_top")
        self.Input_val.setText(val)

    def stop_clock(self):
        self.parent.send_command("stop_clock")
        self.SelectFileLabel.setText("Complete")

    # def reset_system(self):
    #     self.parent.send_command("assert_reset")
    #     threading.Timer(0.5, self.parent.send_command, ["clear_reset"]).start()
    #     self.parent.send_command("clear_reset")
    #     self.write_fir("0000")

    def close(self):
        self.fpga = None

    def loadFPGA(self, fpga):
        del self.fpga
        self.fpga = fpga

class RunnableEqualizerBeta(EqualizerBeta):

    def __init__(self, *args, **kwargs):
        super(RunnableEqualizerBeta, self).__init__(*args, **kwargs)


    def setup(self, *args, **kwargs):
        super(RunnableEqualizerBeta, self).setup()

    def update_items(self, values):
        """
        values is a dictionary with the keys in the form:
        component.signal_name
        """
        # was originally reading values from here.
        # values are only updated periodically
        # firout = values["EQ_top.FIRDatOut"]
        # self.update_output(firout)
        # activate = values["EQ_top.activate"]


class EditableEqualizerBeta(EqualizerBeta):

    def __init__(self, *args, **kwargs):
        super(EditableEqualizerBeta, self).__init__(*args, **kwargs)
        self.widget.setEnabled(False)
