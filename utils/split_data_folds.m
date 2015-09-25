function test_train_sets = split_data_folds(org_gt_x,org_gt_y,k)
% Split data into training and testing sets with k folds
% Inputs are org_gt_x - Original input (X)
% org_gt_y - Original input's output response (Y)
% k - Number of folds into which data should be divided

% Output is a cell array with arranged test and training sets of data

num_gt = floor(size(org_gt_x,1)/k); % k part of ground truth
% Randomly shift data
rand_ind = randperm(size(org_gt_x,1));
gt_x = org_gt_x(rand_ind,:);
gt_y = org_gt_y(rand_ind,:);
% Initializing test and train sets
test_train_sets = cell(k,1);

for i = 1:k
    if i ==1
        % Training data
        test_train_sets{i}.train_x = gt_x(i*num_gt+1:end,:);
        test_train_sets{i}.train_y = gt_y(i*num_gt+1:end,:);
        % Testing data
        test_train_sets{i}.test_x = gt_x((i-1)*num_gt+1:i*num_gt,:);
        % Testing data true value
        test_train_sets{i}.test_y = gt_y((i-1)*num_gt+1:i*num_gt,:);
    elseif i==k
        % Training data
        test_train_sets{i}.train_x = gt_x(1:(i-1)*num_gt,:);
        test_train_sets{i}.train_y = gt_y(1:(i-1)*num_gt,:);
        % Testing data
        test_train_sets{i}.test_x = gt_x((i-1)*num_gt+1:end,:);
        % Testing data true value
        test_train_sets{i}.test_y = gt_y((i-1)*num_gt+1:end,:);
    else
        % Training data
        test_train_sets{i}.train_x = gt_x([1:(i-1)*num_gt,i*num_gt+1:end],:);
        test_train_sets{i}.train_y = gt_y([1:(i-1)*num_gt,i*num_gt+1:end],:);
        % Testing data
        test_train_sets{i}.test_x = gt_x((i-1)*num_gt+1:i*num_gt,:);
        % Testing data true value
        test_train_sets{i}.test_y = gt_y((i-1)*num_gt+1:i*num_gt,:);        
    end
end
end