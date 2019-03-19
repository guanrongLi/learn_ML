file='D:\Project2018\1.xls';
costM=xlsread(file);
costM(:,1)=100000;
for i=1:107
    costM(i,i)=100000;
end
r=ones(1,107);
now=1;%目前位置
d=0;%总长
for i=1:106
    tmp=costM(now,:);
    a=find(tmp==min(tmp));
    a=a(1);
    d=d+costM(now,a);
    costM(:,a)=100000;
    r(i+1)=a;
    now=a;
end
