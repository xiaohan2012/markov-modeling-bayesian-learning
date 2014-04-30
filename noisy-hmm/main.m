

%run the simulation N times
N = 100;

%length of the sequence
n = 100;

p = 0.8;%change it to your like

errors = 0:.05:1; %the error rate in emission prob varying from .1 to .9 step size .1

param_error_e = zeros (length (errors), 1); %the error of learned
                                            %params under each e

pi = [.5 .5]; %we assume uniform distribution for initial states

for i = 1:length (errors)
    e = errors (i) %the error under consideration
    %accumalator for errors made under e
    error_sum = 0;
    E = [1 - e, e; e, 1-e];
   
    
    for t = 1:N
        %randomly generate transition prob matrix P 
        P = [1 - p, p; p, 1-p];
        
       %disp ('True param:');
       %disp (P);

        %feed them into the learning agent
        P_prime = simulate_and_learn (pi, P, E, n);


       %disp ('Estimated param:');
       %disp (P_prime);
        %computes the error
       error = sum(sum(abs(P_prime - P) ./ P)) / 4;
       
       error_sum = error_sum + error;
    end
    param_error_e(i) = error_sum / N;
end

figure (1)
clf

plot (errors, param_error_e, 'o-');

param_error_e

xlabel ('\epsilon');
ylabel ('Parameter estimation error mean');

axis([-0.1 1.1 0 1]);

saveas (gcf, sprintf('../imgs/noisyhmm-errorrate-p=%f.png', p), 'png' )
