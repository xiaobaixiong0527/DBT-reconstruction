function [dd2,dd,ini] = st1(I,key1)
    ini = I;
    for i=1:100
        for j=1:480
            for k=1:586
                if(ini(j,k,i) < key1)
                    ini(j,k,i) = 0;
                end
            end
        end
    end
    x_sum = 1920/4;
    y_sum = 2304/4;
    z_sum = 2000;
    z_top = 1000;
    z_botton = 0;
    sclice = 100;
    prj_angle = [30 27 24 21 18 15 12 9 6 3 0 -3 -6 -9 -12 -15 -18 -21 -24 -27 -30];
    la = 0.1;
    R = 1;
    dd = zeros(21,480,576);
    dd2 = zeros(21,480,576);
    dd1 = zeros(21,480,576);
    j_sum = x_sum*y_sum*sclice;%总像素
    ray_sum = x_sum*y_sum;%总射线数
    
    for a=1:21
        angle = prj_angle(a);
        source_x = 0;
        source_y = 6400*sind(angle);
        source_z = 6400*cosd(angle);
        for ray=1:ray_sum   
            x = mod(ray-1,480)+1;              
            y = floor((ray-1)/480)+1;
            x0 = x*4+2;
            y0 = (y*4+2-2304/2);
            z0 = -200;
            for z=1:100
                ppz = z*10;
                ppx = round((x0+(ppz-z0)/(source_z-z0)*(source_x-x0))/4);
                ppy = round((y0+(ppz-z0)/(source_z-z0)*(source_y-y0)+2304/2)/4);
                if(ppx <= 480 && ppy <= 576 && ppy >= 1 && ppx >= 1 && ini(ppx,ppy,z)~=0)
                    dd(a,x,y) = 1;
                end
            end
        end
    end
    se1 = strel('disk',5);%盘型结构元素
    se2 = strel('octagon',3);%盘型结构元素
    for a=1:21
%         dd1(a,:,:) = imerode(reshape(dd(a,:,:),[480 576]),se2);
        dd2(a,:,:) = imdilate(reshape(dd(a,:,:),[480 576]),se1);
    end
    aaa = 1;
end