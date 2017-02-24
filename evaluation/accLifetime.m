%% calculate the precision and recall of lifetime detection for each clusters
%	Input:
%		mapping(array):	mapping(i)=k>0 means lifetime{i} is mapped to ground truth k. If k=-1, it is not mapped to any ground truth
%		lifetimeSet (matrix): lifetime{i} is a binary vector with ''1'' denoteing a time step is in the lifetime, and ''0'' denoting a time step is not
%		groundtruth (cell of arrays): ground truth
function [acc, prec, recall] = accLifetime(mapping, lifetimeSet, groundtruth)
	idxs = find(mapping>0);
	K = length(idxs);
	T = length(lifetimeSet{1});
	acc = {}; acc{K} = {};
	prec = {}; prec{K} = {};
	recall={}; recall{K} = {};
	for k = 1:length(idxs)
		a= lifetimeSet{idxs(k)}; a = a(:);
		pos = find(a > 0);
		neg = find(a ==0);
		b = groundtruth{mapping(idxs(k))}>0; b = b(:);
		truth = find(b==1);
		fal = find(b==0);
		acc{k} = nnz(a == b )*1.0/T;
		TP = length(intersect(pos, truth));
		prec{k} = 1.0* TP/ length(pos);
		recall{k} = 1.0 * TP / length(truth);
	end
end