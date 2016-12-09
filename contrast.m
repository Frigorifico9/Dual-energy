x=input('Image to analyze: ','s');
load(x,'p_A')
p_A(isnan(p_A)) = 0;
%p_A=p_A.';
figure
colormap colorcube
imagesc(p_A)
[x,y] = ginput(4);
data_sample=p_A(round(y(1)):round(y(2)),round(x(1)):round(x(2)));
close all
dis_x_sample=abs(x(2)-x(1));
dis_sample=abs(y(2)-y(1));
d=1;
if dis_x_sample<dis_sample
    dis_sample=dis_x_sample;
    d=2;
end
data_sample=sum(data_sample,d)/dis_sample;

data_bg=p_A(round(y(3)):round(y(4)),round(x(3)):round(x(4)));
dis_x_bg=abs(x(4)-x(3));
dis_bg=abs(y(4)-y(3));
d=1;
if dis_x_bg<dis_bg
    dis_bg=dis_x_bg;
    d=2;
end
data_bg=sum(data_bg,d)/dis_bg;
%bk

figure
plot(data_sample)
title('Intensity vs position')
hold on
plot(data_bg)
x=input('Save plots as: ','s');
saveas(gcf,x)

%%

contrast_value=mean(data_sample)/mean(data_bg);

I=data_sample;
stats=zeros(5);
s = num2str(max(max(I)));
s = strcat('Smple maximum Intensity: ',s);
disp(s)
s = num2str(min(min(I)));
s = strcat('Sample minimum Intensity: ',s);
disp(s)
s = num2str(mean(I));
stats(1)=mean(I);
s = strcat('Sample mean Intensity: ',s);
disp(s)
s = num2str(median(I));
s = strcat('Sample median Intensity: ',s);
disp(s)
s = num2str(std(I));
stats(3)=std(I);
s = strcat('Sample standard deviation: ',s);
disp(s)

I=data_bg;
s = num2str(max(max(I)));
s = strcat('background maximum Intensity: ',s);
disp(s)
s = num2str(min(min(I)));
s = strcat('background minimum Intensity: ',s);
disp(s)
s = num2str(mean(I));
stats(2)=mean(I);
s = strcat('background mean Intensity: ',s);
disp(s)
s = num2str(median(I));
s = strcat('background median Intensity: ',s);
disp(s)
s = num2str(std(I));
stats(4)=std(I);
s = strcat('background standard deviation: ',s);
disp(s)
disp(' ')
s=num2str(contrast_value);
stats(5)=contrast_value;
s = strcat('Contrast: ',s);
disp(s)

stats=stats(:,1);