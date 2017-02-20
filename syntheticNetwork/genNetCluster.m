function netCluster = genNetCluster(N, numClus, numSplClus, minSize, maxSize)
	%%
	%	Input:
	%		N: number, size of network
	clusters={};
	clusters{numClus} = [];
	clusSize = randi([minSize, maxSize], 1, numSplClus);
	splIdx = cumsum(clusSize);
	while splIdx(end-1)>=N || length(splIdx)> numSplClus
		clusSize(end) =[];
		splIdx(end) =[];
	end
	if splIdx(end) > N
		clusSize(end) = clusSize(end) + N - splIdx(end);
	else
		clusSize(end) = clusSize(end) - N + splIdx(end);
	end
	splIdx(end) = N;
	numSplClus = min(numSplClus, length(clusSize));
	i = 0;
	% for disjoint clusters
	for j = 1:numSplClus
		clusters{j} = (i+1):splIdx(j);
		i = splIdx(j);
	end
	% for coverClusters the would share common nodes with those disjoint clusters
	clusSize = randi([minSize, maxSize], 1, numClus - numSplClus);
	for j = (numSplClus+1):numClus
		splIdx = randperm(N);
		clusters{j} = sort(splIdx(1:clusSize(j-numSplClus)));
	end
	netCluster.K = numClus;
	netCluster.N = N;
	netCluster.clusters = clusters;
end