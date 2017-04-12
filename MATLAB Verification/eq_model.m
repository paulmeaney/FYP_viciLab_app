% Paul Meaney 2017
% This function models FPGA Equaliser Implementation


function [ output_data, L1, coeffsnorm ] = eq_model( input_data, filter_type, filter_func )
%eq_model - this function filters data as per the params
%It models the FPGA model

    switch filter_func
        case 'attenuate'
            gain = 0.01;
        case 'none' 
            gain = 1;
        case 'amplify'
            gain = 100;
        otherwise
            gain = 1;
    end;

    switch filter_type
        case 'low'
            corners = [0, 0.33, 0.33, 1];
            impulse = [gain, gain, 1 ,1];
            coeffs = fir2(20, corners, impulse);

            L1 = floor(log2((32767) / (max(abs(coeffs)))));
            factor = 2^L1;
            coeffsnorm = coeffs * factor;
            
            
        case 'mid'
            corners = [0, 0.33, 0.33, 0.66, 0.66, 1];
            impulse = [1, 1, gain, gain, 1 ,1];
            coeffs = fir2(20, corners, impulse);

            L1 = floor(log2((32767) / (max(abs(coeffs)))));
            factor = 2^L1;
            coeffsnorm = coeffs * factor;
            
        case 'high'
            corners = [0, 0.66, 0.66, 1];
            impulse = [1, 1, gain, gain];
            coeffs = fir2(20, corners, impulse);

            L1 = floor(log2((32767) / (max(abs(coeffs)))));
            factor = 2^L1;
            coeffsnorm = coeffs * factor;
            
        otherwise
            
    end
    
    
    output_data = filter(coeffsnorm, 1, input_data);
    output_data = output_data / factor;


end

