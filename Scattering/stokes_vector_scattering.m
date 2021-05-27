%clear all;
addpath ../
addpath ../methods


% Polyester spheres in water
p.host_refractive_index = complex(1.33, 6e-10);

%Alga data
%p.sphere_refractive_index = complex(1.371, 0.0005);

%Polyester spheres data
p.sphere_refractive_index = complex(1.59, 0.0003);

%Wavelength of incident light
p.wavelength_micrometer = 0.589; 

%Alga data
%p.lognormal_size_distribution_sigma = 0.726e-6; % I forhold til størrelsen på kulene
%p.radius_at_distribution_maximum_in_micrometer = 2.209; % Radiusen ved maksimum

%Polyester spheres data
p.lognormal_size_distribution_sigma = 9.2e-9; % I forhold til størrelsen på kulene
p.radius_at_distribution_maximum_in_micrometer = 0.255; % Radiusen ved maksimum

p.angles_in_degree = linspace(0,180,500);
p.significant_digits = 3;
p.plot_progress = false;
lm = lorenz_mie(p);
figure(1)
%plot_scattering_elements(p.angles_in_degree,lm);


% Stokes vector for incident irradiance of 1 W/m2 polarized parallel
% with the scattering plane, which is horizontal polarization if
% source and detector are placed side by side on the optical table.
I_p = [1 1 0 0];

% Stokes vector for incident irradiance polarized normal (senkrecht) to the
% scattering plane, i.e. vertical polarization is
I_s = [1 -1 0 0];

% Selected scattering angle
angle_deg = 154; %Sjekke vinkel i forhold til kamera

% The Mueller matrix is
M = zeros(4,4);
M(1,1) = interp1(p.angles_in_degree,lm.F11,angle_deg); %lm=lorentz mie
M(1,2) = interp1(p.angles_in_degree,lm.F12,angle_deg);
M(2,1) = interp1(p.angles_in_degree,lm.F12,angle_deg);
M(2,2) = interp1(p.angles_in_degree,lm.F11,angle_deg);
M(3,3) = interp1(p.angles_in_degree,lm.F33,angle_deg);
M(3,4) = interp1(p.angles_in_degree,lm.F34,angle_deg);
M(4,3) = interp1(p.angles_in_degree,-lm.F34,angle_deg);
M(4,4) = interp1(p.angles_in_degree,lm.F33,angle_deg);

% Convert from per micrometer squared per steradian to per meter
% squared per steradian
M = M*1e-12;

%Diameter circle = 6.5. Illuminated area: 0.0033183072403542

% Cross sectional area of incident beam [m2]
A = 0.0033183072403542; %The area illuminated on the container

% Length of illuminated chamber [m]
L = 0.115;

% Number of scattering particles per volume [1/m3]
rho=linspace(0,10*10^13,100000);


% Number of scattering particles in the volume illuminated by the beam
N = A*L.*rho;

% Distance from scattering volume to detector [m] 14cm
r = 0.14; 

% Reflected stokes vector at the detector (assuming single scattering
% and neglecting absorption in surrounding medium)
%Id_p = N/r^2*M*I_p'; 
%Id_s = N/r^2*M*I_s';

% Irradiance at detector [W/m2]
%Horizontal_irradiance_at_detector_in_W_per_m2 = Id_p(1);
%Vertical_irradiance_at_detector_in_W_per_m2 = Id_s(1);

% Probability that a photon will be scattered on its way through the tank
um2_to_m2 = 1e-12; 
scattering_coefficient = rho.*lm.Csca*um2_to_m2;

%Optical depth
optical_depth = scattering_coefficient*L;

%Probability of survival
probability_of_survival = exp(-optical_depth);

%Probability of scattering
probability_of_scattering = 1-probability_of_survival;


%Asymmetry factor g
g=2*pi*trapz(p.angles_in_degree/180*pi,lm.F11/lm.Cext.*cos(p.angles_in_degree/180*pi).*sin(p.angles_in_degree/180*pi));
%Use scaled optical depth to classify if it is single or multiple scattering
scaled_optical_depth=optical_depth*(1-g);

figure(1)
%Plotting scattering particles per volume versus scaled optical depth
plot(rho, scaled_optical_depth,'Color', [0 0 0]);
set(gcf,'Position',[400 200 800 500])
set(gca,'FontName','Times')
set(gca,'FontSize',13)
ylabel('Scaled optical depth [m]')
xlabel('Scattering particles per volume [1/m^3]')
hold on

%Marking the multiple scattering limit
y=yline(0.3,'-.r','Multiple scattering \uparrow', 'FontName','Times','FontSize',13);
y.LabelHorizontalAlignment='left';

if scaled_optical_depth <= 0.30
    disp('Single Scattering')
elseif scaled_optical_depth > 0.30
    disp ('Multiple Scattering')
end


