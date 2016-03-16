function [SBK,SEK,check_b_d]=suppress(SBK,SEK,check_b_d)

[row col] = size(SBK);
for i = 1 : row-2
    for j = 1 : col-2
        T(1)=SBK(i,j)*check_b_d(i,j);T(2)=SBK(i,j+1)*check_b_d(i,j+1);T(3)=check_b_d(i,j+2)*SBK(i,j+2);
        T(4)=check_b_d(i+1,j)*SBK(i+1,j);T(5)=check_b_d(i+1,j+1)*SBK(i+1,j+1);T(6)=check_b_d(i+1,j+2)*SBK(i+1,j+2);
        T(7)=check_b_d(i+2,j)*SBK(i+2,j);T(8)=check_b_d(i+2,j+1)*SBK(i+2,j+1);T(9)=check_b_d(i+2,j+2)*SBK(i+2,j+2);
        [Max I]=max(T);
        [Min J]=min(T);
        a=0;b=0;a1=0;b1=0;
        if(Max>0)
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
        end
        if(Min<0)
            x=J/3;y=mod(J,3);
            if(x<=1)
                a1=0;
            elseif(x<=2&&x>1)
                a1=1;
            else
                a1=2;
            end
            if(y==1)
                b1=0;
            elseif(y==2)
                b1=1;
            else
                b1=2;
            end
        end
        if(Max>0||Min<0)
            tt=SBK(i+a,j+b);
            tt2=check_b_d(i+a,j+b);
            ttt=SBK(i+a1,j+b1);
            ttt2=check_b_d(i+a1,j+b1);
            for k = 1 : 3
                for l = 1 : 3
                    SBK(i+k-1,j+l-1)=0;
                    check_b_d(i+k-1,j+l-1)=0;
                end
            end
            if(Max>0)
                SBK(i+a,j+b)=tt;
                check_b_d(i+a,j+b)=tt2;
            end
            if(Min<0)
                SBK(i+a1,j+b1)=ttt;
                check_b_d(i+a1,j+b1)=ttt2;
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
        if(Max>0)
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
        end
        if(Min<0)
            x=J/3;y=mod(J,3);
            if(x<=1)
                a1=0;
            elseif(x<=2&&x>1)
                a1=1;
            else
                a1=2;
            end
            if(y==1)
                b1=0;
            elseif(y==2)
                b1=1;
            else
                b1=2;
            end
        end
        if(Max>0||Min<0)
            tt=SEK(i+a,j+b);
            tt2=check_b_d(i+a,j+b);
            ttt=SEK(i+a1,j+b1);
            ttt2=check_b_d(i+a1,j+b1);
            for k = 1 : 3
                for l = 1 : 3
                    SEK(i+k-1,j+l-1)=0;
                    check_b_d(i+k-1,j+l-1)=0;
                end
            end
            if(Max>0)
                SEK(i+a,j+b)=tt;
                check_b_d(i+a,j+b)=tt2;
            end
            if(Min<0)
                SEK(i+a1,j+b1)=ttt;
                check_b_d(i+a1,j+b1)=ttt2;
            end
        end
    end
end