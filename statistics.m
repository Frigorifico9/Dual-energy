x=input('Image to analyze: ','s');
load(x,'p_A')
p_A(isnan(p_A)) = 0;
I=p_A;
figure
colormap ('parula')
imagesc(I)
roi=roipoly(I);
total=sum(sum(roi));
data=roi.*I;
mean=sum(sum(data))/total;
N=length(I);
sigma=0;
for n=1:N
    for m=1:N
        if data(n,m)>0
           sigma=sigma+((data(n,m)-mean)^2);
        end
    end
end
sigma=sqrt(sigma/total);

stats=[];
s = num2str(max(max(I)));
stats=[stats max(max(I))];
s = strcat('Maximum Intensity: ',s);
disp(s)
s = num2str(min(min(I)));
stats=[stats min(min(I))];
s = strcat('Minimum Intensity: ',s);
disp(s)
s = num2str(mean);
stats=[stats mean];
s = strcat('Mean Intensity: ',s);
disp(s)
c=data(:);
c(c==0) = [];
s = num2str(median(c));
stats=[stats median(c)];
s = strcat('Median Intensity: ',s);
disp(s)
s = num2str(sigma);
stats=[stats sigma];
s = strcat('Standard deviation: ',s);
disp(s)
s = num2str(sigma/sqrt(total));
stats=[stats sigma/sqrt(total)];
s = strcat('Standard deviation of the mean: ',s);
disp(s)




