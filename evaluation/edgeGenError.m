function [ dist ] = edgeGenError( CkIdx, CkProb, CkRate, CmIdx, CmProb, CmRate)
% this function calculate the distance of two temporal clusters
% A temporal cluster C_k generates a dynamic network G_t, the number
% of edges between v_i, v_j at time t is expected to be
%   e^k_t(i,j) = a_{ik} * a_{jk} * lambda_{tk}
%       where a_{ik} represents the probability of v_i belonging to C_k,
%       lambda_{tl} = lamba_{k}(t), lambda_k(t) is a function representing 
%       the probability of generating one edge between 2
%       nodes at a unit length of time. It is a funtion of time. 
% The distance between temporal clsuters C_k, C_m is define as the edge generating
% error:
%       \sum_{i,j\in C_k\cup C_m}\sum_{t=1}^T [e^k_t(i,j) - e^m_t(i,j)]^2
% Note that a_{ik} = 0 represents that v_i does not belong to C_k.
%
% Input
%   - CkIdx:        set, indice of nodes belonging to C_k
%   - CkProb:       |V|*1 vector, probabilities of *ALL* nodes belonging to C_k
%   - CkRate:       vector, edge generating rate for Generative model, \lambda_{tk}
% Output
%   - dist:         double, distance between C_k and C_m
    % initialize
    CkIdx = CkIdx(:); CkProb = CkProb(:); CkRate = CkRate(:);
    CmIdx = CmIdx(:); CmProb = CmProb(:); CmRate = CmRate(:);
    
    V = length(CkProb);
    CkCoMtr = zeros(V, V);
    CkCoMtr(CkIdx, CkIdx) = 1;
    CkCoMtr = CkCoMtr .* (CkProb * CkProb');
    CmCoMtr = zeros(V,V);
    CmCoMtr(CmIdx, CmIdx) = 1;
    CmCoMtr = CmCoMtr .* (CmProb * CmProb');
    
    CkCoMtr = CkCoMtr(:);
    CmCoMtr = CmCoMtr(:);
    dist = sum(sum((CkCoMtr * CkRate' - CmCoMtr * CmRate').^2));
end

