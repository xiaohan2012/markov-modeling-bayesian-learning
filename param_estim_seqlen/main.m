rng (123456);
lengths = [1,2,4,8,16,32,64,128,256, 512, 100, 200, 300, 400, 500, 600, ...
           700, 800, 900, 1000];
totalSymbolCount = 10000;
simulationTimes = 50;
errsBaum = zeros(simulationTimes, length(lengths));
errsViterbi = zeros(simulationTimes, length(lengths));

for simulationTime = 1:simulationTimes
    simulationTime
    %define the model parameter
    A = rand (2,2); A = diag(sum (A, 2)) \ A;
    B = rand (2,4); B = diag(sum (B, 2)) \ B;

    estimA = abs(A + rand (2,2) .* 0.05); estimA = diag (sum (estimA, ...
                                                          2)) \ estimA;
        
    estimB = abs(B + rand (2,4) .* 0.05); estimB = diag (sum (estimB, ...
                                                      2)) \ estimB;
        
    for i = 1:length (lengths)
        seqLength = lengths (i);
        seq = hmmgenerate (seqLength, A, B);
                
        %estimA, estimB
        [estimABaum, estimBBaum] = hmmtrain (seq, estimA, estimB, ...
                                     'Tolerance', 1e-03, 'Algorithm', ...
                                     'BaumWelch');

        t = cputime;
        [estimAViterbi, estimBViterbi] = hmmtrain (seq, estimA, estimB, ...
                                     'Tolerance', 1e-03, 'Algorithm', ...
                                     'Viterbi', 'Pseudoemissions', ones(2,4));
        errsSumBaum = sum(sum((A - estimABaum) .^ 2)  + sum(sum((B- estimBBaum) ...
                                                          .^ 2)));
        errsSumViterbi = sum(sum((A - estimAViterbi) .^ 2)  + sum(sum((B- estimBViterbi) ...
                                                          .^ 2)));
        errsBaum(simulationTime, i) = errsBaum(simulationTime, i) + errsSumBaum / 12;
        errsViterbi(simulationTime, i) = errsViterbi(simulationTime, i) + errsSumViterbi / 12;
    end
end
errsBaum = mean(errsBaum, 1);
errsViterbi = mean(errsViterbi, 1);

figure (1)
clf
subplot (1,2,1);
plot (lengths (1:10), errsBaum (1:10), 'o-b');
hold on
plot (lengths (1:10), errsViterbi (1:10), 'o-r');
legend ('BaumWelch', 'Viterbi')
axis ([0 600 0 0.6])
xlabel ('Sequence length')
ylabel ('Mean of Average square error')

subplot (1,2,2)
plot (lengths (11:end), errsBaum (11:end), 'o-b');
hold on
plot (lengths (11:end), errsViterbi (11:end), 'o-r');
legend ('BaumWelch', 'Viterbi')
axis ([0 1000 0 0.2])
xlabel ('Sequence length')
ylabel ('Mean of Average square error')

saveas (gcf, '../imgs/err_vs_seqlen.png')
