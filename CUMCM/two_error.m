totalnum=20;%迭代次数
antnum=20;%蚂蚁个数
timecost=[];%时间成本矩阵
proportion=[];%比例
rgvwork=[];%小车工作时间
work1=[];%车床工作时间
work2=[];
cc=zeros(1,8);%工件计数
ress=[];%工件记录
shangxia=[];%上下料时间
p=0.9;%信息素衰减比例
ecount=0;%错误计数
%初始化
nowt=1;
time1=-1;
nowlx=leixing;
ttime=0;
while ttime<=60*60*8
    nowlx=leixing;
    for i=nowt:length(path) %故障发生器
        rng('shuffle')
        if rand()<0.01
            ecount=ecount+1;
            error(ecount,1)=ecount;
            k=find(nowlx(i,:)~=0,1);
            lx=nowlx(i,k);
            error(ecount,2)=k;
            if lx==1
                error(ecount,3)=path(i,k)+shangxia(k)+ceil(work1(k)*rand());
            else
                error(ecount,3)=path(i,k)+shangxia(k)+ceil(work2(k)*rand());
            end
            time1=error(ecount,3);
            timelast=ceil(rand()*600)+600;
            error(ecount,4)=time1+timelast;%结束时间
            break;
        end
    end
    if i==length(path)%退出循环判断
        break;
    end
    nowt=i+1
    anttime=path(i+1,path(i+1,:)~=0);%断面数据准备
    count=i;
    tend1(i+1,k)=error(ecount,4);
    tend=tend1(1:i+1,:);
    leixing=leixing(1:i+1,:);
    ttime=time1+timelast;
    locate=ceil(find(nowlx(i+1,:)~=0)/2);
    zhuazi=zhuazi1(1:i+1);
    pheromone=pheromone(1:i+1,:);
    antpath=path(1:i+1,:);
    zhuangtai=zhuangtai1(1:i+1,:);
    zhuangtai(i,k)=-1;
    zhuangtai(i+1,k)=-1;
    totalcount=0;
   for c=1:totalnum                                    %蚁群算法
    for int=1:antnum
        while anttime<=60*60*8
            count=count+1;
            tmp=timecost(locate,:);                    %到达各位置所需时间               
            tend(count+1,:)=tend(count,:);
            for i=1:8
                if tend(count,i)+shangxia(i)-anttime>tmp(i)
                    tmp(i)=tend(count,i)+shangxia(i)-anttime;
                end
            end
            if count>size(pheromone,1)
                pheromone(count,:)=1./tmp;%信息素初始值
            end
            if int<=antnum*max(pheromone(count,:))/sum (pheromone(count,:))+1%增强与探索比例,判断蚂蚁到达位置
                tt=pheromone(count,:).^2.*(1./tmp);
                x=find(tt==max(tt),1);   
                locate=ceil(x/2);
                antpath(count,x)=anttime+tmp(x)-shangxia(x);
                zhuangtaitmp=zhuangtai;
                zhuangtaitmp(count+1,:)=zhuangtaitmp(count,:);
                if zhuazi(count)<1  %车床工作停止时间
                    tend(count+1,x)=anttime+tmp(x)+work1(x);
                    zhuangtaitmp(count+1,x)=1;
                    leixing(count,x)=1;
                else
                    tend(count+1,x)=anttime+tmp(x)+work2(x);
                    zhuangtaitmp(count+1,x)=2;
                    leixing(count,x)=2;
                end
                if zhuangtai(count,x)==0||zhuangtai(count,x)==-1
                    anttime=anttime+tmp(x);
                    zhuazi(count+1)=0;
                else if zhuangtai(count,x)==1
                    anttime=anttime+tmp(x);
                    zhuazi(count+1)=1;
                    else
                        anttime=anttime+tmp(x)+rgvwork(x);
                        count1=count1+1;
                        zhuazi(count+1)=0;
                    end
                end
                zhuangtai=zhuangtaitmp;
            else
                tt=pheromone(count,:).^2.*(1./tmp);
                sumtt=0;
                m=rand();
                for bi=1:8
                    sumtt=sumtt+tt(bi);
                    pa=sumtt/sum(tt);
                    if m<pa
                        x=bi;
                        break;
                    end
                end
                locate=ceil(x/2);
                antpath(count,x)=anttime+tmp(x)-shangxia(x);
                zhuangtaitmp=zhuangtai;
                zhuangtaitmp(count+1,:)=zhuangtaitmp(count,:);
                if zhuazi(count)<1  %车床工作停止时间
                    tend(count+1,x)=anttime+tmp(x)+work1(x);
                    zhuangtaitmp(count+1,x)=1;
                else
                    tend(count+1,x)=anttime+tmp(x)+work2(x);
                    zhuangtaitmp(count+1,x)=2;
                end
                if zhuangtai(count,x)==0
                    anttime=anttime+tmp(x);
                    zhuazi(count+1)=0;
                else if zhuangtai(count,x)==1
                    anttime=anttime+tmp(x);
                    zhuazi(count+1)=1;
                    else
                        anttime=anttime+tmp(x)+rgvwork(x);
                        count1=count1+1;
                        zhuazi(count+1)=0;
                    end
                end
                zhuangtai=zhuangtaitmp;
            end
        end
        totalcount(cm)=count;
        cm=cm+1;
        if count>=max(totalcount)
            path=antpath;
            tend1=tend;
            zhuazi1=zhuazi;
            zhuangtai1=zhuangtai;
            pheromone1=pheromone;
            for mm=2:length(antpath)
                x=find(path(mm,:)~=0);
                if mm>2
                    xx=find(path(mm-1,:)~=0);
                else
                    xx=1;
                end
                pheromone=pheromone*0.9;
                pheromone(mm,x)=pheromone(mm,x)+0.1*(1/timecost(ceil(xx/2),x));
            end
        end
    end
   end
end