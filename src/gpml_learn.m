function model = gpml_learn(train_x,train_y,test_x,test_y,gp_pars)
% Learn GPML using training data and test the output on testing set
% Inputs are
% train_x - feature data to learn from ground truth
% train_y - motion capture data to learn from ground truth
% test_x - features for which gpml will be tested
% test_y - true output values (optional)
% gp_pars - specify the learning mean and covariance params

% Output:
% model - stores everything about this result

if nargin<2
    disp('Insufficient parameters for learning GP. Exiting');
    return;
else
    % Ensuring that everything is in double precision for minimization
    train_x = double(train_x);
    train_y = double(train_y);
    % Forming the ground truth now
    gt_x = train_x;
    model = cell(1,size(train_y,2));
    if nargin == 2
        test_x = [];
        test_y = [];
        % Specify a mean function
        % One can use feval to get how many hyperparameters are needed for the
        % current mean function feval(meanfunc{:})
        meanfunc = {@meanSum,{@meanConst,@meanLinear}};
        hyp.mean = ones(size(gt_x,2)+1,1);
        % Specify squared exponential as covariance function
        covfunc = @covSEiso;
        hyp.cov = log([2;2]);
        % Specify a likelihood function
        likfunc = @likGauss;
        % The parameter inside log is the standard deviation of noise
        hyp.lik = log(10);
        gp_pars.meanfunc = meanfunc;
        gp_pars.hyp = hyp;
        gp_pars.covfunc = covfunc;
        gp_pars.likfunc = likfunc;
    elseif nargin == 3
        test_y = [];
        meanfunc = {@meanSum,{@meanConst,@meanLinear}};
        hyp.mean = ones(size(gt_x,2)+1,1);
        covfunc = @covSEiso;
        hyp.cov = log([2;2]);
        % Specify a likelihood function
        likfunc = @likGauss;
        % The parameter inside log is the standard deviation of noise
        hyp.lik = log(10);
        gp_pars.meanfunc = meanfunc;
        gp_pars.hyp = hyp;
        gp_pars.covfunc = covfunc;
        gp_pars.likfunc = likfunc;
    else
        disp('Will attempt the supplied function and parameters')
    end
end

test_x = double(test_x);
test_y = double(test_y);

% Actual learning part
% Currently we are learning a separate GP for every dimension

for i = 1:size(train_y,2)
    % To test for each dimension
    gt_y = train_y(:,i);
    gp_pars.hyp = minimize(gp_pars.hyp, @gp, -500, @infExact, gp_pars.meanfunc, ...
        gp_pars.covfunc, gp_pars.likfunc, gt_x, gt_y);    
    % Getting the Negative log Marginal Likelihood
    curr_model.nlml = gp(gp_pars.hyp, @infExact, gp_pars.meanfunc, ...
        gp_pars.covfunc, gp_pars.likfunc, gt_x, gt_y);
    % Testing set - predicts mean and variance in data
    [mean_pre var_pre] = gp(gp_pars.hyp, @infExact, gp_pars.meanfunc, ...
        gp_pars.covfunc, gp_pars.likfunc, gt_x, gt_y, test_x);
    % Storing the current model
    curr_model.gt_x = gt_x;curr_model.gt_y = gt_y;
    curr_model.hyp = gp_pars.hyp;curr_model.meanfunc = gp_pars.meanfunc;
    curr_model.covfunc = gp_pars.covfunc;curr_model.likfunc = gp_pars.likfunc;
    curr_model.mean_pre = mean_pre;curr_model.var_pre = var_pre;
    curr_model.test_y = test_y;
    model{1,i} = curr_model;
end

end