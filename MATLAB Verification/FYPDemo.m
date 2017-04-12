% Paul Meaney 2017
% This script creates an audio wav file.
% It analysis it
% Filters it based on given params
% Takes in output of vicilab
% compares the two

% 1) Create a wave file from a number of sine waves
% 2) Call filter function depending on args passed
% 3) Read in wav file from viciLogic
% 4) Analysis and compare spectums and waves - using my own algorithm
close all
clear all

%************************************************************************
% 1) Create a wave file from a number of sine waves
t = (0:8000) * 1/8000;
input = 0;
x_ax = (1:256) * 4000/256; 

for i = 1 : 10
    input = input + sin(2 * pi * t * (i * 390));
end

norm_fact = max(abs(input));
input_norm = input/max(norm_fact);
input_norm = input_norm.';
filename = 'sampleaudio_input.wav';
Fs = 8000;
audiowrite(filename, input_norm, Fs);

%***********************************************************************
% 2) Call filter function depending on args passed
[input_from_wav, Fs_in] = audioread(filename);

[matlab_filtered_data, factor, coeffs] = eq_model(input_from_wav.', 'low', 'attenuate');


%***********************************************************************
% 3) Read in wav file from viciLogic
file_from_vicilab = 'vicilab_output.wav';
[input_vicilab, Fs_in_vl] = audioread(file_from_vicilab);

%***********************************************************************
% 4) Analysis and compare spectums and waves - using my own algorithm
original_signal_spec = fft_cooley_tukey(input_from_wav(1:512).' * norm_fact);
original_signal_spec = abs(original_signal_spec);
original_signal_spec = original_signal_spec(1:end/2);
original_signal_spec = (original_signal_spec*2)/512;

matlab_filtered_spec = fft_cooley_tukey(matlab_filtered_data(1:512) * norm_fact);
matlab_filtered_spec = abs(matlab_filtered_spec);
matlab_filtered_spec = matlab_filtered_spec(1:end/2);
matlab_filtered_spec = (matlab_filtered_spec*2)/512;


fpga_filtered_spec = fft_cooley_tukey(input_vicilab(1:512) * norm_fact);
fpga_filtered_spec = abs(fpga_filtered_spec);
fpga_filtered_spec = fpga_filtered_spec(1:end/2);
fpga_filtered_spec = (fpga_filtered_spec*2)/512;

figure(1)
bar(x_ax, fpga_filtered_spec, 'r');
title("Frequency Spectrum - Output of FPGA");
xlabel("Frequecy (Hz)");
ylabel ("Amplitude");
figure(2)
bar(x_ax, matlab_filtered_spec);
title("Frequency Spectrum - Output of MATLAB Simulation");
xlabel("Frequecy (Hz)");
ylabel ("Amplitude");

figure(3)
bar(x_ax, original_signal_spec, 'k');
title("Frequency Spectrum - Original Signal");
xlabel("Frequecy (Hz)");
ylabel ("Amplitude");



