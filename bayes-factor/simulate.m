function [B01, B12] = simulate (seq_len)
%Simulation using the first `seq_len` values
%returns the the Bayes factors of 0-1 and 1-2 for all `N` sequences

N = 1000; %sequence number

%generate the sequences
seqs = mc_gen (N, seq_len);

%calcualte the sufficient statistics, count of nigram, bigram and
%trigram
[ustats, bstats, tstats] = suff_stat (seqs);

%get the P (x1....xn| M0), P (x1....xn| M1) and P (x1....xn| M2)
%for each sequence
log_probs0 = pred_log_probs_0 (ustats);
log_probs1 = pred_log_probs_1 (bstats);
log_probs2 = pred_log_probs_2 (tstats);


%get the Bayes Factors of between M0 and M1, M1 and M2, plot the histogram
B01 = exp(log_probs0 - log_probs1);
B12 = exp(log_probs1 - log_probs2);
