function [ spar ] = getKTensorSparsity( fac, rankList, mapping, varargin )
% calculate the sparsities for each component from PARAFAC, 
% Let V1, V2, V3 be 3 loading vectors, a component C is a rank-1 tensor formed by
% the outerproduct of the vectors, the sparsities of C from t=1 to t=T are calculated:
%   sparsity(t) = sum_{v_m,v_n \in C}a_{mr}a_{nr}ts{tr}/(|C|^2-|C|);
% where a_{mr} = fac.u{1}(m,r), ts{tr} = fac.u{3}(t,r); 
% This function uses tensor tool box and construct ktensor from loading
% matrix and use collapse function for summing the first mode of C
% Input
%   - fac:  object, result from PARAFAC decomposition
%   - rankList:     object, contains a rankList clusters{} and an array
%   compID
%       - rankList.clusters: K*1 cell, each cell contains the node ID
%       - rankList.compID:   K*1 array, stores the IDs of generative model
% Output:
%   - spar:  T*K matrix, spar(t,k) is the sparsity of cluster C_k at time t
%   Detailed explanation goes here
    %initialization
    N = 0;
    K = length(mapping);
    [T, R] = size(fac.u{3});
    spar = zeros(T, R);
    for k = 1:K
        if mapping(k) > 0
            r = rankList.compID(k);
            N = length(rankList.clusters{k});
            if length(varargin) && varargin{1} == true
                N = N*(N-1);
            else
                N = N^2;
            end
            tmpA = fac.u{1}(rankList.clusters{k},r);
            tmpB = fac.u{2}(rankList.clusters{k},r);
            tmpA = sum(sum((tmpA * tmpB'))) ...
                /N; 
            spar(:,k) = fac.lambda(r) * tmpA * fac.u{3}(:,r);
        end
    end

end

