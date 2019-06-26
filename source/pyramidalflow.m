
function [flow] = pyramidalflow(I1, I2, lambda, warps, maxits, ...
                                 pyramid_levels, pyramid_factor)

[M N C] = size(I1);

num_dual_vars = 6;

width_Pyramid = cell(pyramid_levels,1);
height_Pyramid = cell(pyramid_levels,1);

I1_Pyramid = cell(pyramid_levels,C);
I2_Pyramid = cell(pyramid_levels,C);

% precompute image sizes
width_Pyramid{1} = N;
height_Pyramid{1} = M;


for i = 2:pyramid_levels
  width_Pyramid{i} = pyramid_factor*width_Pyramid{i-1};
  height_Pyramid{i} = pyramid_factor*height_Pyramid{i-1};
  if min(width_Pyramid{i}, height_Pyramid{i}) < 16
    pyramid_levels = i;
    break;
  end
end
for i = 1:pyramid_levels
  width_Pyramid{i} = round(width_Pyramid{i});
  height_Pyramid{i} = round(height_Pyramid{i});
end

% set up image pyramides
for i = 1:pyramid_levels
  if i == 1
    for j=1:C
     I1_Pyramid{1,j}=  imfilter(I1(:,:,j),fspecial('gaussian',5,0.67),...
                                  'same','replicate');
     I2_Pyramid{1,j}=  imfilter(I2(:,:,j),fspecial('gaussian',5,0.67),...
                                  'same','replicate');
    end
  else
    for j=1:C    
        I1_Pyramid{i,j}=imresize(imfilter(I1_Pyramid{i-1,j},fspecial('gaussian',5,0.67),...
                                   'same','replicate'), [height_Pyramid{i} width_Pyramid{i}],'bicubic');
        I2_Pyramid{i,j}=imresize(imfilter(I2_Pyramid{i-1,j},fspecial('gaussian',5,0.67),...
                                   'same','replicate'), [height_Pyramid{i} width_Pyramid{i}],'bicubic'); 
                              
    end
  end
end

for level = pyramid_levels:-1:1
  
  scale = pyramid_factor^(level-1);
  
  M = height_Pyramid{level};
  N = width_Pyramid{level};
 
  if level == pyramid_levels
 
    % initialization  
    u = zeros(M,N);
    v = zeros(M,N);
    w = zeros(M,N);
    p = zeros(M,N,num_dual_vars);   
  else
    rescale_factor_u = width_Pyramid{level+1}/width_Pyramid{level};
    rescale_factor_v = height_Pyramid{level+1}/height_Pyramid{level};
    
    % prolongate to finer grid    
    u = imresize(u,[M N], 'bicubic')/rescale_factor_u;    
    v = imresize(v,[M N], 'bicubic')/rescale_factor_v;
    w = imresize(w, [M N], 'bicubic');
   
    p_tmp = p;
    p = zeros(M,N,num_dual_vars); 
    for i=1:num_dual_vars
      p(:,:,i) = imresize(p_tmp(:,:,i),[M N], 'nearest');
    end
  end
  
  I1 = zeros(M,N,C);
  I2 = zeros(M,N,C);
  for j=1:C
    I1(:,:,j) = I1_Pyramid{level,j};
    I2(:,:,j) = I2_Pyramid{level,j};
  end
  
  fprintf('*** level = %d\n', level);
 
  [u, v, w, p] = tv_l1_textural(I1, I2, u, v, w, p, lambda, ...
                                                warps, maxits, scale);

end

flow = zeros(M,N,2);
flow(:,:,1) = u;
flow(:,:,2) = v;

