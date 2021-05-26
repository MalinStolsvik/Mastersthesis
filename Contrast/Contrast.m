%Input images (1sec f/4) Parallel polarizing filters
c0=imread('P1030218.JPG');
c1=imread('P1030237.JPG');
c2=imread('P1030254.JPG');
c3=imread('P1030270.JPG');
c4=imread('P1030289.JPG');
c5=imread('P1030307.JPG');
c6=imread('P1030324.JPG');
c7=imread('P1030342.JPG');
c8=imread('P1030360.JPG');
c9=imread('P1030377.JPG');

%Input images (1sec f/4) Perpendicular polarizing filters
c0_b=imread('P1030219.JPG');
c1_b=imread('P1030238.JPG');
c2_b=imread('P1030255.JPG');
c3_b=imread('P1030271.JPG');
c4_b=imread('P1030290.JPG');
c5_b=imread('P1030308.JPG');
c6_b=imread('P1030325.JPG');
c7_b=imread('P1030343.JPG');
c8_b=imread('P1030361.JPG');
c9_b=imread('P1030378.JPG');


%White image
whiteImage=255*ones(3456,4680,3,'uint8');


%Including all the images in a cell array
images = {'c0', 'c1', 'c2', 'c3', 'c4', 'c5', 'c6', 'c7', 'c8', 'c9';
           c0, c1, c2, c3, c4, c5, c6, c7, c8, c9;
           c0_b, c1_b, c2_b, c3_b, c4_b, c5_b, c6_b, c7_b, c8_b, c9_b;
           whiteImage,whiteImage,whiteImage,whiteImage,whiteImage,whiteImage,whiteImage,whiteImage,whiteImage,whiteImage;};

%Defining the concentrations for the different images         
concentration={'c0', 'c1', 'c2', 'c3', 'c4', 'c5', 'c6', 'c7', 'c8', 'c9';
               0,8.90e11 1.53e13, 2.97e13, 4.41e13, 5.85e13, 7.28e13, 8.72e13, 1.02e14, 1.16e14;};      


%Defining arrays
grayfish_weber=cell(5,10);
grayback_weber=cell(5,10);
c_weber=cell(5,10);
meanfishw=cell(5,10);
meanbackw=cell(5,10);

for j=1:2
    for i=1:10
        %%Calculates the contrast based on one area of the object
        %Retrieving one image
        image_weber= [images{j+1,i}];
        
        %Retrieving one area of the object and the background
        grayfish_weber{j,i} = double(rgb2gray(image_weber(2061:2246,1779:2181,:)));
        grayback_weber{j,i} = double(rgb2gray(image_weber(2503:2623,1779:2181,:)));
        
        %Calculating the contrast
        meanfishw{j,i}=mean(mean(grayfish_weber{j,i}));
        meanbackw{j,i}=mean(mean(grayback_weber{j,i}));
        c_weber{j,i}=((meanfishw{j,i}-meanbackw{j,i})/meanbackw{j,i});
        
        %%Calculates the contrast based on one area of the object
         %Area1
         w_f_1{j,i}=double(rgb2gray(image_weber(2061:2154,1779:1980,:)));
         w_b_1{j,i}=double(rgb2gray(image_weber(2503:2563,1779:1980,:)));
         m_f_1{j,i}=mean(mean(w_f_1{j,i}));
         m_b_1{j,i}=mean(mean(w_b_1{j,i}));
         w_1{j,i}=(m_f_1{j,i}-m_b_1{j,i})/m_b_1{j,i};

         %Area2
         w_f_2{j,i}=double(rgb2gray(image_weber(2154:2246,1779:1980,:)))/255;
         w_b_2{j,i}=double(rgb2gray(image_weber(2563:2623,1779:1980,:)))/255;
         m_f_2{j,i}=mean(mean(w_f_2{j,i}));
         m_b_2{j,i}=mean(mean(w_b_2{j,i}));
         w_2{j,i}=(m_f_2{j,i}-m_b_2{j,i})/m_b_2{j,i};


         %Area3
         w_f_3{j,i}=double(rgb2gray(image_weber(2061:2154,1980:2181,:)))/255;
         w_b_3{j,i}=double(rgb2gray(image_weber(2503:2563,1980:2181,:)))/255;
         m_f_3{j,i}=mean(mean(w_f_3{j,i}));
         m_b_3{j,i}=mean(mean(w_b_3{j,i}));
         w_3{j,i}=(m_f_3{j,i}-m_b_3{j,i})/m_b_3{j,i};


         %Area4
         w_f_4{j,i}=double(rgb2gray(image_weber(2154:2246,1980:2181,:)))/255;
         w_b_4{j,i}=double(rgb2gray(image_weber(2563:2623,1980:2181,:)))/255;
         m_f_4{j,i}=mean(mean(w_f_4{j,i}));
         m_b_4{j,i}=mean(mean(w_b_4{j,i}));
         w_4{j,i}=(m_f_4{j,i}-m_b_4{j,i})/m_b_4{j,i};
    end
end

for j=1:2
    for i=1:10       
        a{i,j}=[w_1{j,i} w_2{j,i} w_3{j,i} w_4{j,i}];
        
        %Calculating the average contrast based on the four areas
        x{j,i}=mean(a{i,j});
        
        %Calculating the standard deviation based on the four areas       
        s{j,i}=std(a{i,j});
    end
end


for i=1:10
    parallel_1=c_weber{1,i};
    perpendicular_1=c_weber{2,i};
  
    par_m=x{1,i};
    per_m=x{2,i};
    
    %Calculating how much better or worse it is to photograph with cross-polarization
    difference{1,i}=perpendicular_1/parallel_1;
    difference{2,i}=per_m/par_m;
end


concentrationarray= [concentration{2,:}];
test=[1 2 3 4 5 6 7 8 9 10]; 

figure (1)
plot(concentrationarray, [c_weber{1,:}], '.-')
hold on
plot(concentrationarray, [c_weber{2,:}], '.-')
legend({'Parallel', 'Perpendicular'},'location','northeast');
xlabel('Concentration [1/m^3]')
ylabel('Contrast')
set(gcf,'Position',[400 200 800 500])
set(gca,'FontName','Times')
set(gca,'FontSize',13)

figure(2)
plot(concentrationarray, [x{1,:}], '.-')
hold on
plot(concentrationarray, [x{2,:}], '.-')
legend({'Parallel', 'Perpendicular'},'location','northeast');
xlabel('Concentration [1/m^3]')
ylabel('Contrast')
set(gcf,'Position',[400 200 800 500])
set(gca,'FontName','Times')
set(gca,'FontSize',13)


figure(3)
plot(test,[difference{1,:}],'.-', 'Color',[0.9290 0.6940 0.1250]);
hold on
plot(test,[difference{2,:}],'.-', 'Color',[0.9290 0.6940 0.1250]);
xlabel('Scattering particles per volume')
ylabel('Ratio')
legend({'1s f/4','1s f/4 different areas'},'location','northeast');
set(gcf,'Position',[400 200 800 500])
set(gca,'FontName','Times')
set(gca,'FontSize',13)


