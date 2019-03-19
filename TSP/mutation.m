% 基因突变，按照突变概率，随机交换个体中的某两个基因
function [child]=mutation(parent,probability)
    if rand() <= probability
        P = parent;
        % 随机选择两个不同的基因交换位置
        random1 = 0;
        random2 = 0;
        while random1 == random2
            random1 = randi([1 108]);
            random2 = randi([1 108]);
        end
        % 开始突变(交换位置)
        P(:,[random1,random2]) = P(:,[random2,random1]);
        child=P;
        res=child;
        k=find(res==1);
        tmp=res(k);
        res(k)=res(1);
        res(1)=tmp;
        child = res;
    else
        % 没有发生突变
        child = 0;
    end
end