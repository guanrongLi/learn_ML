file='D:\Project2018\1.xls';
r=xlsread(file);
t=zeros(1,106);
d=zeros(107,2^106);
for i=1:107
    r(i,i)=1000000;
    d(i,1)=r(i,1);
end
for j=1:2^106
    for i=1;107
        d(i,j)=2^200;
        if mod(j/2^(i-1),2)==1
            continue;
        end
    end
    for k=1:n
        if mod(j/2^(i-1),2)==0
            continue;
        end
        if d(i,j)>r(i,k)+d(k,j-2^(k-1))
            d(i,j)=r(i,k)+d(k,j-2^(k-1));
        end
    end
end