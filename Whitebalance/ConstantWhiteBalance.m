% %New, 1sec, A
% c0=imread('P1030218.JPG');
% c1=imread('P1030237.JPG');
% c2=imread('P1030254.JPG');
% c3=imread('P1030270.JPG');
% c4=imread('P1030289.JPG');
% c5=imread('P1030307.JPG');
% c6=imread('P1030324.JPG');
% c7=imread('P1030342.JPG');
% c8=imread('P1030360.JPG');
% c9=imread('P1030377.JPG');
% 
% %New, 1sec, B
% c0_b=imread('P1030219.JPG');
% c1_b=imread('P1030238.JPG');
% c2_b=imread('P1030255.JPG');
% c3_b=imread('P1030271.JPG');
% c4_b=imread('P1030290.JPG');
% c5_b=imread('P1030308.JPG');
% c6_b=imread('P1030325.JPG');
% c7_b=imread('P1030343.JPG');
% c8_b=imread('P1030361.JPG');
% c9_b=imread('P1030378.JPG');


%New, 1sec, A
c0=imread('P1030458.JPG');
c1=imread('P1030464.JPG');
c2=imread('P1030472.JPG');
c3=imread('P1030479.JPG');
c4=imread('P1030489.JPG');
c5=imread('P1030497.JPG');
c6=imread('P1030501.JPG');

%New, 1sec, B
c0_b=imread('P1030459.JPG');
c1_b=imread('P1030465.JPG');
c2_b=imread('P1030473.JPG');
c3_b=imread('P1030480.JPG');
c4_b=imread('P1030490.JPG');
c5_b=imread('P1030498.JPG');
c6_b=imread('P1030502.JPG');

%Spheres
% images = {'c0', 'c1', 'c2', 'c3', 'c4', 'c5', 'c6', 'c7', 'c8', 'c9';
%            c0, c1, c2, c3, c4, c5, c6, c7, c8, c9;
%            c0_b, c1_b, c2_b, c3_b, c4_b, c5_b, c6_b, c7_b, c8_b, c9_b;};
%  

%Algae
images = {'c0', 'c1', 'c2', 'c3', 'c4', 'c5', 'c6';
           c0, c1, c2, c3, c4, c5, c6;
           c0_b, c1_b, c2_b, c3_b, c4_b, c5_b, c6_b;};

%Adjust inner loop between 7 or 10 depending on which experiment
%(spheres(10) or algae(7))
for j=1:2
    for i=1:7
        img=double([images{j+1,i}]);
        
        redChannel=img(:,:,1);
        greenChannel=img(:,:,2);
        blueChannel=img(:,:,3);
        
        allBlack = zeros(size(img,1), size(img,2), 'uint8');
        just_red=cat(3, redChannel, allBlack, allBlack);
        red_img{j,i}=just_red;
        just_green=cat(3,allBlack, greenChannel, allBlack);
        green_img{j,i}=just_green;
        just_blue=cat(3,allBlack, allBlack, blueChannel);
        blue_img{j,i}=just_blue;
        
        %Spheres; extracted area
%         img_n{j,i}=double(img(2955:2995,2893:2965,:));
        
        %Algae; extracted area
        img_n{j,i}=double(img(2780:2814,2834:2942,:));
         
        format longg
        mean_img{j,i}=mean(mean(img_n{j,i}));
        
    end
end

%Adjust inner loop between 7 or 10 depending on which experiment
%(spheres(10) or algae(7))
for j=1:1
    for i=1:7
        %Spheres, Image 3 as reference 
        %-> mean_img{i,j}(:,:,1), mean_img{i,j}(:,:,2),
        %mean_img{i,j}(:,:,3), where i and j specifies the selected images
        mn=[mean_img{1,3}(:,:,1)/mean_img{j,i}(:,:,1); mean_img{1,3}(:,:,2)/mean_img{j,i}(:,:,2);mean_img{1,3}(:,:,3)/mean_img{j,i}(:,:,3)];
        mn_2=[mean_img{2,3}(:,:,1)/mean_img{j+1,i}(:,:,1);mean_img{2,3}(:,:,2)/mean_img{j+1,i}(:,:,2);mean_img{2,3}(:,:,3)/mean_img{j+1,i}(:,:,3)];
        
        %Algae, Image 2 as reference
%         mn=[mean_img{1,2}(:,:,1)/mean_img{j,i}(:,:,1);mean_img{1,2}(:,:,2)/mean_img{j,i}(:,:,2);mean_img{1,2}(:,:,3)/mean_img{j,i}(:,:,3)];
%         mn_2=[mean_img{2,2}(:,:,1)/mean_img{j+1,i}(:,:,1);mean_img{2,2}(:,:,2)/mean_img{j+1,i}(:,:,2);mean_img{2,2}(:,:,3)/mean_img{j+1,i}(:,:,3)];         

        %Multiple the calculated values with the RGB values of each of the
        %images
        sum1=red_img{1,i}(:,:,:).*mn(1);
        sum2=green_img{1,i}(:,:,:).*mn(2);
        sum3=blue_img{1,i}(:,:,:).*mn(3);
        
        sum1_2=red_img{2,i}(:,:,:).*mn_2(1);
        sum2_2=green_img{2,i}(:,:,:).*mn_2(2);
        sum3_2=blue_img{2,i}(:,:,:).*mn_2(3);

        %Recombines the images
        recombinedRGBImage=cat(3,sum1(:,:,1),sum2(:,:,2),sum3(:,:,3));
        recombinedRGBImage_2=cat(3,sum1_2(:,:,1),sum2_2(:,:,2),sum3_2(:,:,3));
        
        recombined_img{j,i}=recombinedRGBImage;
        recombined_img{j+1,i}=recombinedRGBImage_2;    
    end
end


%Adjust inner loop between 7 or 10 depending on which experiment
%(spheres(10) or algae(7))
for j=1:1
    for i=1:7
        %Plotting the recombined images
        figure(i)
    
        subplot(2,2,1)
        imshow(images{j+1,i})
        title('Original', 'FontSize', 20)
        hold on
        
        subplot(2,2,2)
        imshow(recombined_img{j,i});
        title('Recombined', 'FontSize', 20)
        hold on
        
        subplot(2,2,3)
        imshow(images{j+2,i})
        title('Original (Cross polarization)', 'FontSize', 20)
        hold on
          
        subplot(2,2,4)
        imshow(recombined_img{j+1,i});
        title('Recombined (Cross polarization) ', 'FontSize', 20)
    end
end



  