import logging
import time
import threading
import thread
import wave
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
        self.setup()


    def deserialize(self, data):
        pass

    def serialize(self):
        pass

    def bundle_data(self):
        return []

    def unbundle_data(self, data):
        pass

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
        self.resetButton.clicked.connect(self.reset_system)
        self.impulseButton.clicked.connect(self.impulse_response)

    #Fuction to select File
    def select_input_file(self):
        self.SelectFileLabel.setText("clicked")
        inputFileName = str(QtGui.QFileDialog.getOpenFileName())
        f_name = inputFileName.split('\'')
        inputFileName = f_name[1]
        self.SelectFileLabel.setText(inputFileName)
        self.raw_wave = self.read_in_file(inputFileName)
        self.input_data = self.read_in_wav_file(inputFileName)
        print "here"

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

        self.parent.send_command("set 0 frequencySelect EQ_top ")

    def mid_freq_select(self):
        self.MidFreqButton.setChecked(True)
        self.LowFreqButton.setChecked(False)
        self.HighFreqButton.setChecked(False)
        self.parent.send_command("set 1 frequencySelect EQ_top ")

    def high_freq_select(self):
        self.HighFreqButton.setChecked(True)
        self.MidFreqButton.setChecked(False)
        self.LowFreqButton.setChecked(False)
        self.parent.send_command("set 3 frequencySelect EQ_top")

    def attenuate_select(self):
        self.attenuateButton.setChecked(True)
        self.passThroughButton.setChecked(False)
        self.amplifyButton.setChecked(False)
        self.parent.send_command("set 0 operationSelect EQ_top")

    def pass_through_select(self):
        self.passThroughButton.setChecked(True)
        self.attenuateButton.setChecked(False)
        self.amplifyButton.setChecked(False)
        self.parent.send_command("set 1 operationSelect EQ_top")

    def amplify_select(self):
        self.amplifyButton.setChecked(True)
        self.attenuateButton.setChecked(False)
        self.passThroughButton.setChecked(False)
        self.parent.send_command("set 3 operationSelect EQ_top")

    def start_process(self):
        data = self.input_data
        self.SelectFileLabel.setText("Running")
        self.parent.send_command("set {:x} delayVal EQ_top".format(1)) #0.5sec
        self.parent.send_command("clear_reset")
        self.parent.send_command("set 1 ce EQ_top")
        self.parent.send_command("step_clock 1")
        self.output_buffer = self.write_to_fpga(data)
        # thread.start_new_thread(self.write_to_fpga, (data,))


        # self.write_fir(data[0])
        # time.sleep(1)
        # for i in range (1, len(data)-1):
        #     self.write_fir(data[i])
        #     time.sleep(1)
        # self.stop_clock()

        # was creating a new thread for each write - caused massive pressure in system
        #     threading.Timer(i, self.write_fir, [data[i]]).start()
        #
        # threading.Timer(len(data) + 1, self.stop_clock, []).start()

    def write_to_fpga(self, data):
        byte_array = []
        for i in range (0, len(data)):
            self.write_fir(data[i])
            # print 'input ' + self.parent.send_command('read FIRDatIn', block=True)['data']
            self.parent.send_command("step_clock 1")
            fir_out = self.parent.send_command('read FIRDatOut', block=True)['data']
            if len(fir_out) == 3:
                fir_out = ''.join('0' + fir_out)
            elif len(fir_out) == 2:
                fir_out = ''.join('00' + fir_out)
            elif len(fir_out) == 1:
                fir_out = ''.join('000' + fir_out)

            byte_array.append(fir_out)
            # print 'output {}'.format(fir_out)
        self.parent.send_command("step_clock 1")
        self.parent.send_command("set 0 ce EQ_top")
        self.parent.send_command("assert_reset")
        self.write_fir("0")
        self.parent.send_command("step_clock 1")
        self.SelectFileLabel.setText("Complete")
        print 'done'
        return byte_array
        # print self.parent.send_command('read Filter.FIRStage', block=True)['data']




    def impulse_response(self):
        self.parent.send_command("set 17D7840 delayVal EQ_top") #1sec
        self.parent.send_command("clear_reset")
        self.parent.send_command("set 1 ce EQ_top")
        self.parent.send_command("set 0001 FIRDatIn EQ_top")
        self.Input_val.setText("0001")
        self.parent.send_command("start_clock")



        # threading.Timer(15, self.stop_clock, []).start()
        #
        # threading.Timer(1.5, self.write_fir, ["00"]).start()

        """
        self.process = Timer(15.0, self.stop_clock())
        self.process.start()
        self.t = Timer(3.0, self.write_fir("00"))
        self.t.start()
        """
        #self.delay()
        #self.parent.send_command("set 00 FIRDatIn FIRFilter4Tap")
        #self.Input_val.setText("00")
        #time.sleep(10)




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

    def write_out_file(self, file_name):
        outfile = open(file_name, "wb")
        output = self.output_buffer
        for i in range(0, len(output)):
            outfile.write(binascii.unhexlify(output[i]))
        outfile.close()


    def hex_to_string(self, hex_val):
        string = str(hex_val).encode("hex")
        return string

    def delay(self):
        time.sleep(2)

    def write_fir(self, val):
        self.parent.send_command("set " + val + " FIRDatIn EQ_top")
        self.Input_val.setText(val)

    def stop_clock(self):
        self.parent.send_command("stop_clock")
        self.SelectFileLabel.setText("Complete")

    def reset_system(self):
        self.parent.send_command("assert_reset")
        threading.Timer(0.5, self.parent.send_command, ["clear_reset"]).start()
        self.parent.send_command("clear_reset")
        self.write_fir("0000")

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
        # firout = values["EQ_top.FIRDatOut"]
        # self.update_output(firout)
        # activate = values["EQ_top.activate"]


class EditableEqualizerBeta(EqualizerBeta):

    def __init__(self, *args, **kwargs):
        super(EditableEqualizerBeta, self).__init__(*args, **kwargs)
        self.widget.setEnabled(False)
