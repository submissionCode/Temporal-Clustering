function [ rankList ] = binaryClustering( fac, th, modeID)
% Generate a rank List of communities using a binary clustering with th=0.5
% threshold on loading vectors from parafac decomposition.
%   Let A_r be a |V|*1 loading vector from the r-th component from PARAFAC,
%   the set of nodes {v_n|A_r(n)> (max(A_r)/2)} is a community in a
%   network, {v_m|A_r(m)<= (max(A_r)/2)} are considered as a  unrelated set
% Input
%   - fac:  object, the result from PARAFAC decomposition
%       -fac.u{1}:  I*R loading matrix from the first mode
%       -fac.u{2}:  J*R loading matrix from the 2nd mode
%       -fac.u{3}:  K*R loading matrix from the 3rd mode
%   - th:   percentage of maxValue for threshold
%   - modeID:   the mode of the Fac for classificaion.
% Output
%   - rankList:     object, contains a rankList clusters{} and an array
%   compID
%       - rankList.clusters: I*1 cell, each cell contains the node ID
%       - rankList.compID:   I*1 array, stores the IDs of generative model
%Detailed explanation goes here
    rankList = {};
    [~, R] = size(fac.u{modeID});
    rankList.clusters = {}; rankList.clusters{R}  = [];
    rankList.compID = 1:(R);
    for r = 1:R
       maxVal = max(fac.u{modeID}(:,r)); 
       rankList.clusters{r} = find(fac.u{modeID}(:,r)>maxVal*th);
       rankList.compID(r) = r;       
    end
end

