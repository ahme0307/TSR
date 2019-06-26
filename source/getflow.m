function framev = getflow(I1,I2)

% smoothness of flow
lambda = 40;

% warping parameters
pyramid_levels = 1000; % as much as possible
pyramid_factor = 0.9;
warps = 1;
maxits = 50;

[flow ] = ...
    pyramidalflow(I1, I2, lambda, warps, maxits, pyramid_levels, pyramid_factor);

tmp = flow;

magnitude = (tmp(:,:,1).^2 + tmp(:,:,2).^2).^0.5;  
max_flow = prctile(magnitude(:),95);


tmp(:,:,1) = min(max(tmp(:,:,1),-max_flow),max_flow);
tmp(:,:,2) = min(max(tmp(:,:,2),-max_flow),max_flow);
framev = zeros(size(tmp,1),size(tmp,2),2);
framev(:,:,1) = tmp(:,:,1);
framev(:,:,2) = tmp(:,:,2);



