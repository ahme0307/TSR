
function [u, v, w, p] = tv_l1_textural(I1, I2, u, v, w, p, lambda, ...
                                                warps, maxits, scale)


gr=0.6;

[M N C] = size(I1);

% stepwidth
L = sqrt(8);

tau = 1/L;
sigma = 1/L;

u_ = u;
v_ = v;
w_ = w;

% some parameters
epsilon_u = 0;
epsilon_w = 0;
gamma = 0.02;

for k=1:2
  u0 = u;
  v0 = v;
  

      
     idx=repmat(1:size(I1,2),[size(I1,1),1]);
     idy=repmat([1:size(I1,1)]',[1,size(I1,2)]);
     I1mv=atCubic(I1,idx-u-1,idy-v-1);
     I2pv=atCubic(I2,idx+u-1,idy+v-1);

     
     dxI=dx(I2pv)+dx(I1mv);
     dyI=dy(I2pv)+dy(I1mv);

     [I12t,dxIt,dyIt] = lbpdxdy( I1,I2,u,v);

     dxI=(dxI+gr.*dxIt);
     dyI=(dyI+gr.*dyIt);
     I_grad_sqr = max(1e-09, dxI.^2 + dyI.^2  +gamma*gamma);  
 
  for k = 0:maxits-1
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % DUAL
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % compute derivatives
   
    u_x = dxp(u_);
    u_y = dyp(u_);
    
    v_x = dxp(v_);
    v_y = dyp(v_);
  
    w_x = dxp(w_);
    w_y = dyp(w_);
    
    % update dual variable
    p(:,:,1) = (p(:,:,1) + sigma*u_x)/(1 + sigma*epsilon_u);
    p(:,:,2) = (p(:,:,2) + sigma*u_y)/(1 + sigma*epsilon_u);

    p(:,:,3) = (p(:,:,3) + sigma*v_x)/(1 + sigma*epsilon_u);
    p(:,:,4) = (p(:,:,4) + sigma*v_y)/(1 + sigma*epsilon_u);
    
    p(:,:,5) = (p(:,:,5) + sigma*w_x)/(1 + sigma*epsilon_w);
    p(:,:,6) = (p(:,:,6) + sigma*w_y)/(1 + sigma*epsilon_w);    
    
    % reprojection to |pu| <= 1
    reprojection = max(1.0, sqrt(p(:,:,1).^2 + p(:,:,2).^2 + p(:,:,3).^2 + p(:,:,4).^2));
    p(:,:,1) = p(:,:,1)./reprojection;
    p(:,:,2) = p(:,:,2)./reprojection;
    p(:,:,3) = p(:,:,3)./reprojection;
    p(:,:,4) = p(:,:,4)./reprojection;
    
    reprojection = max(1.0, sqrt(p(:,:,5).^2 + p(:,:,6).^2));
    p(:,:,5) = p(:,:,5)./reprojection;
    p(:,:,6) = p(:,:,6)./reprojection;
    
  
    
    % compute divergence
    
    div_u = dxm(p(:,:,1)) + dym(p(:,:,2));
    div_v = dxm(p(:,:,3)) + dym(p(:,:,4));
    div_w = dxm(p(:,:,5)) + dym(p(:,:,6));
    
    % remember old u,v,w
    u_ = u;
    v_ = v;
    w_ = w;
    
    % update u,v,w
    u = u + tau*(div_u);
    v = v + tau*(div_v);
    w = w + tau*(div_w);
    
    % prox operator for u,v,w
  
     rho=I2pv-I1mv+ gr.*I12t+(u-u0).*(dxI) + (v-v0).*(dyI) + gamma*w;

    idx1 = rho      < - tau*lambda*I_grad_sqr;
    idx2 = rho      >   tau*lambda*I_grad_sqr;
    idx3 = abs(rho) <=  tau*lambda*I_grad_sqr;
    
    u(idx1) = u(idx1) + tau*lambda*dxI(idx1);
    v(idx1) = v(idx1) + tau*lambda*dyI(idx1);
    w(idx1) = w(idx1) + tau*lambda*gamma;
    
    u(idx2) = u(idx2) - tau*lambda*dxI(idx2);
    v(idx2) = v(idx2) - tau*lambda*dyI(idx2);
    w(idx2) = w(idx2) - tau*lambda*gamma;
    
    u(idx3) = u(idx3) - rho(idx3).*dxI(idx3)./I_grad_sqr(idx3);
    v(idx3) = v(idx3) - rho(idx3).*dyI(idx3)./I_grad_sqr(idx3);
    w(idx3) = w(idx3) - rho(idx3).*gamma./I_grad_sqr(idx3);
    
     u_ = 2*u - u_;
     v_ = 2*v - v_;
     w_ = 2*w - w_;

  end
  
  % filter strong outliers
  u = peakfilt(u);
  v = peakfilt(v);
end