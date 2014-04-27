rng(123456);

A  = [0.99 0.01; 0.01 0.99]; %transition probs

%emission probs
B = [0.05 0.49 0.49 0.05; 
    0.49 0.05 0.05 0.49];

lens = [10 20 30 40 50 100 200 300];
for i = 1:lens
    seq_len = lens (i);
    seq_N = 10;
    seqs = cell(seq_N, 1);
    states = cell(seq_N, 1);

    for i = 1:seq_N   
        [seqs{i}, states{i}] = hmmgenerate(seq_len,A,B);
    end

    guess_A = rand(2, 2);
    guess_A  = diag(sum(guess_A, 2)) \ guess_A;

    guess_B = rand(2,4);
    guess_B  = diag(sum(guess_B, 2)) \ guess_B;

    [estTR,estE] = hmmtrain(seqs, guess_A, guess_B, 'Tolerance', 1e-5);
    disp (sprintf ('seq len %d', seq_len));
    estTR,estE
end