function [temp,u_mc,u_pc]=temporal_diffusion(I1c,I2c,u,v)
% start with page 7 of paper_241
% make sure the descritization is exactly the same
% 
u_mc=zeros(size(I1c));
u_pc=zeros(size(I1c));
beta=1;
lam=0.01;
Dt=0.01;
clims=[0 1];
x=repmat(1:size(I1c,2),[size(I1c,1),1]);
y=repmat([1:size(I1c,1)]',[1,size(I1c,2)]);

u_m=atCubic(rgb2gray(I1c),x-u-1,y-v-1);
u_p=atCubic(rgb2gray(I2c),x+u-1,y+v-1);

Niter=100;
epsilon=0.001;
temp=zeros(size(I1c));
mask=abs(u_p-u_m)*255<30;

for ch=1:3

I1=I1c(:,:,ch);
I2=I2c(:,:,ch);
u_m=atCubic(I1,x-u-1,y-v-1);
u_p=atCubic(I2,x+u-1,y+v-1);
I1_t=(u_m+u_p)./2;
% I_mido=I_mid;
% I_mid=(u_p);
 I1_to=I1_t;
  fprintf('*** Difusion along flow lines and on image for = %d iterations \n', Niter);
%     mask=double((abs(u_p-u_m).*255)>5).*10;
for k=1:Niter
   B_p = 1./(2.*sqrt((u_p-I1_t).*(u_p-I1_t)+epsilon));
   B_m = 1./(2.*sqrt((I1_t-u_m).*(I1_t-u_m)+epsilon));
   D_p = u_p-I1_t;
   D_m = I1_t-u_m;
   div2T=B_p.*D_p-B_m.*D_m;
   idx =B_p>B_m;
   tempdiv1=dxm(u)+dym(v);
   tempdiv2=dxm(u)+dym(v);
   div3T=B_p.*D_p.*(tempdiv1);
   div3T(idx)=-1.*B_m(idx).*D_m(idx).*tempdiv2(idx);
   gradx  = dxp(I1_t);
   grady  = dyp(I1_t);
   N_grad = sqrt(gradx.*gradx+grady.*grady+epsilon);
   D = dxm(gradx./N_grad)+ dym(grady./N_grad);
   I1_t = I1_t+Dt.*(beta.*D+lam.*(div2T+div3T)+10.*mask.*((I1_to-I1_t))); 
%     I_mid = I_mid+Dt.*(beta.*D+lam.*(div2T+div3T)+mask.*(I2-I_mid));
%           I1_t = I1_t+Dt.*(beta.*D+10.*mask.*((I1_to-I1_t))); 
 %  imagesc((I1_t), clims), axis equal; axis off; colormap(gray)
 %  pause(0.01)
end
temp(:,:,ch)=I1_t;
u_mc(:,:,ch)=u_m;
u_pc(:,:,ch)=u_p;
end
%figure,imshow(temp);
end