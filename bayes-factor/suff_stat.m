function [unigram_stats, bigram_stats, trigram_stats] = suff_stat ...
    (sequences)
%compute the sufficient statistics for each of the given the sequences
%get the trigrams
[seq_number, seq_length] = size (sequences);

unigram_stats = [(1:4)', zeros(4, seq_number)];
bigram_stats = [(1:16)', zeros(16, seq_number)];
trigram_stats = [(1:64)', zeros(64, seq_number)];


for i = 1: seq_number
    %get the trigrams
    trigrams = zeros (seq_length-2, 1);
    for j=1:seq_length-2
        trigrams (j) = AssignmentToIndex(sequences (i, j:j+2), ...
                                            [4 4 4]);
    end

    %get the bigrams
    bigrams = zeros (seq_length-1, 1);
    for j=1:seq_length-1
        bigrams (j) = AssignmentToIndex(sequences (i, j:j+1), [4 4]);
    end
    
    %get the unigrams frequencies
    unigram_freq = histc(sequences (i, :), 1:4);

    %get the unigram frequencies
    bigram_freq = histc (bigrams, 1:16);
    
    %get the trigram frequencies
    trigram_freq = histc(trigrams, 1:64);

    unigram_stats (:, i+1) = unigram_freq (:);
    bigram_stats (:, i+1) = bigram_freq (:);
    trigram_stats (:, i+1) = trigram_freq (:);
end