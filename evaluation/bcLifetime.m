%% calculate the precision and recall of lifetime detection for each clusters
%	Input:
%		mapping(array):	mapping(i)=k>0 means lifetime{i} is mapped to ground truth k. If k=-1, it is not mapped to any ground truth
%		lifetimeSet (cell of arrays): lifetime{i} is a binary vector with ''1'' denoteing a time step is in the lifetime, and ''0'' denoting a time step is not
%		groundtruth (cell of arrays): ground truth
function [lifetime] = bcLifetime(lifetimeSet)
	K = length(lifetimeSet(1,:));
	lifetime = {}; lifetime{K} = {};
	for k = 1:K
		lifetime{k} = lifetimeSet(:,k) > (max(lifetimeSet(:,k))/2.0);
	end
end