function probs = pred_log_probs_0 (ustats)
ustats = ustats (:, 2:end);

[dummy, N] = size (ustats);
prior_param_0 = ones (4, 1); theta_addition = repmat(prior_param_0, ...
                                                  1, N);

ustats  = ustats + theta_addition * 16;

probs = gammaln (sum (prior_param_0)) + sum ...
    (gammaln (ustats), 1)  - (sum(gammaln (prior_param_0)) + gammaln(sum ...
                                                  (ustats, 1)));
