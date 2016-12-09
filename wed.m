x=input('Image to analyze: ','s');
load(x,'p_A')
figure
colormap colorcube
imagesc(p_A)
s = strcat(x,'.jpg');
saveas(gcf,s)