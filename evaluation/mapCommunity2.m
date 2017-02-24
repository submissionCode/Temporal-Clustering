function [ mapping] = mapCommunity2( distMtr, compIDs)
% Given a ranklist of retrieved clusters C_i, a list of ground truth
% communities C*_j, and a distance matrix between clusters and communities,
% return a mapping list.
% The mapping from C_k to C*_j is done by:
%       (1) select C*_j with smallest distance to C_i
%       (2) if C*_j is already mapped to C_k, k<i, then
%           (2.1) if C_i and C_k are from the same generative model GM_r
%           AND the distance is smaller than norm(C*_j),map C_i to C*_j;
%           (2.2) otherwise, mark the distance between C_i and C*_j to
%           inf, continue the next C*_l with smallest distance with C_i
% Input
%   - distMtr:      I*J matrix, m(i,j) is the distance between C_i and C*_j
%   - compId:       I*1 array,  rankList.compId(i) stores the gene-
%       rative model ID for cluster C_i; 
% Output
%   - mapping:      I*1 array, mapping(i)=j represents C_i maps to C*_j.
    [I, J] = size(distMtr);
    mapping = ones(I, 1) * -1;
    GTMapping = ones(J,1) * -1;
    for i = 1:I
       % choose mapping for i
       [~, idx] = min(distMtr(i,:));
       if distMtr(i, idx) ~= inf && (GTMapping(idx) ==-1 || GTMapping(idx) == compIDs(i) )
          GTMapping(idx) = compIDs(i);
          mapping(i) = idx;
          distMtr(find(compIDs~=compIDs(i)),idx) == inf;
       end
    end

end

