% LPF filter design for various windows - causal case
clear all;
close all;

%%
% Inputs and required variables
M = input('Enter the length of filter : ');
w_c = input('Enter the cut-off frequency (in rad/s) : ');
window_name = input('Enter window name : ');
select = input('Enter causal or non-causal : ');
w = [-w_c:0.1/pi:w_c];                                                      % Filter is defined from -w_c to w_c so ignoring the full range -pi to pi
H_d = exp(-2*j*w);                                                          % Given desired LPF response

%% Filter design using window method
h_d = ifft(H_d);                                                            % Inverse DTFT of given frequency response
if select == "non-causal"
    if mod(length(h_d),2) == 0
        temp_1 = h_d(1:length(h_d)/2);
        temp_2 = h_d(1+(length(h_d)/2):length(h_d));
        h_d(1:length(h_d)/2) = temp_2;
        h_d(1+(length(h_d)/2):length(h_d)) = temp_1;
    else
        temp_1 = h_d(1:(length(h_d)+1)/2);
        temp_2 = h_d((1+length(h_d))/2:length(h_d));
        h_d(1:(length(h_d)+1)/2) = temp_2;
        h_d((1+length(h_d))/2:length(h_d)) = temp_1;
    end
end

w_n = windows_func(M, window_name, length(h_d), select);
h_n = h_d.*w_n;                                                             % Designed filter
H = fft(h_n);                                                               % Frequency response of designed filter

%%
% Plots
figure(1);
subplot(3,1,1);
stem(abs(h_n));
title('Designed Filter (h[n])');
xlabel('time (in sec)');
ylabel('Amplitude');

figure(1);
subplot(3,1,2);
plot(w, abs(H));
title('Designed Filter - Magnitude Response');
xlabel('\omega (in rad/sec)');
ylabel('|H(\omega)|');

figure(1);
subplot(3,1,3);
plot(w, angle(H));
title('Designed Filter - Phase Response');
xlabel('\omega (in rad/sec)');
ylabel('|\phi(\omega)|');