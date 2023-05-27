function [inii] = recon_cal_3(data7,I,key22,key33)
    la_x = 0.0001;
    k = 5;
    b_0 = 2*la_x;
    b_max = 100000;
    
    b = b_0;
    data = data7;
    keyt = 200;
    hei = 450;
    %%%%%%%%%%%%%%%%%%%
    key2 = key22;
    key3 = key33;
    x_sum = 1920/4;
    y_sum = 2304/4;
    % z_sum = 2000;a
    z_top = 1000;
    z_botton = 0;
    sclice = 100; 
    
    la = 0.1;
    R = 1;
    
    j_sum = x_sum*y_sum*sclice;%閹鍎氱槐?
    ray_sum = x_sum*y_sum;%閹鐨犵痪鎸庢殶
    
    prj_angle = [30 27 24 21 18 15 12 9 6 3 0 -3 -6 -9 -12 -15 -18 -21 -24 -27 -30];
    % inii = zeros(x_sum,y_sum+10,sclice);
    % ini = zeros(x_sum,y_sum+10,sclice);
    inii = I;
    ini1 = zeros(x_sum,y_sum+10,sclice);
    ini2 = zeros(x_sum,y_sum+10,sclice);
    % ini3 = zeros(21,x_sum,y_sum+10,sclice);
    list = zeros(100*8,6);
    list1 = zeros(1,21);
    for tt=1:keyt
        for a=1:21
            angle = prj_angle(22-a);
            %閸忓绨担宥囩枂
            source_x = 0;
            source_y = 6400*sind(angle);
            source_z = 6400*cosd(angle);
            %x0娑撻缚鎯ら崷銊︻梾濞村娅掓稉濠囨桨閻ㄥ嫮鍋?
            %x1娑撻缚鎯ら崷銊у⒖娴ｆ挷绗傞棃銏㈡畱閻??(閸欘垵鍏橀敍?
            %x2娑撻缚鎯ら崷銊у⒖娴ｆ挸绨抽棃銏㈡畱閻??(閸欘垵鍏橀敍?
            %x3娑撻缚鎯ら崷銊у⒖娴ｆ彠濮濓絽鎮滈棃銏㈡畱閻??(閸欘垵鍏橀敍?
            %x4娑撻缚鎯ら崷銊у⒖娴ｆ彠鐠愮喎鎮滈棃銏㈡畱閻??(閸欘垵鍏橀敍?
            for ray=1:ray_sum                         
                x = mod(ray-1,x_sum)+1;              
                y = floor((ray-1)/x_sum)+1;
                x0 = x*4-2;
                y0 = (-y+y_sum/2)*4-2;
                z0 = -200;
    %             if (data(a,x,y) == 0)
    %                 continue
    %             end
                %缁屾椽妫块惄瀵稿殠閸忣剙绱?
                %0娑撶儤顥呭ù瀣桨 2娑撶儤绨?
                %[閿涘澑-a0閿??/(a2-a0)]=[閿涘澒-b0閿??/閿涘潌2-b0閿涘、=[閿涘澓-c0閿??/閿涘潏2-c0閿涘、 
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
                %閸掋倖鏌囩粩顖滃仯閿涘瞼顏悙閫涜礋px1,px2
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
                
                %缁屾椽妫块惄瀵稿殠閸忣剙绱?
                %[閿涘澑-a0閿??/(a2-a0)]=[閿涘澒-b0閿??/閿涘潌2-b0閿涘、=[閿涘澓-c0閿??/閿涘潏2-c0閿涘、 
                for z=(pz2+5):10:(pz1-13)
                    %閸嶅繒绀屾稉顓㈡？閻愰?涚秴缂??
                    ppz = z;
                    ppx = x0+(ppz-z0)/(source_z-z0)*(source_x-x0);
                    ppy = y0+(ppz-z0)/(source_z-z0)*(source_y-y0);
                    %鐠侊紕鐣荤捄婵堫瀲
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
                    %閸掓稑缂撻崥鎴﹀櫤鐞??1-3鐎电懓绨瞲yz,4鐎电懓绨查弶鍐櫢
                    if((ceil((-ppy+1152)/4)+1)+1 <= 2314/4 && (floor((-ppy+1152)/4)+1)-1 >= 1 && (floor(ppx/4)+1)-1 >= 1 && (ceil(ppx/4)+1)+1 <= 1920/4 && floor(( ppz)/10) >= 1 && ceil(( ppz)/10)+2 <= 100) 
                        list(R,1) = floor(ppx/4)+1;list(R,2) = ceil((-ppy+1152)/4)+1;list(R,3) = floor(( ppz)/10)+1;list(R,4) = dis1;
                        list(R,5) = inii(list(R,1)+1,list(R,2),list(R,3))+inii(list(R,1)-1,list(R,2),list(R,3))+inii(list(R,1),list(R,2)+1,list(R,3))+...
                            inii(list(R,1),list(R,2)-1,list(R,3))+inii(list(R,1),list(R,2),list(R,3)+1)+inii(list(R,1),list(R,2),list(R,3)-1);R=R+1;
                        list(R,1) = ceil(ppx/4)+1;list(R,2) = ceil((-ppy+1152)/4)+1;list(R,3) = floor(( ppz)/10)+1;list(R,4) = dis2;
                        list(R,5) = inii(list(R,1)+1,list(R,2),list(R,3))+inii(list(R,1)-1,list(R,2),list(R,3))+inii(list(R,1),list(R,2)+1,list(R,3))+...
                            inii(list(R,1),list(R,2)-1,list(R,3))+inii(list(R,1),list(R,2),list(R,3)+1)+inii(list(R,1),list(R,2),list(R,3)-1);R=R+1;
                        list(R,1) = ceil(ppx/4)+1;list(R,2) = floor((-ppy+1152)/4)+1;list(R,3) = floor(( ppz)/10)+1;list(R,4) = dis3;
                        list(R,5) = inii(list(R,1)+1,list(R,2),list(R,3))+inii(list(R,1)-1,list(R,2),list(R,3))+inii(list(R,1),list(R,2)+1,list(R,3))+...
                            inii(list(R,1),list(R,2)-1,list(R,3))+inii(list(R,1),list(R,2),list(R,3)+1)+inii(list(R,1),list(R,2),list(R,3)-1);R=R+1;
                        list(R,1) = floor(ppx/4)+1;list(R,2) = floor((-ppy+1152)/4)+1;list(R,3) = floor(( ppz)/10)+1;list(R,4) = dis4;
                        list(R,5) = inii(list(R,1)+1,list(R,2),list(R,3))+inii(list(R,1)-1,list(R,2),list(R,3))+inii(list(R,1),list(R,2)+1,list(R,3))+...
                            inii(list(R,1),list(R,2)-1,list(R,3))+inii(list(R,1),list(R,2),list(R,3)+1)+inii(list(R,1),list(R,2),list(R,3)-1);R=R+1;
                        list(R,1) = floor(ppx/4)+1;list(R,2) = ceil((-ppy+1152)/4)+1;list(R,3) = ceil(( ppz)/10)+1;list(R,4) = dis5;
                        list(R,5) = inii(list(R,1)+1,list(R,2),list(R,3))+inii(list(R,1)-1,list(R,2),list(R,3))+inii(list(R,1),list(R,2)+1,list(R,3))+...
                            inii(list(R,1),list(R,2)-1,list(R,3))+inii(list(R,1),list(R,2),list(R,3)+1)+inii(list(R,1),list(R,2),list(R,3)-1);R=R+1;
                        list(R,1) = ceil(ppx/4)+1;list(R,2) = ceil((-ppy+1152)/4)+1;list(R,3) = ceil(( ppz)/10)+1;list(R,4) = dis6;
                        list(R,5) = inii(list(R,1)+1,list(R,2),list(R,3))+inii(list(R,1)-1,list(R,2),list(R,3))+inii(list(R,1),list(R,2)+1,list(R,3))+...
                            inii(list(R,1),list(R,2)-1,list(R,3))+inii(list(R,1),list(R,2),list(R,3)+1)+inii(list(R,1),list(R,2),list(R,3)-1);R=R+1;
                        list(R,1) = ceil(ppx/4)+1;list(R,2) = floor((-ppy+1152)/4)+1;list(R,3) = ceil(( ppz)/10)+1;list(R,4) = dis7;
                        list(R,5) = inii(list(R,1)+1,list(R,2),list(R,3))+inii(list(R,1)-1,list(R,2),list(R,3))+inii(list(R,1),list(R,2)+1,list(R,3))+...
                            inii(list(R,1),list(R,2)-1,list(R,3))+inii(list(R,1),list(R,2),list(R,3)+1)+inii(list(R,1),list(R,2),list(R,3)-1);R=R+1;
                        list(R,1) = floor(ppx/4)+1;list(R,2) = floor((-ppy+1152)/4)+1;list(R,3) = ceil(( ppz)/10)+1;list(R,4) = dis8;
                        list(R,5) = inii(list(R,1)+1,list(R,2),list(R,3))+inii(list(R,1)-1,list(R,2),list(R,3))+inii(list(R,1),list(R,2)+1,list(R,3))+...
                            inii(list(R,1),list(R,2)-1,list(R,3))+inii(list(R,1),list(R,2),list(R,3)+1)+inii(list(R,1),list(R,2),list(R,3)-1);R=R+1;
                    elseif((ceil((-ppy+1152)/4)+1)+1 <= 2314/4 && (floor((-ppy+1152)/4)+1)-1 >= 1 && (floor(ppx/4)+1)-1 >= 1 && (ceil(ppx/4)+1)+1 <= 1920/4 && ceil(( ppz)/10)+2 <= 100)
                        list(R,1) = floor(ppx/4)+1;list(R,2) = ceil((-ppy+1152)/4)+1;list(R,3) = floor(( ppz)/10)+1;list(R,4) = dis1;
                        list(R,5) = inii(list(R,1)+1,list(R,2),list(R,3))+inii(list(R,1)-1,list(R,2),list(R,3))+inii(list(R,1),list(R,2)+1,list(R,3))+...
                            inii(list(R,1),list(R,2)-1,list(R,3))+inii(list(R,1),list(R,2),list(R,3)+1)+inii(list(R,1),list(R,2),list(R,3));R=R+1;
                        list(R,1) = ceil(ppx/4)+1;list(R,2) = ceil((-ppy+1152)/4)+1;list(R,3) = floor(( ppz)/10)+1;list(R,4) = dis2;
                        list(R,5) = inii(list(R,1)+1,list(R,2),list(R,3))+inii(list(R,1)-1,list(R,2),list(R,3))+inii(list(R,1),list(R,2)+1,list(R,3))+...
                            inii(list(R,1),list(R,2)-1,list(R,3))+inii(list(R,1),list(R,2),list(R,3)+1)+inii(list(R,1),list(R,2),list(R,3));R=R+1;
                        list(R,1) = ceil(ppx/4)+1;list(R,2) = floor((-ppy+1152)/4)+1;list(R,3) = floor(( ppz)/10)+1;list(R,4) = dis3;
                        list(R,5) = inii(list(R,1)+1,list(R,2),list(R,3))+inii(list(R,1)-1,list(R,2),list(R,3))+inii(list(R,1),list(R,2)+1,list(R,3))+...
                            inii(list(R,1),list(R,2)-1,list(R,3))+inii(list(R,1),list(R,2),list(R,3)+1)+inii(list(R,1),list(R,2),list(R,3));R=R+1;
                        list(R,1) = floor(ppx/4)+1;list(R,2) = floor((-ppy+1152)/4)+1;list(R,3) = floor(( ppz)/10)+1;list(R,4) = dis4;
                        list(R,5) = inii(list(R,1)+1,list(R,2),list(R,3))+inii(list(R,1)-1,list(R,2),list(R,3))+inii(list(R,1),list(R,2)+1,list(R,3))+...
                            inii(list(R,1),list(R,2)-1,list(R,3))+inii(list(R,1),list(R,2),list(R,3)+1)+inii(list(R,1),list(R,2),list(R,3));R=R+1;
                        list(R,1) = floor(ppx/4)+1;list(R,2) = ceil((-ppy+1152)/4)+1;list(R,3) = ceil(( ppz)/10)+1;list(R,4) = dis5;
                        list(R,5) = inii(list(R,1)+1,list(R,2),list(R,3))+inii(list(R,1)-1,list(R,2),list(R,3))+inii(list(R,1),list(R,2)+1,list(R,3))+...
                            inii(list(R,1),list(R,2)-1,list(R,3))+inii(list(R,1),list(R,2),list(R,3)+1)+inii(list(R,1),list(R,2),list(R,3));R=R+1;
                        list(R,1) = ceil(ppx/4)+1;list(R,2) = ceil((-ppy+1152)/4)+1;list(R,3) = ceil(( ppz)/10)+1;list(R,4) = dis6;
                        list(R,5) = inii(list(R,1)+1,list(R,2),list(R,3))+inii(list(R,1)-1,list(R,2),list(R,3))+inii(list(R,1),list(R,2)+1,list(R,3))+...
                            inii(list(R,1),list(R,2)-1,list(R,3))+inii(list(R,1),list(R,2),list(R,3)+1)+inii(list(R,1),list(R,2),list(R,3));R=R+1;
                        list(R,1) = ceil(ppx/4)+1;list(R,2) = floor((-ppy+1152)/4)+1;list(R,3) = ceil(( ppz)/10)+1;list(R,4) = dis7;
                        list(R,5) = inii(list(R,1)+1,list(R,2),list(R,3))+inii(list(R,1)-1,list(R,2),list(R,3))+inii(list(R,1),list(R,2)+1,list(R,3))+...
                            inii(list(R,1),list(R,2)-1,list(R,3))+inii(list(R,1),list(R,2),list(R,3)+1)+inii(list(R,1),list(R,2),list(R,3));R=R+1;
                        list(R,1) = floor(ppx/4)+1;list(R,2) = floor((-ppy+1152)/4)+1;list(R,3) = ceil(( ppz)/10)+1;list(R,4) = dis8;
                        list(R,5) = inii(list(R,1)+1,list(R,2),list(R,3))+inii(list(R,1)-1,list(R,2),list(R,3))+inii(list(R,1),list(R,2)+1,list(R,3))+...
                            inii(list(R,1),list(R,2)-1,list(R,3))+inii(list(R,1),list( ...
                            R,2),list(R,3)+1)+inii(list(R,1),list(R,2),list(R,3));R=R+1;
                    end    
                end
                l5_up = 0;
                l5_down = 0;
                for r2=1:R
                    if(list(r2,5) > key3*6 && l5_up == 0)
                        l5_up = r2;
                        l5_down = r2;
                    elseif(list(r2,5) > key3*6)
                        l5_down = r2;
                    end
                end
                if(l5_down > l5_up)
                    for r2=l5_up:l5_down
                        if(list(r2,5) ~= 0)
                            list(r2,6) = max((r2-l5_up),(l5_down-r2));
                        end
                    end
                    
                    m_6 = max(list(:,6));
                    list(:,6) = list(:,6)/m_6;
                    list(:,6) = exp(list(:,6)*5);
                end
                q = 0;
                a1 = 0;
                p = data(a,x,y);

                for r2=1:R-1
                    q = q+inii(list(r2,1),list(r2,2),list(r2,3))*list(r2,4);
                    a1 = a1+list(r2,6);
                end
%                 if (a1 > 10000)
%                     aaaaaa = 1;
%                 end
                %Apply a correction
                for r2=1:R-1
                    ini1(list(r2,1),list(r2,2),list(r2,3)) = ini1(list(r2,1),list(r2,2),list(r2,3))+list(r2,6)*(p-q)/(a1+0.00000000001);
                    ini2(list(r2,1),list(r2,2),list(r2,3)) = ini2(list(r2,1),list(r2,2),list(r2,3))+list(r2,4);
                end
                list(:,:) = 0;
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
    
            inii = inii+la*(ini1./ini2);
            ini1 = zeros(x_sum,y_sum+10,sclice);
            ini2 = zeros(x_sum,y_sum+10,sclice);
            for s=1:100
                for i=1:x_sum
                    for j=1:y_sum+10
                        if(inii(i,j,s) < 0)
                            inii(i,j,s) = 0;
                        end
                    end
                end
            end
            inii = medfilt3(inii,[3 3 3]);
        end
        if(mod(tt,15) == 0 && tt > 19 && tt < 100)
            for s=1:100
                for i=1:x_sum
                    for j=1:y_sum+10
                        if(inii(i,j,s) < key3)
                            inii(i,j,s) = 0;
                        end
                    end
                end
            end
            inii = inii*key2;
        end
    %     m_inii = max(max(max(inii)));
    %     for s=1:100
    %         for i=1:x_sum
    %             for j=1:y_sum+10
    %                 if(inii(i,j,s) > 0)
    %                     inii(i,j,s) = m_inii;
    %                 end
    %             end
    %         end
    %     end
    %     list = zeros(100*8,6);
        %%%閬稿嚭鏈?灏忓?硷紝寰楀埌鏈?绲傚湒鍍忥紙inii)
    %     ini3 = zeros(a,x_sum,y_sum+10,sclice);
    end
end