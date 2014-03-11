%mapping:
%A -> 1
%C -> 2
%G -> 3
%T -> 4

pi = ones (16, 1) / sum (ones (16, 1));%the initial state distribution

T = 50; %the sequence length

N = 10; %number of simulations

sequences = ones (1, T);

%for the ith sequence
for i=1:N
  P =  rand (16, 4);  %randomly generate the transition matrix
  p = P ./ repmat(sum (P, 2), 1, 4); %normalize it

  %generate the sequence of ACGTs using the prob dist P
  
  %for the first two states, generate them by pi
  %calc the cumulative sum pi, randomly generate one number from [0, 1)
  
  sequences (1:2) = IndexToAssignment(find(rand () < cumsum (pi) ) (1), [4 4]);
  
  for t = 3: T
    last_two = sequences (i, t-2:t-1);
    
    sequences (t) = find(rand () < cumsum(P(AssignmentToIndex (last_two, [4 4]), :))) (1);
  end

  %get the bigrams
  bigrams = zeros (T-1, 2);
  for j=1:T-1
    ## bigrams (j, :) = sequences (j:j+1);
  end
  
  %get the bigram frequencies
  bigram_freq = Freq(AssignmentToIndex (bigrams, [4 4]));

  %get the unigram frequencies
  unigram_freq = Freq(sequence);
  
  %perform the Maximum Likelihood Estimation
  MLE_P = zeros (16, 4);
  for j = 1: 4
    for k = 1:16
      ## bigram_count = find (bigram_freq (:, 2) == k) (1);
      ## unigram_count = find (unigram_freq (:, 2) == j) (1);
      ## MLE_P (k,j) = bigram_count / unigram_count;
    end
  end
  
  disp (MLE_P)
  
%perform the Bayesian Estimation
end





disp (sequences)
