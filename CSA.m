function [showimg3,visited,SSK,areas] = CSA(showimg3,visited,x,y,SSK,mapping,regions,areas,r,c)
if c >=480
    return;
end
m = 13;
[r1,c1] =size(showimg3);
if x<=2||y<=2||x>=r1-1||y>=c1-1
    return;
end
if(visited(x,y) == 0)
    visited(x,y) = 1;
    b=showimg3(x,y)+m;
    d=showimg3(x,y)-m;
    temp(1)=showimg3(x-2,y);temp(2)=showimg3(x-2,y+1);temp(3)=showimg3(x-1,y+2);temp(4)=showimg3(x,y+2);
    temp(5)=showimg3(x+1,y+2);temp(6)=showimg3(x+2,y+1);temp(7)=showimg3(x+2,y);temp(8)=showimg3(x+2,y-1);
    temp(9)=showimg3(x+1,y-2);temp(10)=showimg3(x,y-2);temp(11)=showimg3(x-1,y-2);temp(12)=showimg3(x-2,y-1);
    max= 0;
    flag = 0;
    min = inf;
    val = zeros(12,1);
    k_val = 0;
    for k = 1:12
        if temp(k)<b && temp(k)>d
            val(k) = 1;
            if temp(k) > max && visited(x+mapping(k,1),y+mapping(k,2))==0
                max = temp(k);
                k_val = k;
            end
            if temp(k) < min && visited(x+mapping(k,1),y+mapping(k,2)) == 0
                min = temp(k);
                k_val1 = k;
            end
        elseif temp(k)>=b
            val(k) = 2;
        else
            val(k) = 3;
        end
    end
    count_sp1 = 0;
    count_sp2 = 0;
    count_dp1 = 0;
    count_dp2 = 0;
    count_bp1 = 0;
    count_bp2 = 0;
    flag = 0;
    temp = 0;
    for i = 1:12
        if flag == 2 && val(i) == 1
            temp = temp + 1;
            if i == 12 && val(1) == 1
                count_sp1 = count_sp1 + temp;
                break;
            end
        elseif val(i) == 1 && flag == 0
            count_sp1 = count_sp1 + 1;
        elseif val(i) ~= 1 && count_sp1 ~=0 && count_sp2 == 0
            flag = 1;
        elseif val(i) ~= 1 && count_sp2 ~= 0
            flag = 2;
        elseif val(i) == 1 && flag == 1
            count_sp2 = count_sp2 + 1;
            if i == 12 && val(1) == 1
                count_sp1 = count_sp1 + count_sp2;
                count_sp2 = 0;
            end
        end
    end
    flag = 0;
    temp = 0;
    for i = 1:12
        if flag == 2 && val(i) == 2
            temp = temp + 1;
            if i == 12 && val(1) == 2
                count_bp1 = count_bp1 + temp;
                break;
            end
        elseif val(i) == 2 && flag == 0
            count_bp1 = count_bp1 + 1;
        elseif val(i) ~= 2 && count_bp1 ~=0 && count_bp2 == 0
            flag = 1;
        elseif val(i) ~= 2 && count_bp2 ~= 0
            flag = 2;
        elseif val(i) == 2 && flag == 1
            count_bp2 = count_bp2 + 1;
            if i == 12 && val(1) == 2
                count_bp1 = count_bp1 + count_bp2;
                count_bp2 = 0;
            end
        end
    end
    flag = 0;
    temp = 0;
    for i = 1:12
        if flag == 2 && val(i) == 3
            temp = temp + 1;
            if i == 12 && val(1) == 3
                count_dp1 = count_dp1 + temp;
                break;
            end
        elseif val(i) == 3 && flag == 0
            count_dp1 = count_dp1 + 1;
        elseif val(i) ~= 3 && count_dp1 ~=0 && count_dp2 == 0
            flag = 1;
        elseif val(i) ~= 3 && count_dp2 ~= 0
            flag = 2;
        elseif val(i) == 3 && flag == 1
            count_dp2 = count_dp2 + 1;
            if i == 12 && val(1) == 3
                count_dp1 = count_dp1 + count_dp2;
                count_dp2 = 0;
            end
        end
    end
    flag = 0;
    if count_sp1 < count_sp2
        temp1 = count_sp1;
        count_sp1 = count_sp2;
        count_sp2 = temp1;
    end
    if count_bp1 < count_bp2
        temp1 = count_bp1;
        count_bp1 = count_bp2;
        count_bp2 = temp1;
    end
    if count_dp1 < count_dp2
        temp1 = count_dp1;
        count_dp1 = count_dp2;
        count_dp2 = temp1;
    end
    if count_sp1 <1 || count_sp1 >3 
        flag = 1;
    end
    if count_sp2 < 1 || count_sp2 > 3
        flag = 1;
    end
    if count_dp1+ count_dp2 > count_bp1 + count_bp2
        if count_dp1<=3
            flag = 1;
        end
    else 
        if count_bp1 <= 3
            flag = 1;
        end
    end
    if flag == 0 && k_val ~= 0
        SSK(x,y) = 1;
        max = 0;
        if x>2&&y>2&&x<r1-1&&y<c1-1
            c = c+1;
            if r ~= regions(x+mapping(k_val,1),y+mapping(k_val,2))
                return
            end
            areas(r) = areas(r) + 3*count_sp1;
            [showimg3,visited,SSK,areas] = CSA(showimg3,visited,x+mapping(k_val,1),y+mapping(k_val,2),SSK,mapping,regions,areas,r,c);
        end
    end
end