function I = KFimageAdd(scatname,imnum1,imnum2,imnum3,imnum4)
%**************************************************************************
%Add low mAs images together and subtract background (no sample) image
%This function also gives the option to adjust the window minimum and
%maximum values, fix dark spots created by the sample blocking x-rays found
%in the background, and create radial profiles. These changes are
%performed through an interactive question/answer with the user
%
%
%KFimageAdd.m
%
%   Purpose:      To read in multiple his files using KFhisread (which
%                 outputs tif files), subtract the background image from 
%                 each tif image, and add the resulting images together.
%                 Also gives the option to perform various other tweaks and
%                 analysis on the resulting image. 
%
%   Author:   Kelly Foran
%   Created:      June 16, 2016
%   Last Updated: July 4, 2016 
%
%
%   INPUT
%
%   scatname: name of the setup in my file naming scheme
%   imnum1,imnum2,imnum3: image numbers in my file naming scheme
%   imnum4: image number of the background in my file naming scheme
%
%   OUTPUT
%
%   I: the background subtracted x-ray image
%   Can also output radial profiles
%
%   Note: This program is designed specifically for my file names. In order
%   to reuse, the user must change the sprintf path to denote the names of
%   their image and background files.
%*******************************************************************************

%read in .his files from detector and save images as .tif files
KFhisread(scatname,imnum1,1,2,1);
KFhisread(scatname,imnum2,2,2,1);
KFhisread(scatname,imnum3,3,2,1);
KFhisread(scatname,imnum4,0,2,1);

%read in those .tif files as image matrices
I1T = imread(sprintf('kf%d-%s%d.tif',imnum1,scatname,1));
I2T = imread(sprintf('kf%d-%s%d.tif',imnum2,scatname,2));
I3T = imread(sprintf('kf%d-%s%d.tif',imnum3,scatname,3));
IBT = imread(sprintf('kf%d-%s%d.tif',imnum4,scatname,0));

%subtract the background image from each of the three scatter images
I1B = imsubtract(I1T,IBT);
I2B = imsubtract(I2T,IBT);
I3B = imsubtract(I3T,IBT);

%add the background subtracted images together
I12 = imadd(I1B,I2B);
I = imadd(I12,I3B);

%save the resulting image as a .tif file
finaltiff = sprintf('kf%d-%dScatterImage.tif',imnum1,imnum4);
imwrite(I,finaltiff,'tif');

G = imread(finaltiff);

ready = false;
prompt1 = 'Enter window minimum';
prompt2 = 'Enter window maximum';
prompt3 = 'Is the brightness satisfactory? Y or N';
while ~ready
   x = input(prompt1);
   y = input(prompt2);
   clim = [x y];
   imagesc(G,clim); colormap(gray); colorbar;
   str = input(prompt3,'s');
   if str == 'Y' 
       ready = true;
   elseif str == 'y'
       ready = true;
   else 
       ready = false;
   end  
end 
xnew = x/66535;
ynew = y/66535;
GG = imadjust(G,[xnew ynew],[]);
imwrite(GG,finaltiff,'tif');


prompt4 = 'Dark circle correction. How many areas would you like to fix?';
prompt5 = 'Click on the center of the area with the crosshairs. Press Y to continue';
prompt6 = 'Click on an edge point of the area with the crosshairs. Press Y to continue';
ans1 = input(prompt4);
ans3 = ans1*2;
if ans3 >0 
    for z = 1:ans3
        if mod(z,2)== 0
            ans4 = input(prompt6,'s');
            if ans4 == 'Y'
                [k(z),f(z)] = ginput(1);
            elseif ans4 == 'y'
                [k(z),f(z)] = ginput(1);
            end
        else 
            ans2 = input(prompt5,'s');
            if ans2 == 'Y'
                [k(z),f(z)] = ginput(1);
            elseif ans2 == 'y'
                [k(z),f(z)] = ginput(1);
            end
        end
    end
    CI = false(512,512);
    [xc, yc] = meshgrid(1:512, 1:512);
    for w = 1:ans3
        if mod(w,2) == 0
            t = w-1;
            r(t) = ((k(t)-k(w)).^2 + (f(t)-f(w)).^2).^(0.5);
            cx(t) = k(t);
            cy(t) = f(t);
            CI((xc - cx(t)).^2 + (yc - cy(t)).^2 <= r(t).^2) = true;
        end
    end
    masked = imread(sprintf('kf%d-%s%d.tif',imnum4,scatname,0));
    masked(~CI) = 0;
    yes = false;
    prompt7 = 'Is this circle amount okay? Enter Y or N.';
    prompt8 = 'Enter the percent attenuated by the sample';
    while ~yes
       percent = input(prompt8);
       circs = immultiply(masked,percent);
       back = imread(sprintf('kf%d-%s%d.tif',imnum4,scatname,0));
       scaledBack = imsubtract(back,circs);
       S1B = imsubtract(I1T,scaledBack);
       S2B = imsubtract(I2T,scaledBack);
       S3B = imsubtract(I3T,scaledBack);

       S12 = imadd(S1B,S2B);
       S = imadd(S12,S3B);
       SS = imadjust(S,[xnew ynew],[]);
       imshow(SS)
       reply1 = input(prompt7,'s');
       if reply1 == 'Y' 
           yes = true;
       elseif reply1 == 'y'
           yes = true;
       else 
           yes = false;
       end  
   end 
  imwrite(SS,finaltiff,'tif');
end

promptX= 'How many radial scatter profiles would you like to create?';
promptY= 'Is this profile circular or elliptical. Type E or C.';
promptAA= 'What angle is this elliptical profile from the x axis, counterclockwise?';
promptA= 'Click on the centre of the profile with the crosshairs. Press Y to continue';
promptB= 'Click on the edge of the area with the crosshairs. Press Y to continue';
promptBB= 'You will now be asked to complete a series of questions about each profile. Complete all the prompts for one profile at a time and remember the order in which you identified the profiles. Type anything to continue.';

rad=input(promptX);
rad2=rad*2;


if rad2>0
    noans=input(promptBB);
    for n= 1:rad2
        if mod(n,2)==0
            an=input(promptB,'s');
            if an=='Y'
                [ex(n),ey(n)]=ginput(1);
            elseif an=='y'
                [ex(n),ey(n)]=ginput(1);
            end
        else
            an3=input(promptY,'s');
            if an3== 'E'
                angg(n)=input(promptAA);
                anggg(n)=3.5;
            elseif an3== 'e'
                angg(n)=input(promptAA);
                anggg(n)=3.5;
            else
                anggg(n)=0;
                angg(n)=0;
            end
            an2=input(promptA,'s');
            if an2=='Y'
                [xc(n),yc(n)]=ginput(1);
            elseif an2=='y'
                [xc(n),yc(n)]=ginput(1); 
            end
        end    
    end
    for u=2:rad2
        m=u-1;
        if mod(u,2)==0
            ellipticalprofile(xc(m),yc(m),ex(u),ey(u),angg(m),imnum1,imnum4,anggg(m),m);
        end
    end
   
end           
       

end
  