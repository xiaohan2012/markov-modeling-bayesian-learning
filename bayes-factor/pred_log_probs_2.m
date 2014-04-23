function probs = pred_log_probs_2 (tstats)
tstats = tstats (:, 2:end);

[dummy, N] = size (tstats);
prior_param_0 = ones (4, 1); theta_addition = repmat(prior_param_0, 1, N);

probs = zeros (1, N);

for i = 1:4
    for j = 1:4
        assignments = [ones(4,1)*i, ones(4,1)*j, (1:4)'];
        freqs = tstats(AssignmentToIndex (assignments, [4 4 4]), :);
        probs = probs  +  ...
        gammaln (sum (prior_param_0)) + sum(gammaln (freqs  + theta_addition), 1) - ...
            (sum(gammaln (prior_param_0)) + gammaln(sum (freqs + theta_addition, 1)));
    end
end
