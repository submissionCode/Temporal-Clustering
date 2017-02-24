function [ distance ] = distFunTemporalCluster( CiIdx, CiProb, CiLambda, CjIdx, CjProb,CjLambda)
% Calculate the distance function between temporal cluster C_i and ground
% truth community C*_j:
%   d(i,j) = sum_{m,n\in union(C_i, C_j)}(a_{mi}a_{ni}lambda_{ti} - a*_{mj}a*_{ni}lambda*_{tj})^2 
%   where a_{mi}=0 if v_m is not in C_i, and a*_{mj}=0 is v_m is not in
%   C*_j. If d(i,j)/|C*_j| >=1, then C_i should not be mapped to C*_j
% Input
%   - CiIdx:    |C_i|*1 array, store node IDs in C_i, 
%   - CiProb:   |V|*1 array, store the probability of nodes belonging to
%   generative model GM_r that contains C_k.
%   - CiLambda: T*1 array, the edge-generating rate.
% Output
%   distance:   double, the distance defined by d(i,j)
    allNotes = 1:length(CiProb);
    CiProb(setdiff(allNotes, CiIdx)) = 0;
    CjProb(setdiff(allNotes, CjIdx)) = 0;
    allNotes = union(CiIdx, CjIdx);
    CiProb = CiProb(allNotes); CiProb = CiProb(:); 
    CjProb = CjProb(allNotes); CjProb = CjProb(:);
    CiProb = CiProb * CiProb'; CiProb = CiProb(:);
    CjProb = CjProb * CjProb'; CjProb = CjProb(:);
    CiProb = CiProb * CiLambda(:)';
    CjProb = CjProb * CjLambda(:)';
    distance = sum(sum((CiProb - CjProb).^2));
end

