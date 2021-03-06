% Low pass filter

%Pulizia
clc
clear all
close all

% Butterworth = 1
% Chebichev = 0
tipo = 1; 

A_stop_band = 30; % i valori devono essere inseriti in decibel 

A_band_pass = 3;   % i valori devono essere inseriti in decibel 

w_stop_band = 20000; % valore di frequenza non normalizzato

w_band_pass = 10000; % valore di frequenza non normalizzato

fprintf('------------------------REALIZZATORE DI FILTRI--------------------------\n');

%   Normalizzazione

Omega_band_pass = 1;

Omega_stop_band = w_stop_band/w_band_pass;

%   Normalizzazione

if tipo == 1

    fprintf('tipo scelto: Butterworth\n');

    % pass band attenuation index

    eps_bp = (10^(A_band_pass/10)-1)^(1/2);

    % stop band attenuation index

    eps_sb = (10^(A_stop_band/10)-1)^(1/2);

    % 

k = Omega_band_pass/Omega_stop_band; 

%

k_eps = eps_bp/eps_sb;

% filter order

filter_order = log(k_eps)/log(k);
        
filter_order = ceil(filter_order); % approssimazione all'intero successivo 

% selezione della frequenza di taglio 

Omega_0_MAX = Omega_stop_band/(eps_sb^(1/filter_order));

Omega_0_min = Omega_band_pass/(eps_bp^(1/filter_order));

fprintf('The frequency must match the required attenuation index. \nPlease choose one pole frequency between %d and %d\n',Omega_0_min,Omega_0_MAX);
Omega_0=input('Insert the chosen Omega_O: ');
%Omega_0 = 1.12;
%% Grafico filtro normalizzato

x_band_pass = [0 0 Omega_band_pass Omega_band_pass]; %settate le x per il quadrato limite del band_pass
y_band_pass = [0 1-10^((-A_band_pass)/20) 1-10^((-A_band_pass)/20)  0]; %settate le y per il quadrato limite del band_pass

x_stop_band = [Omega_stop_band Omega_stop_band (Omega_stop_band+3) (Omega_stop_band+3)]; %settate le x per il quadrato limite del band_pass
y_stop_band = [1 1-10^((-A_stop_band)/20) 1-10^((-A_stop_band)/20) 1]; %settate le y per il quadrato limite del band_pass

Omega = linspace(0,Omega_stop_band+3,100);
H_butt = sqrt(1./(1+(Omega/Omega_0).^(2*filter_order)));
subplot(2,1,1)
plot(x_band_pass,y_band_pass);
hold on
plot(x_stop_band,y_stop_band);
hold on
plot(Omega,H_butt);
axis([0 Omega_stop_band+3 0 1.001])

[z,p,k] = buttap(filter_order);          % Butterworth filter prototype
[theta, rho] = cart2pol(real(p), imag(p));
subplot(2,1,2)
polarplot(theta,rho,'o')

%TODO Ladder implementation

%%
elseif tipo == 0 
    fprintf('tipo scelto: Chebishev\n');
    % filter order
    filter_order = acosh(1/k_eps)/acosh(1/k);
    filter_order = ceil(filter_order);

    % bp_edge or sb_edge matching
    
    %pole calculation
    % Gamma = ((1+sqrt(1+eps_bp^2))/eps_bp);
    % for i:1:filter_order
    % [theta[i], rho[i]] = cart2pol((real(p), imag(p));
    % end

% Graph plot
x_band_pass = [0 0 Omega_band_pass Omega_band_pass]; %settate le x per il quadrato limite del band_pass
y_band_pass = [0 10^((-A_band_pass)/20) 10^((-A_band_pass)/20)  0]; %settate le y per il quadrato limite del band_pass

x_stop_band = [Omega_stop_band Omega_stop_band (Omega_stop_band+3) (Omega_stop_band+3)]; %settate le x per il quadrato limite del band_pass
y_stop_band = [1 10^((-A_stop_band)/20) 10^((-A_stop_band)/20) 1]; %settate le y per il quadrato limite del band_pass

Omega = linspace(0,Omega_stop_band+3,100);
Cn = cosh(filter_order*acosh(Omega/Omega_band_pass));
H_cheb = sqrt(1./(1+eps_bp^2*Cn.^2));
subplot(2,1,1)
plot(x_band_pass,y_band_pass);
hold on
plot(x_stop_band,y_stop_band);
hold on
plot(Omega,H_cheb);
axis([0 Omega_stop_band+3 0 1.001])

% [z,p,k] = chebp(filter_order);          % Chebyshev filter prototype
% [theta, rho] = cart2pol(real(p), imag(p));
% subplot(2,1,2)
% polarplot(theta,rho,'o')

end






