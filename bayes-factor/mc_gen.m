function sequences = mc_gen (N, L)
%N: the number of chains
%L: the length of each chain

%simulate the 2nd order markov chain and compare the error between
%MLE and BE

pi = ones (16, 1) / sum (ones (16, 1));%the initial state distribution

lambda = ones (16, 4); %the Dirichlet hyperparameter

sequences = ones (N, L);

%fix the P, for debugging purpose
P =  ones (16, 4);
P = P ./ repmat(sum (P, 2), 1, 4);

%for the ith sequence
for i=1:N
    P =  rand (16, 4);  %randomly generate the transition matrix
    P = P ./ repmat(sum (P, 2), 1, 4); %normalize it

    %generate the sequence of ACGTs using the prob dist P
    %for the first two states, generate them by pi
    %calc the cumulative sum pi, randomly generate one number from [0, 1)
    
    sequences(i, 1:2) = IndexToAssignment(find(rand () < cumsum(pi), 1), [4 4]);
    
    for t = 3: L
        last_two = sequences (t-2:t-1);
        r = rand () ;                   
        sequences (i, t) = find(cumsum(P(AssignmentToIndex (last_two, [4 4]), :))>=r, 1);
    end
    
end
