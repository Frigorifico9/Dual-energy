%%
%Normal vectors for fit_v4
matrix_I_low_ln=log(matrix_I_low/255);
matrix_I_high_ln=log(matrix_I_high/255);

N=13;
vector_al=[];
vector_al_I_low_ln=[];
vector_al_I_high_ln=[];
for n=1:N
    vector_al=[vector_al matrix_al(n,:)];
    vector_al_I_low_ln=[vector_al_I_low_ln matrix_I_low_ln(n,:)];
    vector_al_I_high_ln=[vector_al_I_high_ln matrix_I_high_ln(n,:)];
end

plot(vector_al,vector_al_I_low_ln)

%vector_al=[vector_al(1:11) 1.92	1.92 1.92 1.92 1.92 1.92 1.92 1.92 1.92 1.92 vector_al(12:143)];

N=11;
vector_lu=[];
vector_lu_I_low_ln=[];
vector_lu_I_high_ln=[];
for n=1:N
    vector_lu=[vector_lu matrix_lu(:,n)'];
    vector_lu_I_low_ln=[vector_lu_I_low_ln matrix_I_low_ln(:,n)'];
    vector_lu_I_high_ln=[vector_lu_I_high_ln matrix_I_high_ln(:,n)'];
end

%%
%Extra data for fit_v5
matrix_al_extra_I_high_ln=log(matrix_al_extra_I_high/255);
matrix_al_extra_I_low_ln=log(matrix_al_extra_I_low/255);

for n=1:10
    vector_al=[vector_al(1:18+3*n) matrix_al_extra(n,:) vector_al(18+3*n+1:end)];
    vector_al_I_low_ln=[vector_al_I_low_ln(1:18+3*n) matrix_al_extra_I_low_ln(n,:) vector_al_I_low_ln(18+3*n+1:end)];
    vector_al_I_high_ln=[vector_al_I_high_ln(1:18+3*n) matrix_al_extra_I_high_ln(n,:) vector_al_I_high_ln(18+3*n+1:end)];
end

matrix_lu_extra_I_high_ln=log(matrix_lu_extra_I_high/255);
matrix_lu_extra_I_low_ln=log(matrix_lu_extra_I_low/255);

for n=1:8
    vector_lu=[vector_lu(1:5+8*n) matrix_lu_extra(:,n)' vector_lu(5+8*n+1:end)];
    vector_lu_I_low_ln=[vector_lu_I_low_ln(1:5+8*n) matrix_lu_extra_I_low_ln(:,n)' vector_lu_I_low_ln(5+8*n+1:end)];
    vector_lu_I_high_ln=[vector_lu_I_high_ln(1:5+8*n) matrix_lu_extra_I_high_ln(:,n)' vector_lu_I_high_ln(5+8*n+1:end)];
end

plot(vector_al,vector_al_I_low_ln)

%%

%al_1
for n=1:4
    pre_x=find(vector_al==1.92);
    x=max(pre_x);
    vector_al=[vector_al(1:x) matrix_al_extra_extra_1(n,:) vector_al(x+1:end)];
    vector_al_I_high_ln=[vector_al_I_high_ln(1:x) log(matrix_I_high_extra_extra_1(n,:)/255) vector_al_I_high_ln(x+1:end)];
    vector_al_I_low_ln=[vector_al_I_low_ln(1:x) log(matrix_I_low_extra_extra_1(n,:)/255) vector_al_I_low_ln(x+1:end)];
end


%lu_1
vector_auxiliar=[8 8 7.2 6.4 5.6 4.8 4 3.2 2.4 1.6 0.800000000000001 0 0];
for n=1:13
    pre_x=find(vector_lu==aux);
    x=min(pre_x);
    vector_lu=[vector_lu(1:x) matrix_lu_extra_extra_1(:,n)' vector_lu(x+1:end)];
    vector_lu_I_high_ln=[vector_lu_I_high_ln(1:x) log(matrix_I_high_extra_extra_1(:,n)'/255) vector_lu_I_high_ln(x+1:end)];
    vector_lu_I_low_ln=[vector_lu_I_low_ln(1:x) log(matrix_I_low_extra_extra_1(:,n)'/255) vector_lu_I_low_ln(x+1:end)];
end


%al_2
vector_auxiliar=[1.76 1.6 1.44 1.28 1.12 0.96 0.8 0.64 0.48 0.32 0.16];
for n=1:11
    pre_x=find(vector_al==vector_auxiliar(n));
    x=min(pre_x);
    vector_al=[vector_al(1:x) matrix_al_extra_extra_2(n,:) vector_al(x+1:end)];  
    vector_al_I_high_ln=[vector_al_I_high_ln(1:x) log(matrix_I_high_extra_extra_2(n,:)/255) vector_al_I_high_ln(x+1:end)];
    vector_al_I_low_ln=[vector_al_I_low_ln(1:x) log(matrix_I_low_extra_extra_2(n,:)/255) vector_al_I_low_ln(x+1:end)];
end


%lu_2
for n=1:5
    pre_x=find(vector_lu==8);
    x=min(pre_x);
    vector_lu=[vector_lu(1:x) matrix_lu_extra_extra_2(:,n)' vector_lu(x+1:end)];    
    vector_lu_I_high_ln=[vector_lu_I_high_ln(1:x) log(matrix_I_high_extra_extra_2(:,n)'/255) vector_lu_I_high_ln(x+1:end)];
    vector_lu_I_low_ln=[vector_lu_I_low_ln(1:x) log(matrix_I_low_extra_extra_2(:,n)'/255) vector_lu_I_low_ln(x+1:end)];
end
plot(vector_al,vector_al_I_low_ln)