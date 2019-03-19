% 检查两个父代个体是否可以交叉得到有效的两个子代个体
function res = crosscheck(parent1,parent2)
    res = 0;
    % 对每个交叉点进行交叉看是否至少有一个交叉点是有效的
    for i = 1:107
        p1 = [parent1(:,1:i) parent2(:,i+1:108)];
        p2 = [parent2(:,1:i) parent1(:,i+1:108)];
        % 如果子代基因没有重复的则是有效子代
        if length(p1)==length(unique(p1)) && length(p2)==length(unique(p2))
            res = 1;
        end
    end
end
