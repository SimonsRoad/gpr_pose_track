function fit_models()
% To fit various models
% Currently we fit a linear, quadratic, linear bayesian and
% gaussian process models

% Generating data from the get_line_data code which samples a line
% with additive gaussian noise
gt_data = gen_line_data();
% Fitting degree 1 polynomial
[p_1,s_1] = polyfit(gt_data(:,1),gt_data(:,2),1);
[predict_1,delta_1] = polyval(p_1,gt_data(:,1),s_1);
% To understand these measures , read here
% http://reliawiki.org/index.php/Simple_Linear_Regression_Analysis#Confidence_Interval_on_Regression_Coefficients
% http://stackoverflow.com/questions/29870188/how-to-graph-error-in-parameters-from-polynomial-fit-matlab

% Plotting the fit using +-2*Delta which corresponds to a 95% confidence
% interval for large samples
% http://www.mathworks.com/help/matlab/data_analysis/programmatic-fitting.html#bqm3cio-1
fig = figure(1);
plot_samples_mean_bounds(fig,gt_data(:,1),gt_data(:,2),predict_1,delta_1);

% Fitting degree 2 polynomial
[p_2,s_2] = polyfit(gt_data(:,1),gt_data(:,2),2);
[predict_2,delta_2] = polyval(p_2,gt_data(:,1),s_2);
fig = figure(2);
plot_samples_mean_bounds(fig,gt_data(:,1),gt_data(:,2),predict_2,delta_2);

% Bayesian linear regression fit
% Following section 2.1.1 of C.E. Rasmussen and C.K.I. Williams
% Gaussian Process for Machine Learning
X = [gt_data(:,1)';ones(1,size(gt_data,1))];
y = gt_data(:,2);
obs_noise_var = 10; % Observation variance noise
sigma_pars = [5 0;0 5];
A = (1/obs_noise_var)*(X*X')+inv(sigma_pars);
% Estimating weights posterior
mean_w = (1/obs_noise_var)*(inv(A)*X*y);
sigma_w = inv(A);
% Predicting value at each point
mean_pred = zeros(size(X,2),1);
sigma_pred = zeros(size(X,2),1);
for i = 1:size(mean_pred,1)
    mean_pred(i) = (1/obs_noise_var)*(X(:,i)'*inv(A)*X*y);
    sigma_pred(i) = sqrt(diag(X(:,i)'*inv(A)*X(:,i)));
end

fig = figure(3);
plot_samples_mean_bounds(fig,gt_data(:,1),gt_data(:,2),mean_pred,sigma_pred);


end