rng(123456);

%CG rich(1) vs CG poor(2)
A  = [0.99 0.01; 0.01 0.99]; %transition probs

%A C G T
B = [0.05 0.49 0.49 0.05; 
    0.49 0.05 0.05 0.49];

seq_N = 100;
seq_len = 100;
seqs = cell(seq_N, 1);
states = cell(seq_N, 1);

for i = 1:seq_N   
    [seqs{i}, states{i}] = hmmgenerate(seq_len,A,B);
end

guess_A = [0.9 0.1; 0.1 0.9]; %rand(2,2);
guess_A  = diag(sum(guess_A, 2)) \ guess_A;

guess_B = rand(2,4);
guess_B  = diag(sum(guess_B, 2)) \ guess_B;

%[estTR,estE] = hmmtrain(seqs, A, guess_B, 'Tolerance', 1e-5)

suff_stat = zeros(2,2);

for i = 1:seq_N
    seqs{i}(seqs{i} == 3) = 2;
    seqs{i}(seqs{i} == 4) = 1;
    seqs{i} = 3 - seqs{i};    
    for j = 2:seq_len
        suff_stat(seqs{i}(j-1), seqs{i}(j)) = suff_stat(seqs{i}(j-1), ...
                                                        seqs{i}(j)) ...
            + 1;
    end    
end
disp('Estimated state transition probabilities')
diag(sum(suff_stat, 2)) \ suff_stat


figure(1)
clf
subplot(1,2,1);

for i=1:seq_N
    scatter(find(seqs{i} == 1), ones(1, length(find(seqs{i} == 1))) ...
            * i, '.r');
    hold on
    scatter(find(seqs{i} == 2), ones(1, length(find(seqs{i} == 2))) ...
            * i, '.g');
end
title('Visualization of emitted sequence')
xlabel('Position')
ylabel('Sequence index')

subplot(1,2,2);

for i=1:seq_N
    scatter(find(states{i} == 1), ones(1, length(find(states{i} == ...
                                                      1))) * i, ...
            '.r');
    hold on
    scatter(find(states{i} == 2), ones(1, length(find(states{i} == ...
                                                      2))) * i, ...
            '.g');
end
title('Visualization of underlying states')
xlabel('Position')
ylabel('Sequence index')

saveas(gcf, '../imgs/gene_viz.png')

