filename='4_C2_6mm_polyp_B_cut';
vid_folder ='.\LRvideos';
Rdir='./Result/';
filename=[vid_folder,'/',filename];
[folder_name,name,~] = fileparts(filename); 
global imMask;
imMask=logical((imread('B_mask.png')));
filename=[filename, '.wmv']
newfilenames= regexprep(filename,'.wmv','');
if exist(filename, 'file') == 2&&exist(newfilenames, 'file')~=7
    Vd=VideoReader(filename);
    newfilenames= regexprep(filename,'.wmv','');
    count=1;
    mkdir(newfilenames);
    savdir =folder_name;
    prev_video=0;
    while hasFrame(Vd)
      video = readFrame(Vd);
      if(sum(sum(sum((video-prev_video))))==0)
         continue;
      end
     imwrite(video,  fullfile(savdir,name,strcat(name,num2str(count),'.png')));
        prev_video=video;
     count=count+1;
    end
 
else
    savdir = folder_name;
end


IO_Folder=sprintf('./%s',newfilenames);
pngfiles = dir([IO_Folder '/*.png']);

v = VideoWriter(sprintf('%s_out',strcat(newfilenames,'TSR')));
v.FrameRate = 10;
open(v)

file2=0;
for k=1:size(pngfiles,1)-1
    file1=imread(fullfile(savdir,name,strcat(name,num2str(k),'.png')));
    file2=imread(fullfile(savdir,name,strcat(name,num2str(k+1),'.png')));
    
    I_mid=getmidframe(file1,file2);  
    I_mid=uint8(I_mid*255);
    
    writeVideo(v,(file1));
    writeVideo(v,I_mid);
%     writeVideo(v,rgb2gray(file2));
end
writeVideo(v,(file2));
close(v)