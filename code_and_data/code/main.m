hei = 720;
zz = recon_sart_min(data7,10,hei);
nu = 0;
t = 0;
for i=1:100
    for j=1:480
        for k=30:576-30
            if(zz(j,k,i) > 0)
                nu = nu+zz(j,k,i);
                t = t+1;
            end
        end
    end
end
key1 = nu/t*1.45;
[dd2,dd,ini] = st1(zz,key1);
[data,data2] = st2(dd,data7,5);
[data3,data4] = st2(dd2,data7,5);
I1 = recon_sart(data3,50,hei);
I2 = recon_cal_3(data4,ini*100,1.2,0.1);
I3 = I2;
for i=1:100
    for j=1:480
        for k=1:576
            if(I3(j,k,i) < 0.1)
                I3(j,k,i) = 0;
            end
        end
    end
end