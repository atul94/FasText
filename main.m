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
clear all;clc;
%% Reading all all the images
myDir = 'C:/Users/Atul Agarwal/Desktop/btp1/papers/1/MRRCTrainImages/';
myDir2 = 'C:/Users/Atul Agarwal/Desktop/btp1/papers/1/MRRCTestImages/';
ext_img = '*.JPG';
[my_img,my_img2]=read_images(myDir,myDir2,ext_img);

%% The Project begins
inputimg=my_img2(1).img;
inputimg=imresize(inputimg,1/(1.6*1.6));
bwimg=rgb2gray(inputimg);
%bwimg=imresize(bwimg,1/1.6);
figure,
imshow(bwimg);
[rows col]=size(bwimg);
%% Finding pixels which are either SEK(Stroke End Keypoint) or SBK(Stroke Bend Key Point)
 %Eleminating all pixels with Pi=s and Pi-1!=s
 %Eleminating all pixels with Pi=s and opp(Pi)==s
SEK=zeros(rows,col);
SBK=zeros(rows,col);
check_b_d=zeros(rows,col);%Whether the points surrounding the given point is dark=1 bright=-1 or normal=0
min_b_intensity=zeros(rows,col);
max_d_intensity=zeros(rows,col);
m=13;
[SEK,SBK,check_b_d,max_d_intensity,min_b_intensity]=find_SEK_SBK(bwimg,SEK,SBK,check_b_d,max_d_intensity,min_b_intensity);
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
 