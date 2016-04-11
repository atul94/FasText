%%FASText: Efficient Unconstrained Scene Text Detector
 %SEK: Matrix equal to size of image storing SEK points with max contrast
 %value
 %SBK: Matrix equal to size of image storing SEK points with max contrast
 %value
 %check_b_d: Matrix equal to the size of image storing values -1,0,1
 %min_b_intensity: Matrix equal to the size of image storing the minimum intensity
 %value of the bright pixel in the keypoint circle
 %max_b_intensity: Matrix equal to the size of image storing the maximum
 %intensity value of the dark pixels in the keypoint circle
 %m: Threshold Parametere separating dark and bright pixels from paper m=13
clear all;clc;close all;
%% Reading all all the images
% myDir = 'C:/Users/Atul Agarwal/Desktop/btp1/papers/1/MRRCTrainImages/';
% myDir2 = 'C:/Users/Atul Agarwal/Desktop/btp1/papers/1/MRRCTestImages/';
% ext_img = '*.JPG';
% [my_img,my_img2]=read_images(myDir,myDir2,ext_img);

%% The Project begins
%inputimg=my_img(52).img;
%inputimg=imread('C:/Users/Atul Agarwal/Desktop/btp1/papers/1/MRRCTestImages/T044.JPG');
inputimg=imread('C:/Users/Atul Agarwal/Desktop/btp1/New Folder/2_1.JPG');
inputimg=imread('./image.jpg');
%inputimg=imresize(inputimg,1/(1.6*1.6*1.6*1.6));
figure,
imshow(inputimg);
bwimg=rgb2gray(inputimg);
%bwimg=imresize(bwimg,1/1.6);
figure,
imshow(bwimg);
[rows col]=size(bwimg);
%% Finding pixels which are either SEK(Stroke End Keypoint) or SBK(Stroke Bend Key Point)
 %Eleminating all pixels with Pi=s and Pi-1!=s
 %Eleminating all pixels with Pi=s and opp(Pi)==s
check_b_d=zeros(rows,col);%Whether the points surrounding the given point is dark=1 bright=-1 or normal=0
min_b_intensity=zeros(rows,col);
max_d_intensity=zeros(rows,col);
m=13;
[SEK,SBK,count_sp_SBK,check_b_d,max_d_intensity,min_b_intensity]=find_SEK_SBK(bwimg,check_b_d,max_d_intensity,min_b_intensity,rows,col);

%% Testing the SEK and SBK thus found
[row2 col2] = find(SBK>0);
[row1 col1] = find(SEK>0);
figure,imshow(inputimg,[])
hold on;
scatter(col2,row2,'r')
scatter(col1,row1,'b')
hold off;
%% Minimizing key points in a 3*3 neighbourhood
[SBK,SEK,check_b_d]=suppress(SBK,SEK,check_b_d);

%% Testing again
[row2 col2] = find(SBK>0);
[row1 col1] = find(SEK>0);
figure,imshow(inputimg,[])
hold on;
scatter(col2,row2,'r')
scatter(col1,row1,'b')
hold off;
%% Finding the threshold matrix for 1)dark point-max intensity 2)bright pixels-min intensity
[row3 col3] = find(check_b_d~=0);
threshold=zeros(rows,col);
for i = 1 : size(row3)
    if(check_b_d(row3(i),col3(i))==1)
        threshold(row3(i),col3(i))=max_d_intensity(row3(i),col3(i))+1;
    else
        threshold(row3(i),col3(i))=min_b_intensity(row3(i),col3(i))-1;
    end
end
[row5 col5]=find(check_b_d==1);
[row6 col6]=find(check_b_d==-1);
%% Floodfill
showimg=double(inputimg);
showimg2=double(inputimg);
check_ff=zeros(rows,col);
 for i = 1 : size(row5)
         c=0;
        [showimg,check_ff]=floodfill_2(showimg,bwimg,check_ff,check_b_d,threshold,threshold(row5(i),col5(i)),rows,col,row5(i),col5(i),check_b_d(row5(i),col5(i)),c);
 end
for i = 1 : size(row6)
         c=0;
        [showimg2,check_ff]=floodfill_2(showimg2,bwimg,check_ff,check_b_d,threshold,threshold(row6(i),col6(i)),rows,col,row6(i),col6(i),check_b_d(row6(i),col6(i)),c);
end
 figure,
 imshow(showimg/255);
 
 figure,
 imshow(showimg2/255);
%% Classification
%  binimg = rgb2bin(showimg); %check_b_d=1 dark point
%  binimg2 = rgb2bin(showimg2); %check_b_d=-1 bright point

showimg3 = bwimg;
[row7 col7] = find(SEK>0);
visited = zeros(rows,col);
temp_t = zeros(rows,col);
[x_1,y_1] = find(showimg2(:,:,2) == 255);
for i = 1:size(x_1,1)
    temp_t(x_1(i),y_1(i)) = 1;
end
regions = bwlabel(temp_t);
areas = zeros(max(max(regions)),1);
mapping = [-2,0;-2,1;-1,2;0,2;1,2;2,1;2,0;2,-1;1,-2;0,-2;-1,-2;-2,-1];
SSK = zeros(rows,col);
for i = 1:size(row7)
    m = 13;
    x = row7(i);
    y = col7(i);
    r = regions(x,y);
    c = 0;
    SSK(x,y) = 2;
    if(visited(x,y)==0 && r ~= 0)
        visited(x,y) = 1;
        b_temp=bwimg(x,y)+m;
        d_temp=bwimg(x,y)-m;
        temp(1)=bwimg(x-2,y);temp(2)=bwimg(x-2,y+1);temp(3)=bwimg(x-1,y+2);temp(4)=bwimg(x,y+2);
        temp(5)=bwimg(x+1,y+2);temp(6)=bwimg(x+2,y+1);temp(7)=bwimg(x+2,y);temp(8)=bwimg(x+2,y-1);
        temp(9)=bwimg(x+1,y-2);temp(10)=bwimg(x,y-2);temp(11)=bwimg(x-1,y-2);temp(12)=bwimg(x-2,y-1);
        max= 0;
        k_val = 0;
        min = inf;
        for k = 1:12
            if temp(k)<b_temp && temp(k)>d_temp
                if temp(k)>max
                    max = temp(k);
                    k_val = k;
                end
                if temp(k)<min
                    min = temp(k);
                    k_val1 = k;
                end
            end
        end
        if r == regions(x+mapping(k_val,1),y+mapping(k_val,2)) && k_val ~= 0
            [showimg3,visited,SSK,areas] = CSA(showimg3,visited,x+mapping(k_val,1),y+mapping(k_val,2),SSK,mapping,regions,areas,r,c);    
        end
    end
end
