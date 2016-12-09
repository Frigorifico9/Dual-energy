%Uncoment to make vectors for fit
%vector_I_high=matrix_data_high(:,3);
%vector_I_high_ln=log(vector_I_high/65535);
%vector_I_low=matrix_data_low(:,3);
%vector_I_low_ln=log(vector_I_low/65535);
%weight=[matrix_data_low(:,4).*matrix_data_high(:,4)];


%First we get the image to analyze
load('master_workspace')
x=input('High image ','s');
figure
img=hisread(x, 1, 1);
figure
img=hisread(x, 2, 1);
y = input('Figure 1 or 2? (type 1 or 2 and press enter) '); %we get the right frame
img=hisread(x, y, 1);
data_high=log(img/65535); %and store it
close all
%repeat for low
x=input('Low image ','s');
figure
img=hisread(x, 1, 1);
figure
img=hisread(x, 2, 1);
y = input('Figure 1 or 2? (type 1 or 2 and press enter) '); %we get the right frame
img=hisread(x, y, 1);
data_low=log(img/65535);
close all
N=length(data_high);
p_A_al=zeros(N,N); %matrix for the aluminum coordinates
p_A_lu=zeros(N,N); %matrix for the lucite coordinates

%fill the matrices
for n=1:N 
    for j=1:N        
        p_A_al(n,j)=aaa_bhfit_al_fff086_fff087(data_high(n,j),data_low(n,j));
        p_A_lu(n,j)=aaa_bhfit_lu_fff086_fff087(data_high(n,j),data_low(n,j));
    end
end
x=input('Save basis images as: ','s');
save(x,'p_A_al','p_A_lu','data_high','data_low')