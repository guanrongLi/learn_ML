% 遗传算法求解TSP旅行商问题

% 清空
close all;
clc;
%----------------------------data area-------------------------------------
% distance from a city to others
file='D:\Project2018\1.xls';
costM=xlsread(file);
%双旅行商问题
costM(108,:)=costM(1,:);
costM(:,108)=costM(:,1);
costM(108,1)=100000;
costM(1,108)=100000;

%mutation probability
pmutation = 1.0;
%max generation
MaxGeneration = 800;
%poputation sizer
popsize = 20;
%select popsize parents from randomsize generated possible parents
randsize = 200;

%parent generations
parentpop = [];
%best parent of every generation
best_cost = [];

%-------------------generate parent generation-----------------------------
preparentpop = generate(randsize);
[A,index] = sort(cost(preparentpop,costM),1,'ascend');
%orderd preparentpop
orderedpreparentpop = preparentpop(index,:);
%selected top popsize parentpop
parentpop = orderedpreparentpop([1:popsize],:);

%---------------------main revolution loop---------------------------------
for igen = 1:MaxGeneration
    childpop = [];
    childpopsize = [0 0];
    %generate enough children
    while childpopsize(1) < popsize
        % To generate the random index for crossover and mutation 
        ind=randi(popsize,[1 2]) ;
        parent1 = parentpop(ind(1),:);
        parent2 = parentpop(ind(2),:);
        [child1,child2] = crossover(parent1,parent2);
        [child3] = mutation(parent1,pmutation);
        if child1~=0
            childpop = [childpop;child1];
        end
        if child2~=0
            childpop = [childpop;child2];
        end
        if child3~=0
            childpop = [childpop;child3];
        end
        childpopsize = size(childpop);
    end

    % Elite: parentpop and childpop are added together before sorting for the best popsize to continue
    allpop = [parentpop;childpop];
    [A,index] = sort(cost(allpop,costM),1,'ascend');
    orderdallpop = allpop(index,:);
    %parentpop of current generation
    parentpop = orderdallpop([1:popsize],:);
    best_cost(igen)=A(1);
end

%display
display('the best parentpop:')
parentpop
display('the lowest cost of every generation:')
best_cost'

figure,plot(1:igen,best_cost,'b') 
title('GA algorithm for TSP problem')

