function grad = dx( img )
%DX Summary of this function goes here
% X derivative
%https://en.wikipedia.org/wiki/Five-point_stencil
% % % x=repmat(1:size(img,2),[size(img,1),1])-1;
% % % y=repmat([1:size(img,1)]',[1,size(img,2)])-1;
% % % %find the derivative using five point stencil
% % % % u1=img(x-1,y), u2=img(x-0.5,y),u3=img(x+0.5,y),u4=img(x+1,y)
% % %  grad = (1/6)*atCubic(img,x-1,y)-(4/3)*atCubic(img,x-0.5,y)+(4/3)*atCubic(img,x+0.5,y)-(1/6)*atCubic(img,x+1,y);

% grad = (1/6)*interpImg(img,y,x-1,false)-(4/3)*interpImg(img,y,x-0.5,false)+(4/3)*interpImg(img,y,x+0.5,false)-(1/6)*interpImg(img,y,x+1,false);
mask = [1 -8 0 8 -1]/12;

grad = imfilter(img, mask, 'replicate');
% I1y = imfilter(I1, mask', 'replicate');
% 
% I2x = imfilter(I2, mask, 'replicate');
% I2y = imfilter(I2, mask', 'replicate');
end

