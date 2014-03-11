errors = zeros (5,2);

Ts = linspace (100,500, 5);
for i = 1:5
    T = Ts (i);
    disp (sprintf('T=%d...', T));
    [e1, e2] = MLE_BE_simulate (T);
    errors (i, :) = [e1 e2];
end
errors(:, 1)'

figure (1)
plot (Ts, errors (:, 1)', 'r')
hold on
plot (Ts, errors (:, 2)', 'b')

title ('MLE and BE error rates for various sequence lengths');
xlabel ('Sequnce length');
ylabel ('Error rate');

axis([100 500 0 0.02]);

legend ('Maximum likelihood estimation', 'Bayesian estimation');

%saveas (gcf, 'result.png', 'png' )
