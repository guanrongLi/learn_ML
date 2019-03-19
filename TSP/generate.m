% 将基本的染色体序列随机打乱构造随机个体，可以构建num个随机个体
function pop = generate(num)
    res = [];
    % 算法思路是将tmp0中剩余的基因随机抽取依次填入tmp，当tmp0中的基因全部随机填入tmp后得到随机个体
    for i = 1:num
        tmp = zeros(1,108);
        tmp0 = 1:108;
        for j = 1:108
            % 随机下标
            index = randi([1,109-j]);
            tmp(j) = tmp0(index);
            % 删除从tmp0染色体中被随机选中的基因
            tmp0(:,index) = [];
        end
        k=find(tmp==1);
        t=tmp(k);
        tmp(k)=tmp(1);  
        tmp(1)=t;
        % 组装得到的随机个体
        res = [res;tmp];
    end
   
    pop = res;
end