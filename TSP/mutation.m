% ����ͻ�䣬����ͻ����ʣ�������������е�ĳ��������
function [child]=mutation(parent,probability)
    if rand() <= probability
        P = parent;
        % ���ѡ��������ͬ�Ļ��򽻻�λ��
        random1 = 0;
        random2 = 0;
        while random1 == random2
            random1 = randi([1 108]);
            random2 = randi([1 108]);
        end
        % ��ʼͻ��(����λ��)
        P(:,[random1,random2]) = P(:,[random2,random1]);
        child=P;
        res=child;
        k=find(res==1);
        tmp=res(k);
        res(k)=res(1);
        res(1)=tmp;
        child = res;
    else
        % û�з���ͻ��
        child = 0;
    end
end