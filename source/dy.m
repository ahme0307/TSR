function grad = dy( img )
%DY Summary of this function goes here
%   y derivative 5 point stencil 
%   https://en.wikipedia.org/wiki/Five-point_stencil
% % x=repmat(1:size(img,2),[size(img,1),1])-1;
% % y=repmat([1:size(img,1)]',[1,size(img,2)])-1;
% % %find the derivative using five point stencil
% % % u1=img(x-1,y), u2=img(x-0.5,y),u3=img(x+0.5,y),u4=img(x+1,y)
% % 
% % % grad = (1/6)*interpImg(img,y-1,x,false)-(4/3)*interpImg(img,y-0.5,x,false)+(4/3)*interpImg(img,y+0.5,x,false)-(1/6)*interpImg(img,y+1,x,false);
% %  grad = (1/6)*atCubic(img,x,y-1)-(4/3)*atCubic(img,x,y-0.5)+(4/3)*atCubic(img,x,y+0.5)-(1/6)*atCubic(img,x,y+1);
% % 
mask = [1 -8 0 8 -1]/12;

grad = imfilter(img, mask', 'replicate');
end

