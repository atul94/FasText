function [SBK,SEK,check_b_d]=suppress(SBK,SEK,check_b_d)
temp=check_b_d;
[row col] = size(SBK);
for i = 1 : row-2
    for j = 1 : col-2
        T(1)=SBK(i,j)*check_b_d(i,j);T(2)=SBK(i,j+1)*check_b_d(i,j+1);T(3)=check_b_d(i,j+2)*SBK(i,j+2);
        T(4)=check_b_d(i+1,j)*SBK(i+1,j);T(5)=check_b_d(i+1,j+1)*SBK(i+1,j+1);T(6)=check_b_d(i+1,j+2)*SBK(i+1,j+2);
        T(7)=check_b_d(i+2,j)*SBK(i+2,j);T(8)=check_b_d(i+2,j+1)*SBK(i+2,j+1);T(9)=check_b_d(i+2,j+2)*SBK(i+2,j+2);
        [Max I]=max(T);
        [Min J]=min(T);
        for k = 1 : 3
            for l = 1 : 3
                x=i+k-1;y=i+l-1;
                if(check_b_d(x,y)==1&&SBK(x,y)>0)
                    if(SBK(x,y)~=Max)
                        SBK(x,y)=0;
                        check_b_d(x,y)=0;
                    end
                elseif(check_b_d(x,y)==-1&&SBK(x,y)>0)
                    z=SBK(x,y)+Min;
                    if(z~=0)
                        SBK(x,y)=0;
                        check_b_d(x,y)=0;
                    end
                end
            end
        end
    end
end
for i = 1 : row-2
    for j = 1 : col-2
        T(1)=SEK(i,j)*check_b_d(i,j);T(2)=SEK(i,j+1)*check_b_d(i,j+1);T(3)=check_b_d(i,j+2)*SEK(i,j+2);
        T(4)=check_b_d(i+1,j)*SEK(i+1,j);T(5)=check_b_d(i+1,j+1)*SEK(i+1,j+1);T(6)=check_b_d(i+1,j+2)*SEK(i+1,j+2);
        T(7)=check_b_d(i+2,j)*SEK(i+2,j);T(8)=check_b_d(i+2,j+1)*SEK(i+2,j+1);T(9)=check_b_d(i+2,j+2)*SEK(i+2,j+2);
        [Max I]=max(T);
        [Min J]=min(T);
        for k = 1 : 3
            for l = 1 : 3
                x=i+k-1;y=i+l-1;
                if(check_b_d(x,y)==1&&SEK(x,y)>0)
                    if(SEK(x,y)~=Max)
                        SEK(x,y)=0;
                        check_b_d(x,y)=0;
                    end
                elseif(check_b_d(x,y)==-1&&SEK(x,y)>0)
                    z=SEK(x,y)+Min;
                    if(z~=0)
                        SEK(x,y)=0;
                        check_b_d(x,y)=0;
                    end
                end
            end
        end
    end
end