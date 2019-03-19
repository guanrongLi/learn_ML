co=0;%工件计数
res=[];%结果矩阵
leixing(1,:)=[1,0,0,0,0,0,0,0];
for i=1:length(leixing)
try
     k=find(leixing(i,:)~=0);
     if zhuangtai(i+1,k)==-1
         continue;
     end
        co=co+1;
        res(co,1)=co;
        res(co,2)=k;
        res(co,3)=path(i,k);
        ti=i+1;
        while leixing(ti,k)==0&&ti<length(leixing)-1
            ti=ti+1;
        end
        res(co,4)=path(ti,k);
catch
end
end

