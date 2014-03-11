errors = zeros (5,2);

Ts = linspace (100,500, 5);
for i = 1:5
    T = Ts (i);
    disp (sprintf('T=%d...', T));
    [e1, e2] = MLE_BE_simulate (T);
    errors (i, :) = [e1 e2];
end
errors

figure (1)
plot (1:5, errors (:, 1)', 'r')
hold on
plot (1:5, errors (:, 2)', 'b')

title ('MLE and BE error rates for various sequence lengths');
xlabel ('Sequnce length');
ylabel ('Error rate');

axis([100 500 0 0.1]);

legend ('Maximum likelihood estimation', 'Bayesian estimation');

saveas (gcf, 'result.png', 'png' )
