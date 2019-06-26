function [I_mid,u_m,u_p,framev]=getmidframe(I1,I2)




I1t=double(I1);
I2t=double(I2);


if size(I1,3)==3
    
    I1g=im2double(rgb2gray(I1));
    I2g=im2double(rgb2gray(I2));
else
    I1g=im2double(I1);
    I2g=im2double(I2);
end

framev=getflow(I1g,I2g);

[I_mid,u_m,u_p] =temporal_diffusion(I1t./255,I2t./255,framev(:,:,1),framev(:,:,2));
end


