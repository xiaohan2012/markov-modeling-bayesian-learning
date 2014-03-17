function [P_prime] = simulate_and_learn (pi, P, E, n)
%parameter learning for a HMM sequence of length n
%under HMM model P and E, the transition and emission prob
%respectively

%the states and obs to be filled
states = zeros (n, 1);
obs = zeros (n, 1);

%generate the HMM data
%starting state
states (1) = find(cumsum(pi) >= rand (), 1);
obs (1) = find(cumsum(P (states (1), :)) >= rand (), 1);

%for time t, generate the current state based on previous one
for i = 2:n
    states (i) = find(cumsum(P (states (i-1), :)) >= rand (), 1);
    obs (i) = find(cumsum(E (states (i), :)) >= rand (), 1);
end

%using the observations to learn the HMM model,
%assuming the model is 1st order Markov chain
freq = zeros (size (P));

%get the unigrams
unigrams = obs (1:end-1);

%get the unigram freqs
unigram_freq = Freq(unigrams);

%get the bigrams
bigrams = zeros (n-1, 2);

for j=1:n-1
    bigrams (j, :) = obs (j:j+1);
end

%get the frequency for each type of pair
bigram_freq = Freq(AssignmentToIndex(bigrams, [2 2]));

%estimate the parameter
P_prime = zeros(2,2);

for i = 1:2
    for j = 1:2
        k = AssignmentToIndex ([i,j], [2, 2]);
        numer = bigram_freq(find (bigram_freq (:, 2) == k, ...
                                  1), 1);
        if isempty (numer)
            numer = 0;
        end
        
        denom = unigram_freq (find (unigram_freq (:, 2) == i, 1), ...
                              1);
        if isempty (denom)
            denom = 0;
        end
        if denom ~= 0
            P_prime (i,j) = numer / denom;
        else
            P_prime (i,j) = 1 / 2;
        end
    end
end
