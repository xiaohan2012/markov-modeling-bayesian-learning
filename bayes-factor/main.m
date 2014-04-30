addpath ('../MLE_and_BE/')
[B01_1, B12_1] = simulate (100);
[B01_2, B12_2] = simulate (200);
[B01_3, B12_3] = simulate (300);
[B01_4, B12_4] = simulate (400);
[B01_5, B12_5] = simulate (500);

B01 = [mean(B01_1), mean(B01_2), mean(B01_3), mean(B01_4), mean(B01_5)];
B12 = [mean(B12_1), mean(B12_2), mean(B12_3), mean(B12_4), mean(B12_5)];

figure (1)
clf
subplot (2,1,1);
plot ((1:5) * 100,  B01, '-o');
ylabel ('Average Bayes factor values')
xlabel ('The first N values in the sequence')

subplot (2,1,2);
plot ((1:5) * 100,  B12, '-o');
ylabel ('Average Bayes factor values')
xlabel ('The first N values in the sequence')

saveas (gcf, '../imgs/bf-nval.png')

figure (2)
clf
subplot (2,1,1)
hist (B01_5);
xlabel ('Bayes factor value')
ylabel ('Frequency')

subplot (2,1,2)
hist (B12_5);
xlabel ('Bayes factor value')
ylabel ('Frequency')

saveas (gcf, '../imgs/bf-hist.png');