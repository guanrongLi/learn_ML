% ���ݴ��۾���costM������Ⱥpop����·�̴���
function [value] = cost(pop,costM)
    % �����Ⱥ�ĸ����������Ӷ���ÿ������������
    [NumP,~]=size(pop);
    % ѭ����ÿ������������
    for i=1:NumP
        parent_i = pop(i,:);
        value_i = 0;
        % �ۼ�������������֮��ľ���
        for j=1:106
            value_i = value_i + costM(parent_i(j),parent_i(j+1));
        end
        % �����һ�����кͳ������еľ�����ϣ���ɱպϻ�·
        value_i = value_i + costM(parent_i(107),parent_i(1));
        % �����װ
        value(i,1) = value_i;
    end
end