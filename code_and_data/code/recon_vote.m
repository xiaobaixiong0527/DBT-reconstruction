function [ini] = recon_vote(data,keyt,hei,inii3)
    la_x = 0.0001;
    k = 5;
    b_0 = 2*la_x;
    b_max = 100000;
    
    b = b_0;
    
    %%%%%%%%%%%%%%%%%%%
    
    x_sum = 1920/4;
    y_sum = 2304/4;
    % z_sum = 2000;
    z_top = 1000;
    z_botton = 0;
    sclice = 100; 
    
    la = 0.1;
    R = 1;
    
    j_sum = x_sum*y_sum*sclice;%鎬诲儚绱?
    ray_sum = x_sum*y_sum;%鎬诲皠绾挎暟
    
    prj_angle = [30 27 24 21 18 15 12 9 6 3 0 -3 -6 -9 -12 -15 -18 -21 -24 -27 -30];
    ini = zeros(x_sum,y_sum+10,sclice);
    ini1 = zeros(x_sum,y_sum+10,sclice);
    ini2 = zeros(x_sum,y_sum+10,sclice);
    ini3 = inii3;
    list = zeros(100*8,4);
    for tt=1:keyt
        for a=1:21
            angle = prj_angle(22-a);
            %鍏夋簮浣嶇疆
            source_x = 0;
            source_y = 6400*sind(angle);
            source_z = 6400*cosd(angle);
            %x0涓鸿惤鍦ㄦ娴嬪櫒涓婇潰鐨勭偣
            %x1涓鸿惤鍦ㄧ墿浣撲笂闈㈢殑鐐?(鍙兘锛?
            %x2涓鸿惤鍦ㄧ墿浣撳簳闈㈢殑鐐?(鍙兘锛?
            %x3涓鸿惤鍦ㄧ墿浣揧姝ｅ悜闈㈢殑鐐?(鍙兘锛?
            %x4涓鸿惤鍦ㄧ墿浣揧璐熷悜闈㈢殑鐐?(鍙兘锛?
            for ray=1:ray_sum                         
                x = mod(ray-1,x_sum)+1;              
                y = floor((ray-1)/x_sum)+1;
                x0 = x*4-2;
                y0 = (-y+y_sum/2)*4-2;
                z0 = -200;
    %             if (data(a,x,y) == 0)
    %                 continue
    %             end
                %绌洪棿鐩寸嚎鍏紡
                %0涓烘娴嬮潰 2涓烘簮
                %[锛坸-a0锛?/(a2-a0)]=[锛坹-b0锛?/锛坆2-b0锛塢=[锛坺-c0锛?/锛坈2-c0锛塢 
                z1 = z_top; 
                x1 = x0+(z1-z0)/(source_z-z0)*(source_x-x0); 
                y1 = y0+(z1-z0)/(source_z-z0)*(source_y-y0);
                z2 = z_botton; 
                x2 = x0+(z2-z0)/(source_z-z0)*(source_x-x0); 
                y2 = y0+(z2-z0)/(source_z-z0)*(source_y-y0);
                y3 = 2304/2;
                x3 = x0+(y3-y0)/(source_y-y0)*(source_x-x0); 
                z3 = z0+(y3-y0)/(source_y-y0)*(source_z-z0); 
                y4 = -2304/2; 
                x4 = x0+(y4-y0)/(source_y-y0)*(source_x-x0); 
                z4 = z0+(y4-y0)/(source_y-y0)*(source_z-z0); 
                %鍒ゆ柇绔偣锛岀鐐逛负px1,px2
                if (y1>=-2304/2 && y1<=2304/2) 
                    px1 = x1; py1 = y1; pz1 = z1;
                elseif (z3>=z_botton && z3<=z_top)
                    px1 = x3; py1 = y3; pz1 = z3;
                elseif (z4>=z_botton && z4<=z_top)
                    px1 = x4; py1 = y4; pz1 = z4;
                else
                    continue
                end
                if (y2>=-2304/2 && y2<=2304/2)
                    px2 = x2; py2 = y2; pz2 = z2;
                else
                    continue
                end
                p1_p2 = sqrt((px1-px2)*(px1-px2)+(py1-py2)*(py1-py2)+(pz1-pz2)*(pz1-pz2));
                
                if(pz1 > hei)
                    pz1 = hei;
                end
                
                %绌洪棿鐩寸嚎鍏紡
                %[锛坸-a0锛?/(a2-a0)]=[锛坹-b0锛?/锛坆2-b0锛塢=[锛坺-c0锛?/锛坈2-c0锛塢 
                for z=(pz2+5):10:(pz1-13)
                    %鍍忕礌涓棿鐐逛綅缃?
                    ppz = z;
                    ppx = x0+(ppz-z0)/(source_z-z0)*(source_x-x0);
                    ppy = y0+(ppz-z0)/(source_z-z0)*(source_y-y0);
                    %璁＄畻璺濈
                    q = (ppx-floor(ppx))*4;
                    p = (ceil(ppy)-(ppy))*4;
                    r = 5;
                    dis1 = (4-p)*(4-q)*(10-r);
                    dis2 = p*(4-q)*(10-r);
                    dis3 = p*q*(10-r);
                    dis4 = (4-p)*q*(10-r);
                    dis5 = (4-p)*(4-q)*r;
                    dis6 = p*(4-q)*r;
                    dis7 = p*q*r;
                    dis8 = (4-p)*q*r;
                    %鍒涘缓鍚戦噺琛?1-3瀵瑰簲xyz,4瀵瑰簲鏉冮噸
                    if(ceil(ppx/4)+1 <= 480 && ceil((-ppy+2304/2)/4)+1 <= 586)
                        list(R,1) = floor(ppx/4)+1;list(R,2) = ceil((-ppy+2304/2)/4)+1;list(R,3) = floor(( ppz)/10)+1;list(R,4) = dis1;R=R+1;
                        list(R,1) = ceil(ppx/4)+1;list(R,2) = ceil((-ppy+2304/2)/4)+1;list(R,3) = floor(( ppz)/10)+1;list(R,4) = dis2;R=R+1;
                        list(R,1) = ceil(ppx/4)+1;list(R,2) = floor((-ppy+2304/2)/4)+1;list(R,3) = floor(( ppz)/10)+1;list(R,4) = dis3;R=R+1;
                        list(R,1) = floor(ppx/4)+1;list(R,2) = floor((-ppy+2304/2)/4)+1;list(R,3) = floor(( ppz)/10)+1;list(R,4) = dis4;R=R+1;
                        list(R,1) = floor(ppx/4)+1;list(R,2) = ceil((-ppy+2304/2)/4)+1;list(R,3) = ceil(( ppz)/10)+1;list(R,4) = dis5;R=R+1;
                        list(R,1) = ceil(ppx/4)+1;list(R,2) = ceil((-ppy+2304/2)/4)+1;list(R,3) = ceil(( ppz)/10)+1;list(R,4) = dis6;R=R+1;
                        list(R,1) = ceil(ppx/4)+1;list(R,2) = floor((-ppy+2304/2)/4)+1;list(R,3) = ceil(( ppz)/10)+1;list(R,4) = dis7;R=R+1;
                        list(R,1) = floor(ppx/4)+1;list(R,2) = floor((-ppy+2304/2)/4)+1;list(R,3) = ceil(( ppz)/10)+1;list(R,4) = dis8;R=R+1;        
                
                    end
                end
                q = 0;
                a1 = 0;
                p = data(a,x,y);
                for r2=1:R-1
                    if(ini3(list(r2,1),list(r2,2),list(r2,3)) == 21)
                        q = q+ini(list(r2,1),list(r2,2),list(r2,3))*list(r2,4);
                        a1 = a1+list(r2,4);
                    end
                end
                %Apply a correction
                for r2=1:R-1
                    if(ini3(list(r2,1),list(r2,2),list(r2,3)) == 21)
                        ini1(list(r2,1),list(r2,2),list(r2,3)) = ini1(list(r2,1),list(r2,2),list(r2,3))+list(r2,4)*(p-q)/a1;
                        ini2(list(r2,1),list(r2,2),list(r2,3)) = ini2(list(r2,1),list(r2,2),list(r2,3))+list(r2,4);
                    end
                end
                list(:,:,:) = 0;
                R = 1;
            end
            for s=1:100
                for i=1:x_sum
                    for j=1:y_sum+10
                        if(ini2(i,j,s) == 0)
                            ini2(i,j,s) = 1;
                        end
                    end
                end
            end
            ini = ini+la*(ini1./ini2);
            ini1 = zeros(x_sum,y_sum+10,sclice);
            ini2 = zeros(x_sum,y_sum+10,sclice);
            for s=1:100
                for i=1:x_sum
                    for j=1:y_sum+10
                        if(ini(i,j,s) < 0)
                            ini(i,j,s) = 0;
                        end
                    end
                end
            end
            ini = medfilt3(ini,[3 3 3]);
%             if(a == 4)
%                 aaaaa= 1;
%             end
        end
    end
end