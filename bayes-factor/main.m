addpath ('../MLE_and_BE/')
N = 1000; %sequence number

%generate the sequences
seqs = mc_gen (N, 500);

%calcualte the sufficient statistics, count of nigram, bigram and
%trigram
[ustats, bstats, tstats] = suff_stat (seqs);

%get the P (x1....xn| M0), P (x1....xn| M1) and P (x1....xn| M2)
%for each sequence
prior_param_0 = ones (4, 1); theta_addition = repmat(prior_param_0, 1, N);
ustats = ustats (:, 2:end);
ustats  = ustats + theta_addition * 16;

pred_log_probs_0 = gammaln (sum (prior_param_0)) + sum ...
    (gammaln (ustats), 1)  - (sum(gammaln (prior_param_0)) + gammaln(sum ...
                                             (ustats, 1)));

bstats = bstats (:, 2:end); %remove the leading index name
pred_log_probs_1 = zeros (1, N);

for i = 1:4
    assignments = [ones(4,1)*i, (1:4)'];
    freqs = bstats(AssignmentToIndex (assignments, [4 4]), :);
    pred_log_probs_1 = pred_log_probs_1 + ...
        gammaln (sum (prior_param_0)) + sum(gammaln (freqs  + theta_addition * 4 ), 1) - ...
        (sum(gammaln (prior_param_0)) + gammaln(sum (freqs + theta_addition*4, 1)));
        
end

tstats = tstats (:, 2:end);
pred_log_probs_2 = zeros (1, N);

for i = 1:4
    for j = 1:4
        assignments = [ones(4,1)*i, ones(4,1)*j, (1:4)'];
        freqs = tstats(AssignmentToIndex (assignments, [4 4 4]), :);
        pred_log_probs_2 = pred_log_probs_2  +  ...
        gammaln (sum (prior_param_0)) + sum(gammaln (freqs  + theta_addition), 1) - ...
            (sum(gammaln (prior_param_0)) + gammaln(sum (freqs + theta_addition, 1)));
    end
end

%get the Bayes Factors of between M0 and M1, M1 and M2, plot the histogram

bf01 = exp(pred_log_probs_0 - pred_log_probs_1);
bf12 = exp(pred_log_probs_1 - pred_log_probs_2);

mean (bf01)
mean (bf12)

figure (1)
subplot (2,1,1)
hist (bf01)
title ('Bayes factor between M_0 and M_1')
xlabel ('B')
ylabel ('Frequency')

subplot (2,1,2)
hist (bf12)
title ('Bayes factor between M_1 and M_2')
xlabel ('B')
ylabel ('Frequency')

saveas (gcf, '../imgs/bf-hist.png');