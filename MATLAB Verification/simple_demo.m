% Paul Meaney
% This demo loads values into the Equaliser
% Same values as Planahead test-bench


input = [8709, 30771, -26318, -26574, -13369, 30804, 10580,  4369, 8993, 21282, -26574, -13396, 30804, 10580];
[matlab_filtered_data, factor, coeffs] = eq_model(input, 'low', 'attenuate');