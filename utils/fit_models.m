function fit_models()
% To fit various models
% Currently we fit a linear, quadratic, linear bayesian and
% gaussian process models

% Generating data from the get_line_data code which samples a line
% with additive gaussian noise
gt_data = gen_line_data();

% We perform the evaluation on the entire data, even where no training 
% samples are present
test_data = min(gt_data(:,1))-5:0.2:max(gt_data(:,1))+5;

% Fitting degree 1 polynomial
[p_1,s_1] = polyfit(gt_data(:,1),gt_data(:,2),1);
[predict_1,delta_1] = polyval(p_1,test_data,s_1);
% To understand these measures , read here
% http://reliawiki.org/index.php/Simple_Linear_Regression_Analysis#Confidence_Interval_on_Regression_Coefficients
% http://stackoverflow.com/questions/29870188/how-to-graph-error-in-parameters-from-polynomial-fit-matlab

% Plotting the fit using +-2*Delta which corresponds to a 95% confidence
% interval for large samples
% http://www.mathworks.com/help/matlab/data_analysis/programmatic-fitting.html#bqm3cio-1
fig = figure(1);
plot_samples_mean_bounds(fig,gt_data,test_data,predict_1,delta_1);

% Fitting degree 2 polynomial
[p_2,s_2] = polyfit(gt_data(:,1),gt_data(:,2),2);
[predict_2,delta_2] = polyval(p_2,test_data,s_2);
fig = figure(2);
plot_samples_mean_bounds(fig,gt_data,test_data,predict_2,delta_2);

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

% Getting test points
inp_X = [test_data;ones(1,size(test_data,2))];
% Predicting value at each point
mean_pred = zeros(size(inp_X,2),1);
sigma_pred = zeros(size(inp_X,2),1);
for i = 1:size(mean_pred,1)
    mean_pred(i) = (1/obs_noise_var)*(inp_X(:,i)'*inv(A)*X*y);
    sigma_pred(i) = sqrt(diag(inp_X(:,i)'*inv(A)*inp_X(:,i)));
end

fig = figure(3);
plot_samples_mean_bounds(fig,gt_data,test_data,mean_pred,sigma_pred);

% GPML fit
model = gpml_learn(gt_data(:,1),gt_data(:,2),test_data');
fig = figure(4);
plot_samples_mean_bounds(fig,gt_data,test_data,model{1}.mean_pre,sqrt(model{1}.var_pre));

end