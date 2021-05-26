%Retrieving data array for 100 degree tea
w_tea= te100_hel{:,1};
t_tea= te100_hel{:,2};
w_tea2= te100_halv{:,1};
t_tea2= te100_halv{:,2};
w_water= te100_uten_2{:,1};
t_water= te100_uten_2{:,2};

%Retrieving data array for 37 degree tea
w37_tea= te37_hel{:,1};
t37_tea= te37_hel{:,2};
w37_tea2= te37_halv{:,1};
t37_tea2= te37_halv{:,2};
w37_water= te37_uten{:,1};
t37_water= te37_uten{:,2};

%Retrieving data array for ice tea
w_icetea= iste_hel{:,1};
t_icetea= iste_hel{:,2};
w_icetea2= iste_halv{:,1};
t_icetea2= iste_halv{:,2};
w_water_ice= iste_uten{:,1};
t_water_ice= iste_uten{:,2};

%Calculating the amount of transmitted light for each of the cases
sum{:,1}=t_tea./t_water;
sum{:,2}=t_tea2./t_water;
sum{:,3}=t37_tea./t37_water;
sum{:,4}=t37_tea2./t37_water;
sum{:,5}=t_icetea./t_water_ice;
sum{:,6}=t_icetea2./t_water_ice;

%Calculating absorption coeffcient for each of the cases
kappa{:,1}= (-log(sum{:,1}))/0.11;
kappa{:,2}= (-log(sum{:,2}))/0.11;
kappa{:,3}= (-log(sum{:,3}))/0.11;
kappa{:,4}= (-log(sum{:,4}))/0.11;
kappa{:,5}= (-log(sum{:,5}))/0.11;
kappa{:,6}= (-log(sum{:,6}))/0.11;

%Calculating absorption coefficient based on CDOM parameterization
%kappa(lambda)=kappa(500)*exp(-0.016*(lambda-500))
kappa{:,7}= 11.3817*exp(-0.016*(w_tea-500));
kappa{:,8}= 6.0160*exp(-0.016*(w_tea2-500));
kappa{:,9}= 4.0788*exp(-0.016*(w37_tea-500));
kappa{:,10}= 2.0996*exp(-0.016*(w37_tea2-500));
kappa{:,11}= 18.3758*exp(-0.016*(w_icetea-500));
kappa{:,12}= 9.3394*exp(-0.016*(w_icetea2-500));

%Calculating absorption length based on the different cases 
absorptionlength{:,1}=1./kappa{:,1};
absorptionlength{:,2}=1./kappa{:,2};
absorptionlength{:,3}=1./kappa{:,3};
absorptionlength{:,4}=1./kappa{:,4};
absorptionlength{:,5}=1./kappa{:,5};
absorptionlength{:,6}=1./kappa{:,6};
absorptionlength{:,7}=1./kappa{:,7};
absorptionlength{:,8}=1./kappa{:,8};
absorptionlength{:,9}=1./kappa{:,11};

%Plotting data for 100 degree tea
figure(1)
set(gcf,'Position',[400 200 800 500])
set(gca,'FontName','Times')
set(gca,'FontSize',13)
yyaxis left
k1=plot(w_tea, kappa{:,1},'-');
hold on
k7=plot(w_tea, kappa{:,7},'-.');
%k7.Color(4)=0.5;
hold on
k2=plot(w_tea2, kappa{:,2},'-');
k2.Color(4)=0.3;
hold on 
k8=plot(w_tea2, kappa{:,8},'-.');
k8.Color(4)=0.3;
ylabel('Absorption coefficient [m^{-1}]')
yyaxis right
a1=plot(w_tea, absorptionlength{:,1},'-');
hold on
a2=plot(w_tea2, absorptionlength{:,2},'-');
a2.Color(4)=0.2;
hold on
ylabel('Absorption lenght [m]')
xlim([470 700])
xlabel('Wavelength [nm]')
legend('1:5 Tea (100^\circ)', 'Typical CDOM seawater','1:10 Tea (100^\circ)','Typical CDOM seawater', '1:5 Tea (100^\circ)','1:10 Tea (100^\circ)','Location','NorthWest','NumColumns',3)

figure(2) %Plotting data for 37 degree tea
set(gcf,'Position',[400 200 800 500])
set(gca,'FontName','Times')
set(gca,'FontSize',13)
yyaxis left
plot(w37_tea, kappa{:,3},'-')
hold on
k9=plot(w37_tea2, kappa{:,9},'-.');
%k9.Color(4)=0.2;
hold on
k4=plot(w37_tea, kappa{:,4},'-');
k4.Color(4)=0.3;
hold on
k10=plot(w37_tea2, kappa{:,10},'-.');
k10.Color(4)=0.3;
ylabel('Absorption coefficient [m^{-1}]')
yyaxis right
a3=plot(w37_tea, absorptionlength{:,3},'-');
hold on
a4=plot(w37_tea2, absorptionlength{:,4},'-');
a4.Color(4)=0.2;
ylabel('Absorption length [m]')
xlim([470 700])
xlabel('Wavelength [nm]')
legend('1:5 Tea (37^\circ)', 'CDOM Parameterization', '1:10 Tea (37^\circ)','CDOM Parameterization', '1:5 Tea (37^\circ)','1:10 Tea (37^\circ)','Location','NorthWest','NumColumns',3)

figure(3) %Plotting data for 100 ice tea
set(gcf,'Position',[400 200 800 500])
set(gca,'FontName','Times')
set(gca,'FontSize',13)
yyaxis left
plot(w_icetea, kappa{:,5},'-')
hold on
k12=plot(w_icetea, kappa{:,11},'-.');
%k12.Color(4)=0.2;
hold on
k6=plot(w_icetea2, kappa{:,6},'-');
k6.Color(4)=0.3;
hold on
k13=plot(w_icetea2, kappa{:,12},'-.');
k13.Color(4)=0.3;
xlim([470 700])
ylabel('Absorption coefficient [m^{-1}]')
yyaxis right
a5=plot(w_icetea, absorptionlength{:,5}, '-');
hold on
a6=plot(w_icetea, absorptionlength{:,6}, '-');
a6.Color(4)=0.2;
ylim([0 1]);
xlabel('Wavelength [nm]')
ylabel('Absorption length [m]')
legend('1:5 Ice Tea', 'CDOM Parameterization', '1:10 Ice Tea', 'CDOM Parameterization', '1:5 Ice Tea', '1:10 Ice Tea','Location','NorthWest','NumColumns',3)





