function probs = pred_log_probs_1 (bstats)
bstats = bstats (:, 2:end); %remove the leading index name

[dummy, N] = size (bstats);
prior_param_0 = ones (4, 1); 
theta_addition = repmat(prior_param_0, 1, N);

probs = zeros (1, N);

for i = 1:4
    assignments = [ones(4,1)*i, (1:4)'];
    freqs = bstats(AssignmentToIndex (assignments, [4 4]), :);
    probs = probs + ...
        gammaln (sum (prior_param_0)) + sum(gammaln (freqs  + theta_addition * 4 ), 1) - ...
        (sum(gammaln (prior_param_0)) + gammaln(sum (freqs + theta_addition*4, 1)));
        
end
