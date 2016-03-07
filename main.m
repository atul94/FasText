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
inputimg=imread('./3.png');
%inputimg=imresize(inputimg,1/(1.6));
bwimg=rgb2gray(inputimg);
%bwimg=imresize(bwimg,1/1.6);
%imshow(bwimg);
[rows col]=size(bwimg);
SEK=zeros(rows,col);
SBK=zeros(rows,col);
check_b_d=zeros(rows,col);%Whether the points surrounding the given point is dark=1 bright=-1 or normal=0
min_b_intensity=zeros(rows,col);
max_d_intensity=zeros(rows,col);
m=13;
%% Finding pixels which are either SEK(Stroke End Keypoint) or SBK(Stroke Bend Key Point)
 %Eleminating all pixels with Pi=s and Pi-1!=s
 %Eleminating all pixels with Pi=s and opp(Pi)==s
 
 for i = 3 : rows - 2
      for j = 3 : col - 2
          b=bwimg(i,j)+m;
          d=bwimg(i,j)-m;
          P(1)=bwimg(i-2,j);P(2)=bwimg(i-2,j+1);P(3)=bwimg(i-1,j+1);P(4)=bwimg(i,j+2);
          P(5)=bwimg(i+1,j+2);P(6)=bwimg(i+1,j+1);P(7)=bwimg(i+2,j);P(8)=bwimg(i+2,j-1);
          P(9)=bwimg(i+1,j-2);P(10)=bwimg(i,j-2);P(11)=bwimg(i-1,j-2);P(12)=bwimg(i-2,j-1);
          pi(1)=bwimg(i-1,j);pi(2)=bwimg(i-1,j+1);pi(3)=bwimg(i,j+1);pi(4)=bwimg(i+1,j+1);
          pi(5)=bwimg(i+1,j);pi(6)=bwimg(i+1,j-1);pi(7)=bwimg(i,j-1);pi(8)=bwimg(i-1,j-1);
          flag=0;max_value_b=0;max_value_d=0;count_bp=0;count_dp=0;count_sp=0;minb=255;maxd=0;
          for k = 1 : 12
              if(P(k)<b&&P(k)>d)
                    if(k<=6)    
                      if(P(k+6)<b&&P(k+6)>d)
                        flag=1;
                        break;
                      end
                    end
                    if(k==1)
                        if(pi(1)>=b||pi(1)<=d)
                            flag=1;
                            break;
                        end
                    elseif(k==2||k==3)
                        if(pi(2)>=b||pi(2)<=d)
                            flag=1;
                            break;
                        end
                    elseif(k==4)
                        if(pi(3)>=b||pi(3)<=d)
                            flag=1;
                            break;
                        end
                    elseif(k==5||k==6)
                        if(pi(4)>=b||pi(4)<=d)
                            flag=1;
                            break;
                        end
                    elseif(k==7)
                        if(pi(5)>=b||pi(5)<=d)
                            flag=1;
                            break;
                        end
                    elseif(k==8||k==9)
                        if(pi(6)>=b||pi(6)<=d)
                            flag=1;
                            break;
                        end
                    elseif(k==10)
                        if(pi(7)>=b||pi(7)<=d)
                            flag=1;
                            break;
                        end
                    else
                        if(pi(8)>=b||pi(8)<=d)
                            flag=1;
                            break;
                        end
                    end
                    count_sp=count_sp+1;
                    if(count_sp==1)
                        sp_index(count_sp)=i;
                    else
                        sp_index(count_sp)=i-sp_index(count_sp-1);
                    end
              elseif(P(k)>=b)
                  count_bp=count_bp+1;
                  if(count_bp==1)
                        bp_index(count_bp)=i;
                  else
                        bp_index(count_bp)=i-bp_index(count_bp-1);
                  end
                  x=P(k)-bwimg(i,j);
                  if(x>max_value_b)
                      max_value_b=x;
                  end
                  x=P(k);
                  if(x<minb)
                      minb=x;
                  end
              else
                  count_dp=count_dp+1;
                  if(count_dp==1)
                        dp_index(count_dp)=i;
                    else
                        dp_index(count_dp)=i-dp_index(count_dp-1);
                  end
                  x=bwimg(i,j)-P(k);
                  if(x>max_value_d)
                      max_value_d=x;
                  end
                  x=P(k);
                  if(x>maxd)
                      maxd=x;
                  end
              end
          end
          if(count_dp<6&&count_bp<6)
              flag=1;
          end
          if(count_sp<1||count_sp==6)
              flag=1;
          end
          if(flag==0)
            if(count_sp==3)
                if(count_bp==9||count_dp==9)
                    if(sp_index(3)==1&&(sp_index(2)==1||sp_index(2)==10))%Condition for a similar 3 element contigous segment
                        flag=1;
                        if(count_bp==9)
                            SEK(i,j)=max_value_b;
                            check_b_d(i,j)=-1;
                            min_b_intensity(i,j)=minb;
                        else
                            SEK(i,j)=max_value_d;
                            check_b_d(i,j)=1;
                            max_d_intensity(i,j)=maxd;
                        end
                    elseif(sp_index(2)~=1&&sp_index(3)~=1)%Deleting Conditions for SBK
                        if(sp_index(1)~=1)
                            flag=1;
                        else
                            if(sp_index(1)+sp_index(2)+sp_index(3)~=12)
                                flag=1;
                            end
                        end
                    end
                else
                     flag=1;                                   
                end
            elseif(count_sp==1)
                flag=1;
                if(count_bp==11)
                    SEK(i,j)=max_value_b;
                    check_b_d(i,j)=-1;
                    min_b_intensity(i,j)=minb;
                elseif(count_dp==11)
                    SEK(i,j)=max_value_d;
                    check_b_d(i,j)=1;
                    max_d_intensity(i,j)=maxd;
                end
            elseif(count_sp==2)
              if(sp_index(2)==1||(sp_index(1)==1&&sp_index(2)==11))
                  flag=1;
                if(count_bp>count_dp)
                    SEK(i,j)=max_value_b;
                    check_b_d(i,j)=-1;
                    min_b_intensity(i,j)=minb;
                else
                    SEK(i,j)=max_value_d;
                    check_b_d(i,j)=1;
                    max_d_intensity(i,j)=maxd;
                end
              else
                  if(count_dp>0&&count_bp>0)
                      flag=1;
                  end
              end   
            elseif(count_sp==4||count_sp==5)
              count_not_one=0;
              for o = 2 : count_sp
                if(sp_index(o)~=1)
                  count_not_one=count_not_one+1;
                end
              end
              if(count_not_one>=3)%Deleting conditions for SBK
                flag=1;
              elseif(count_not_one==2&&sp_index(1)==1)
                if(count_sp==3&&sp_index(1)+sp_index(2)+sp_index(3)~=12)%Deleting conditions for SBK
                  flag=1;
                elseif(count_sp==4&&sp_index(1)+sp_index(2)+sp_index(3)+sp_index(4)~=12)%Deleting conditions for SBK
                  flag=1;
                else
                    if(count_dp>0&&count_bp>0)
                        flag=1;
                    end
                end
              elseif(count_not_one==2&&sp_index(1)~=1)
                  flag=1;
              else
                if(count_dp>0&&count_bp>0)
                    flag=1;
                end
              end
            end
          end
          if(flag==0)
              if(count_dp>0)
                  SBK(i,j)=max_value_d;
                  check_b_d(i,j)=1;
                  max_d_intensity(i,j)=maxd;
              else
                  SBK(i,j)=max_value_b;
                  check_b_d(i,j)=-1;
                  min_b_intensity(i,j)=minb;
              end
          end
      end
 end
%% Testing the SEK and SBK thus found
[row2 col2] = find(SBK>0);
[row1 col1] = find(SEK>0);
figure,imshow(inputimg,[])
hold on;
scatter(col2,row2,'r')
scatter(col1,row1,'b')
hold off;
%% Minimizing key points in a 3*3 neighbourhood
[row col] = size(SBK);
for i = 1 : row-2
    for j = 1 : col-2
        T(1)=SBK(i,j);T(2)=SBK(i,j+1);T(3)=SBK(i,j+2);
        T(4)=SBK(i+1,j);T(5)=SBK(i+1,j+1);T(6)=SBK(i+1,j+2);
        T(7)=SBK(i+2,j);T(8)=SBK(i+2,j+1);T(9)=SBK(i+2,j+2);
        [M I]=max(T);
        if(M>0)
            x=I/3;y=mod(I,3);
            if(x<=1)
                a=0;
            elseif(x<=2&&x>1)
                a=1;
            else
                a=2;
            end
            if(y==1)
                b=0;
            elseif(y==2)
                b=1;
            else
                b=2;
            end
            tt=SBK(i+a,j+b);
            tt2=check_b_d(i+a,j+b);
            for k = 1 : 3
                for l = 1 : 3
                    SBK(i+k-1,j+l-1)=0;
                    check_b_d(i+k-1,j+l-1)=0;
                end
            end
            SBK(i+a,j+b)=tt;
            check_b_d(i+a,j+b)=tt2;
        end
    end
end
for i = 1 : row-2
    for j = 1 : col-2
        T(1)=SEK(i,j);T(2)=SEK(i,j+1);T(3)=SEK(i,j+2);
        T(4)=SEK(i+1,j);T(5)=SEK(i+1,j+1);T(6)=SEK(i+1,j+2);
        T(7)=SEK(i+2,j);T(8)=SEK(i+2,j+1);T(9)=SEK(i+2,j+2);
        [M I]=max(T);
        if(M>0)
            x=I/3;y=mod(I,3);
            if(x<=1)
                a=0;
            elseif(x<=2&&x>1)
                a=1;
            else
                a=2;
            end
            if(y==1)
                b=0;
            elseif(y==2)
                b=1;
            else
                b=2;
            end
            tt=SEK(i+a,j+b);
            tt2=check_b_d(i+a,j+b);
            for k = 1 : 3
                for l = 1 : 3
                    SEK(i+k-1,j+l-1)=0;
                    check_b_d(i+k-1,j+l-1)=0;
                end
            end
            SEK(i+a,j+b)=tt;
            check_b_d(i+a,j+b)=tt2;
        end
    end
end 
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
% global global_count;
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