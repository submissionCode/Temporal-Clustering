function [ distMtr ] = getDistMtrForClusAndCommu( rankList, CommuList, fac )
% Calculate the distance between retrieved temporal clusters C_i and the 
% ground truth communities C*_j.
% The distance function dist(C_i, C*_j) is defined by the frobenius norm of
% the normalized approximation error:
%       dist(C_i, C*_j) = sum_{t=1}^T [
%        sum_{v_m,v_n\in C_i-C*_j}(a_{mi}a_{ni}lambda_{ti})^2
%        + sum_{v_m,v_n\in C*_j-C_i}(a*_{mi}a*_{ni}lambda_{tj})^2
%        + sum_{v_m,v_n\in intersec(C*_j,C_i)}(a_{mi}a_{ni}lambda_{ti} -
%        a*_{mi}a*_{ni}lambda_{tj})^2]/norm(C*_j)
%   norm(C*_j) is the frobenious norm of tensor constructred from C*_j, if
%   dist(i,j)>=1, then dist(i,j) is set to inf, indicating that C_i poorly
%   approximates C*_j, even worse than an empty cluster.
% Input
%   - rankList:     object, contains a rankList clusters{} and an array
%   compID
%       - rankList.clusters: I*1 cell, each cell contains the node ID
%       - rankList.compID:   I*1 array, stores the IDs of generative model
%   - CommuList:    J*1 cells, store info of each ground truth of component
%       - CommuList{j}.idx:  array, node ID in community C*_j
%       - CommuList{j}.prob: array, probabilities of node belong to the
%       community C*_j.
%       - CommuList{j}.rates:   T*1 array, the edge-generating rate at time
%       step t.
%   - fac:          object, result from tensor decomposition on dynamic net
%       -fac.u{1}:  I*R matrix, r-th column vector of the matrix represents
%       the weights of nodes belonging to the r-th generative model.
%       mode 1 from tensor decomposition. Each column vector needs to be
%       normalized to [0 1] to represent probability a_{mi}. meanwhile,
%       lambda(r) will be updated after normalization.
%       -fac.u{2}:  K*R matrix, r-th column vector represent weights of the 
%       nodes in the second mode that relate to r-th generative model. need
%       to be normalized to [0 1];
%       - fac.u{3}: T*R matrix, r-th column vector presenting the weihgt of
%       time relating to r-tgenerative model. After normalizing u{1} and
%       u{2}, u{3}(:,r) will multiply updated lambda to represent the
%       edge-generating rate thoughout the time.
%       - fac.lambda:   R*1 array, the lambda value from PARAFAC
%       decomposition, in temporal clustering
% Output
%   - distMtr:  I*J matrix, distMtr(i,j) represent the distance between
%   cluster C_i and ground truth community C*_j.
%   Detailed explanation goes here

    % initialized variables
    R = length(fac.lambda);
    I = length(rankList.clusters);
    J = length(CommuList);
    % normalize column vectors from PARAFAC decomposition.
    for r = 1:R
       maxVal = max(fac.u{1}(:,r));
       %minVal = min(fac.u{1}(:,r));
       itv = maxVal;
       fac.u{1}(:,r) = fac.u{1}(:,r)/itv;
       fac.lambda(r) = fac.lambda(r) * itv;
       maxVal = max(fac.u{2}(:,r));
       %minVal = min(fac.u{2}(:,r));
       itv = maxVal;
       fac.u{2}(:,r) = fac.u{2}(:,r)/itv;
       fac.lambda(r) = fac.lambda(r) * itv;
       fac.u{3}(:,r) = fac.u{3}(:,r) * fac.lambda(r);
    end
    
    % calculate the norm of each community C*_j
    norms = zeros(J,1);
    for j= 1:J
        kten = ktensor(1, CommuList{j}.prob,CommuList{j}.prob, CommuList{j}.rates);
        norms(j) = norm(kten);
        %norms(j) = normOfTemporalCluster(CommuList{j}.idx, CommuList{j}.prob, CommuList{j}.rates);
    end
    % calculate the error if C_i approximates C*_j and obtain a matrix.
    distMtr = zeros(I,J);
    for i = 1:I
       for j = 1:J
           distMtr(i,j) = componentError(rankList.clusters{i}, ... 
           fac.u{1}(:,rankList.compID(i)),fac.u{2}(:,rankList.compID(i)), fac.u{3}(:,rankList.compID(i)), ... 
           CommuList{j}.idx, CommuList{j}.prob,CommuList{j}.prob, CommuList{j}.rates);
       end
    end
    % normalized each column j of the matrix with C*_j's norm
    distMtr = distMtr ./ repmat(norms',[I, 1]);
    distMtr(distMtr>=0.999) = inf;
end

