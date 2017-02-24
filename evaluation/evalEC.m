function evaluation = tmpfun( idVec, cellClusters, edgeRates )
%UNTITLED3 Summary of this function goes here
%   Input: 
%       idVec (array): indicator vector 
%       cellClusters (1*N cell array): cellClusters{i} is the set of IDs from
%           the i-th ground truth cluster
%       edgeRates (array): a k*1 array, edgeRates(i) represents the
%       edge-generating rate for cluster i, if edgeRate(i)==0, cluster i
%       does not exist in this step.
%   Output:
%       evaluation ((M+2)*1 array): evaluation(i)>0.5 represents cluster i is
%           correctly identified, and the value is member recall; -1 means missing
%           the ith ground truth cluster; evaluation(M+1) is cluster
%           recall, evaluation(M+2) is total member recall,
    K = length(unique(idVec));
    groundTrueCluIdx = find(edgeRates>0);
    N = length(groundTrueCluIdx);
    M = length(cellClusters);
    clus=cell(K,1);
    simMtr = zeros(K, N);
    for k = 1:K
        clus{k} = find(idVec==k);
        for n = 1:N
            simMtr(k,n) = 1.0 * length(intersect(clus{k}, cellClusters{groundTrueCluIdx(n)})) ...
                / length(union(clus{k}, cellClusters{groundTrueCluIdx(n)}));
        end
    end
    simMtr(simMtr<0.5) = 0;
    evaluation = zeros(M+2, 1);
    mapping=zeros(K,1);
    numGTMember = 0;
    recallMem = 0;
    for n = 1:N
        numGTMember = numGTMember + length(cellClusters{groundTrueCluIdx(n)});
        [m, idx] = max(simMtr(:,n));
        if m==0
            evaluation(groundTrueCluIdx(n)) = -1;
        else
            mapping(idx) = groundTrueCluIdx(n);
            % member recall of a cluster
            recallMem = length(intersect(clus{idx}, cellClusters{groundTrueCluIdx(n)}));
            evaluation(groundTrueCluIdx(n)) = recallMem / length(cellClusters{groundTrueCluIdx(n)});
            evaluation(M+2) = evaluation(M+2) + recallMem;
        end
    end

end