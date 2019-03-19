% 染色体交叉
function [child1, child2]=crossover(parent1, parent2)
    % 如果父代不可交叉子代置0表示无效
    child1 = 0;
    child2 = 0;

    if crosscheck(parent1,parent2) == 1
        p1 = ones(1,108);
        p2 = p1+1;
        % 确保子代有效
        while length(p1)>length(unique(p1)) || length(p2)>length(unique(p2))
            % 随机选择交叉点
            crossPoint = randi([1,108]);
            p1 = [parent1(:,1:crossPoint) parent2(:,crossPoint+1:108)];
            p2 = [parent2(:,1:crossPoint) parent1(:,crossPoint+1:108)];
        end
        child1 = p1;
        child2 = p2;
        res=child1;
        k=find(res==1);
        tmp=res(k);
        res(k)=res(1);
        res(1)=tmp;
        child1 = res;
        res=child2;
        k=find(res==1);
        tmp=res(k);
        res(k)=res(1);
        res(1)=tmp;
        child2 = res;
    end
end