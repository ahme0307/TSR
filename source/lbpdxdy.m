function [I12t,dxIt,dyIt] = lbpdxdy( I1,I2,u,v )
%LBPDXDY Summary of this function goes here
%   Detailed explanation goes her
% [I1t,I2pt,dxIt,dyIt] = lbpdxdy( I1,I2,u,v )


global imMask;
J = imresize(imMask, size(I1)); 
L5=[1 4 6 4 1];E5=[-1 -2 0 2 1];S5=[-1 0 2 0 -1];R5=[1 -4 6 -4 1];

   Cmask1=L5'*E5;Cmask2=E5'*L5;
      [I1_lbp_mv_temp{1},I2_lbp_pv_temp{1}]= findResponse(I1,I2,Cmask1,Cmask2);
   
   Cmask1=L5'*R5;Cmask2=R5'*L5;
      [I1_lbp_mv_temp{2},I2_lbp_pv_temp{2}]= findResponse(I1,I2,Cmask1,Cmask2);
      
  Cmask1=E5'*S5;Cmask2=S5'*E5;
      [I1_lbp_mv_temp{3},I2_lbp_pv_temp{3}]= findResponse(I1,I2,Cmask1,Cmask2);
   

  Cmask1=S5'*S5;
      [I1_lbp_mv_temp{4},I2_lbp_pv_temp{4}]= findResponse(I1,I2,Cmask1);
 

  Cmask1=R5'*R5;
      [I1_lbp_mv_temp{5},I2_lbp_pv_temp{5}]= findResponse(I1,I2,Cmask1);

  Cmask1=L5'*S5;Cmask2=S5'*L5;
      [I1_lbp_mv_temp{6},I2_lbp_pv_temp{6}]= findResponse(I1,I2,Cmask1,Cmask2);
      
%   Cmask1=[ 1 1  1;  1  -1  1  ; 1  1 1];
%       [I1_lbp_mv_temp{7},I2_lbp_pv_temp{7}]= findResponse(I1,I2,Cmask1);

  Cmask1=E5'*E5;
      [I1_lbp_mv_temp{7},I2_lbp_pv_temp{7}]= findResponse(I1,I2,Cmask1);

  Cmask1=E5'*R5; Cmask2=R5'*E5;
      [I1_lbp_mv_temp{8},I2_lbp_pv_temp{8}]= findResponse(I1,I2,Cmask1,Cmask2);

  Cmask1=S5'*R5; Cmask2=R5'*S5;
      [I1_lbp_mv_temp{9},I2_lbp_pv_temp{9}]= findResponse(I1,I2,Cmask1,Cmask2);
  [I1_lbp_mv,I2_lbp_pv]=FinalTEXmap(I1_lbp_mv_temp,I2_lbp_pv_temp);
    


I1_lbp_mv=I1_lbp_mv.*J;
I2_lbp_pv=I2_lbp_pv.*J;
% I1_lbp_mv=(I1_lbp_mv-min(I1_lbp_mv(:)))/(max(I1_lbp_mv(:))-min(I1_lbp_mv(:)));
I1_lbp_mv = I1_lbp_mv - min(I1_lbp_mv(:)) ;
I1_lbp_mv = I1_lbp_mv / max(I1_lbp_mv(:)) ;

I2_lbp_pv = I2_lbp_pv - min(I2_lbp_pv(:)) ;
I2_lbp_pv = I2_lbp_pv / max(I2_lbp_pv(:)) ;
idx=repmat(1:size(I1,2),[size(I1,1),1]);
idy=repmat([1:size(I1,1)]',[1,size(I1,2)]);
I1mv=atCubic(I1_lbp_mv,idx-u-1,idy-v-1);
I2pv=atCubic(I2_lbp_pv,idx+u-1,idy+v-1);
dxI1=dx((I1mv));
dxI2=dx((I2pv));
dxIt=dxI1+dxI2;
dyI1=dy((I1mv));
dyI2=dy((I2pv));
dyIt=dyI1+dyI2;
I12t=I2pv-I1mv;
end



function [I1_lbp_mv,I2_lbp_pv]= findResponse(varargin)
    I1=varargin{1};I2=varargin{2};Cmask1=varargin{3};
     Gmask=ones(15);
     global imMask;
    if nargin==4
        Cmask2=varargin{4};
        I1temp=imfilter(I1,Cmask1);
        I2temp=imfilter(I2,Cmask1);
        I1temp=imfilter(abs(I1temp),Gmask);
        I2temp=imfilter(abs(I2temp),Gmask);

    
        I1temp2=imfilter(I1,Cmask2);
        I2temp2=imfilter(I2,Cmask2);
        I1temp2=imfilter(abs(I1temp2),Gmask);
        I2temp2=imfilter(abs(I2temp2),Gmask);
        I1_lbp_mv=wfusmat(I1temp,I1temp2,'mean');
        I2_lbp_pv=wfusmat(I2temp,I2temp2,'mean');
    else
         I1_lbp_mv=imfilter(I1,Cmask1);
         I2_lbp_pv=imfilter(I2,Cmask1);
         I1_lbp_mv=imfilter(abs(I1_lbp_mv),Gmask);
         I2_lbp_pv=imfilter(abs(I2_lbp_pv),Gmask);
        
    end
    J = imresize(imMask, size(I1_lbp_mv)); 
    I1_lbp_mv=I1_lbp_mv.*J;
    I2_lbp_pv=I2_lbp_pv.*J;
    I1_lbp_mv = I1_lbp_mv - min(I1_lbp_mv(:)) ;
    I1_lbp_mv = I1_lbp_mv / max(I1_lbp_mv(:)) ;

    I2_lbp_pv = I2_lbp_pv - min(I2_lbp_pv(:)) ;
    I2_lbp_pv = I2_lbp_pv / max(I2_lbp_pv(:)) ;

end

function [I1_lbp_mv,I2_lbp_pv]=FinalTEXmap(I1_lbp_mv_temp,I2_lbp_pv_temp)
Gmask=ones(3); 
temp1=zeros(size(I1_lbp_mv_temp{1}));
temp2=zeros(size(I1_lbp_mv_temp{1}));
I1_lbp_mv=zeros(size(I1_lbp_mv_temp{1}));
I2_lbp_pv=zeros(size(I1_lbp_mv_temp{1}));

    for kk=1:size(I1_lbp_mv_temp,2) 
           temp1_acc{kk}=imfilter((dxp(I1_lbp_mv_temp{kk})+dyp(I1_lbp_mv_temp{kk})),Gmask);
           temp2_acc{kk}=imfilter((dxp(I2_lbp_pv_temp{kk})+dyp(I2_lbp_pv_temp{kk})),Gmask);
           temp1=temp1+ temp1_acc{kk};
           temp2=temp2+ temp2_acc{kk};

    end
    for kk=1:size(I1_lbp_mv_temp,2) 
           I1_lbp_mv=I1_lbp_mv+ I1_lbp_mv_temp{kk}.*((temp1_acc{kk})./(temp1+1));
           I2_lbp_pv=I2_lbp_pv+ I2_lbp_pv_temp{kk}.*((temp2_acc{kk})./(temp2+1));
    end
end

function [dx] = dxp(u)
    [M N] = size(u);
    dx = [u(:,2:end) u(:,end)] - u;
    dx=abs(dx);
end
function [dy] = dyp(u)
    [M N] = size(u);
    dy = [u(2:end,:); u(end,:)] - u;
    dy=abs(dy);
end