function [data7,data2] = st2(dd2,data,kt)
    data7 = data;
    for i=1:21
        for j=1:480
            for k=1:576
                if(dd2(i,j,k) > 0)
                    data7(i,j,k) = 0;
                end
            end
        end
    end
    % 
    kkk = kt;
    for i=1:21
        for j=1:480
            for k=1:576
                if(data7(i,j,k) == 0 && dd2(i,j,k) > 0 && j>kkk && k>kkk && j+kkk < 480 && k+kkk<576)
                    I2 = sum(sum(reshape(data7(i,j-kkk:j+kkk,k-kkk:k+kkk),[kkk*2+1 kkk*2+1])));
                    I1 = sum(sum((reshape(data7(i,j-kkk:j+kkk,k-kkk:k+kkk),[kkk*2+1 kkk*2+1]) ~= 0)));
                    data7(i,j,k) = I2/I1;
                end
            end
        end
    end
    data2 = data-data7;
end