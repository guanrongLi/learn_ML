% 根据代价矩阵costM计算种群pop的总路程代价
function [value] = cost(pop,costM)
    % 求得种群的个体数量，从而对每个个体计算代价
    [NumP,~]=size(pop);
    % 循环对每个个体计算代价
    for i=1:NumP
        parent_i = pop(i,:);
        value_i = 0;
        % 累加相邻两个城市之间的距离
        for j=1:106
            value_i = value_i + costM(parent_i(j),parent_i(j+1));
        end
        % 将最后一个城市和出发城市的距离加上，组成闭合回路
        value_i = value_i + costM(parent_i(107),parent_i(1));
        % 结果组装
        value(i,1) = value_i;
    end
end