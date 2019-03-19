co=0;%工件计数
res=[];%结果矩阵
for i=1:length(leixing)
try
     k=find(leixing(i,:)~=0);
    if leixing(i,k)==1
        co=co+1;
        res(co,1)=co;
        res(co,2)=k;
        res(co,3)=path(i,k);
        ti=i+1;
        ti1=ti+1;
        while leixing(ti,k)==0&&ti<length(leixing)-1
            ti=ti+1;
        end
        res(co,4)=path(ti,k);
        ti=ti+1;
        ki=find(leixing(ti,:)~=0);
        ti2=ti+1;
        res(co,5)=ki;
        res(co,6)=path(ti,ki);
        if zhuangtai1(ti1,k)==-1||zhuangtai1(ti2,ki)==-1%工件加工过程是否产生故障
            res(co,:)=[];
            co=co-1;
            continue;
        end
        ti=ti+1;
        while leixing(ti,ki)==0&&ti<length(leixing)-1
            ti=ti+1;
        end
        res(co,7)=path(ti,ki);
    end
catch
end
end