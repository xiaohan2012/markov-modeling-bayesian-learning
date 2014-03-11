function [MLE_error_sum, BE_error_sum]= MLE_BE_simulate (T)
%simulate the 2nd order markov chain and compare the error between
%MLE and BE

pi = ones (16, 1) / sum (ones (16, 1));%the initial state distribution

N = 1000; %number of simulations

lambda = ones (16, 4); %the Dirichlet hyperparameter

sequences = ones (1, T);

%fix the P, for debugging purpose
P =  ones (16, 4);
P = P ./ repmat(sum (P, 2), 1, 4);


MLE_error_sum = 0; BE_error_sum  = 0; %accumulated error made by MLE and BE

%for the ith sequence
for i=1:N
    P =  rand (16, 4);  %randomly generate the transition matrix
    P = P ./ repmat(sum (P, 2), 1, 4); %normalize it

    %generate the sequence of ACGTs using the prob dist P
    %for the first two states, generate them by pi
    %calc the cumulative sum pi, randomly generate one number from [0, 1)
    
    sequences(1:2) = IndexToAssignment(find(rand () < cumsum(pi), 1), [4 4]);
    
    for t = 3: T
        last_two = sequences (t-2:t-1);
        r = rand () ;                   
        sequences (t) = find(cumsum(P(AssignmentToIndex (last_two, [4 4]), :))>=r, 1);
    end

    %get the trigrams
    trigrams = zeros (T-2, 3);
    for j=1:T-2
        trigrams (j, :) = sequences (j:j+2);
    end

    %get the bigrams
    bigrams = zeros (T-1, 2);
    for j=1:T-1
        bigrams (j, :) = sequences (j:j+1);
    end
    
    %get the trigram frequencies
    trigram_freq = Freq(AssignmentToIndex(trigrams, [4 4 4]));

    %get the unigram frequencies
    bigram_freq = Freq(AssignmentToIndex(bigrams, [4 4]));
    
    %perform the Maximum Likelihood Estimation and the Bayesian Estimation
    MLE_P = zeros (16, 4); BE_P = zeros (16, 4);
    for k = 1:16    
        for j = 1: 4
            previous_two_assignment = IndexToAssignment (k, [4,4]); ...
                assignment = [previous_two_assignment, j];%assignments of the trigram

            %the table index of the assignment
            index = AssignmentToIndex (assignment, [4 4 4]);
            
            trigram_count = trigram_freq(find (trigram_freq (:, 2) ...
                                               == index, 1), 1);
            bigram_count = bigram_freq(find (bigram_freq (:, 2) == k, 1), 1);
            %====================
            %the MLE part
            %====================
            %if no such trigram exists, the prob is zero
            if length(trigram_count) == 0
                MLE_P (k, j) = 0;
                trigram_count = 0;
                if length(bigram_count) == 0
                    bigram_count = 0;
                end
            else
                MLE_P (k, j) = trigram_count / bigram_count;
            end

            %====================
            %the BE part
            %====================
            BE_P (k, j) = (trigram_count + lambda (k, j)) / (bigram_count + sum(lambda (k, :)));
        end
        %for the  MLE table rows which contain only zero, assign
        %each possibility equal prob
        if all (MLE_P (k, :) == 0)
            MLE_P (k, :) = ones (4, 1) / 4;
        end
    end
    e1 = sum(sum(abs(MLE_P - P) ./ P )) / 64;
    e2 = sum(sum(abs(BE_P - P) ./ P)) / 64;
    MLE_error_sum = MLE_error_sum + e1 / 64;
    BE_error_sum = BE_error_sum + e2 / 64;
end

MLE_error_sum = MLE_error_sum / N;
BE_error_sum = BE_error_sum / N;

