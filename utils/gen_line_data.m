function data = gen_line_data(m,c,noise_var,num_samples,add_quadratic)
% Generate data from a line 
% Inputs are 
% m - Slope of the line
% c - Intercept of the line
% noise_var - Variance of gaussian noise to be added to samples
% num_samples - Total number of samples to be generated
% add_quadratic - If we should add some quadractic noise

% Passing in default arguments
switch nargin
    case 0
        m = 1;
        c = 0;
        noise_var = 10;
        num_samples = 30;
        add_quadratic = 0.005;
    case 1
        c = 0;
        noise_var = 10;
        num_samples = 30;
        add_quadratic = 0.005;
    case 2
        noise_var = 10;
        num_samples = 30;
        add_quadratic = 0.005;
    case 3
        num_samples = 30;
        add_quadratic = 0.01;
    case 4
        add_quadratic = 0.005;
end

% Generating noise samples
gap = 10; % Creating a gap in measurements
x = [1:10,10+gap+1:num_samples+gap];
data = [x',m*x'+c+sqrt(noise_var)*randn(size(x,2),1)+add_quadratic*x'.^2];
end