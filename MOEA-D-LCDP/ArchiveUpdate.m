function Population = ArchiveUpdate(Population,N)
% Update archive

%------------------------------- Copyright --------------------------------
% Copyright (c) 2021 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    %% Select feasible solutions
    fIndex     = all(Population.cons <= 0,2);
    Population = Population(fIndex);
    if isempty(Population)
        return
    else  
            Population = Population(NDSort(Population.objs,1)==1);
            Population = Population(randperm(length(Population)));
            PCObj = Population.objs;
            nND   = length(Population);
            %% Population maintenance
            if length(Population) > N
                % Normalization
                fmax  = max(PCObj,[],1);
                fmin  = min(PCObj,[],1);
                PCObj = (PCObj-repmat(fmin,nND,1))./repmat(fmax-fmin,nND,1);
                % Determine the radius of the niche
                d  = pdist2(PCObj,PCObj);
                d(logical(eye(length(d)))) = inf;
                sd = sort(d,2);
                r  = median(sd(:,min(size(PCObj,2),size(sd,2))));
                R  = min(d./r,1);
                % Delete solution one by one
                while length(Population) > N
                    [~,worst]  = max(1-prod(R,2));
                    Population(worst)  = [];
                    R(worst,:) = [];
                    R(:,worst) = [];
                end
            end
    end
end