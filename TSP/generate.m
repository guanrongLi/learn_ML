% ��������Ⱦɫ������������ҹ���������壬���Թ���num���������
function pop = generate(num)
    res = [];
    % �㷨˼·�ǽ�tmp0��ʣ��Ļ��������ȡ��������tmp����tmp0�еĻ���ȫ���������tmp��õ��������
    for i = 1:num
        tmp = zeros(1,108);
        tmp0 = 1:108;
        for j = 1:108
            % ����±�
            index = randi([1,109-j]);
            tmp(j) = tmp0(index);
            % ɾ����tmp0Ⱦɫ���б����ѡ�еĻ���
            tmp0(:,index) = [];
        end
        k=find(tmp==1);
        t=tmp(k);
        tmp(k)=tmp(1);  
        tmp(1)=t;
        % ��װ�õ����������
        res = [res;tmp];
    end
   
    pop = res;
end