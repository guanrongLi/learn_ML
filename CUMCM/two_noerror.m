clc;clear;
totalnum=100;%��������
antnum=20;%���ϸ���
timecost=[];%ʱ��ɱ�����
proportion=[];%����
pheromone=[];%��Ϣ�ؾ���
rgvwork=[];%С������ʱ��
work1=[];%��������ʱ��
work2=[];
zhuangtai=zeros(1,8);%��������״̬
shangxia=[];%������ʱ�����
p=0.1;%��Ϣ��˥������
cm=1;%ͳ�Ƽ���
%��������    
path=[];%��ǰ·��
totalcount=[];
for c=1:totalnum
    for int=1:antnum
        %��ʼ��
        zhuangtai=zeros(1,8);
        antpath=[];
        zhuazi=0;%��еצ״̬
        count=0;%���ϼƲ�
        count1=0;%�ܸ���
        count2=0;
        anttime=0;%���ϼ�ʱ
        tend=zeros(1,8);%�����������ʱ��
        locate=1;
        while anttime<=60*60*8
            count=count+1;
            count2=count2+1;
            tmp=timecost(locate,:);%�����λ������ʱ��
            for i=1:8
                if tend(count,i)+shangxia(i)-anttime>tmp(i)
                    tmp(i)=tend(count,i)+shangxia(i)-anttime;
                end
            end
            if count>size(pheromone,1)
                pheromone(count,:)=1./tmp;%��Ϣ�س�ʼֵ
            end
            if int<=antnum*(0.1+0.9*max(pheromone(count,:))/sum (pheromone(count,:)))+1%��ǿ��̽������,�ж����ϵ���λ��
                tt=pheromone(count,:).^2.*(1./tmp);
                x=find(tt==max(tt),1);   
                locate=ceil(x/2);
                antpath(count,x)=anttime+tmp(x)-shangxia(x);
                zhuangtaitmp=zhuangtai;
                zhuangtaitmp(count+1,:)=zhuangtaitmp(count,:);
                if zhuazi(count)<1  %��������ֹͣʱ��
                    tend(count+1,:)=tend(count,:);
                    tend(count+1,x)=anttime+tmp(x)+work1(x);
                    zhuangtaitmp(count+1,x)=1;
                    leixing(count,x)=1;
                else
                    tend(count+1,:)=tend(count,:);
                    tend(count+1,x)=anttime+tmp(x)+work2(x);
                    zhuangtaitmp(count+1,x)=2;
                    leixing(count,x)=2;
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
                if zhuazi(count)<1  %��������ֹͣʱ��
                    tend(count+1,:)=tend(count,:);
                    tend(count+1,x)=anttime+tmp(x)+work1(x);
                    zhuangtaitmp(count+1,x)=1;
                else
                    tend(count+1,:)=tend(count,:);
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
        totalcount(cm)=count1;%����ͳ��
        cm=cm+1;
        if count1>=max(totalcount)%��Ϣ���ظ���
            if count1==max(totalcount)
                path=antpath;
            tend1=tend;
            zhuazi1=zhuazi;
            zhuangtai1=zhuangtai;
            pheromone1=pheromone;
            end
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