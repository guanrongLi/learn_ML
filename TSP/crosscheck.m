% ����������������Ƿ���Խ���õ���Ч�������Ӵ�����
function res = crosscheck(parent1,parent2)
    res = 0;
    % ��ÿ���������н��濴�Ƿ�������һ�����������Ч��
    for i = 1:107
        p1 = [parent1(:,1:i) parent2(:,i+1:108)];
        p2 = [parent2(:,1:i) parent1(:,i+1:108)];
        % ����Ӵ�����û���ظ���������Ч�Ӵ�
        if length(p1)==length(unique(p1)) && length(p2)==length(unique(p2))
            res = 1;
        end
    end
end
