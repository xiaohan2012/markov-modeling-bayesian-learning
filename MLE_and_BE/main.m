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
clf
plot (Ts, errors (:, 1)', 'r-o')
hold on
plot (Ts, errors (:, 2)', 'b-o')

xlabel ('Sequnce length');
ylabel ('Error rate');

axis([90 510 0 0.04]);

legend ('Maximum likelihood estimation', 'Bayesian estimation');

saveas (gcf, '../imgs/result.png', 'png' )
