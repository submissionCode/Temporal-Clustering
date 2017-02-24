function [ error ] = componentError( CiIdx, CiProb, CiProb2, CiLambda, CjIdx, CjProb, CjProb2, CjLambda )
% Calculate the distance function between temporal cluster C_i and ground
% truth community C*_j:
%   d(i,j) = sum_{m,n\in union(C_i, C_j)}(a_{mi}a_{ni}lambda_{ti} - a*_{mj}a*_{ni}lambda*_{tj})^2 
%   where a_{mi}=0 if v_m is not in C_i, and a*_{mj}=0 is v_m is not in
%   C*_j. If d(i,j)/|C*_j| >=1, then C_i should not be mapped to C*_j
% Input
%   - CiIdx:    |C_i|*1 array, store node IDs in C_i, 
%   - CiProb1,2: |V|*1 array, store the probability of nodes belonging to
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
    CiProb2 = CiProb2(allNotes); CiProb2 = CiProb2(:); 
    CjProb2 = CjProb2(allNotes); CjProb2 = CjProb2(:);
    kten = ktensor(1, CiProb, CiProb2, CiLambda);
    kten2 = ktensor(1, CjProb, CjProb2, CjLambda);
    error = norm(kten-kten2);

end

