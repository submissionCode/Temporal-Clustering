function netClusterSet = genKSetClusWAsynPeriodLife(numNet, netSize, minKClus, maxKClus, minClusSize, maxClusSize, T, minTseg, maxTseg, minRate, maxRate, minPow, maxPow, minAliveRate, maxAliveRate)
	%% generate numNet sets of parameters for numNet networks, each network containing K clusters, with T snapshots. Each cluster has its lifetime. some cluster-pair share no common nodes, but some other would share common nodes with multiple other clusters.
	%	Input:
	%		numNet (number): number of parameter sets, each parameter set will be used to generate one network
	%		netSize(number): number of nodes in a network;
	%		minKClus(number): minimum number of clusters in a network,
	%		maxKClus(number): max number of clusters in a network. 
	%		minClusSize(number): min number of nodes in a cluster,
	%		maxClusSize(number): max number of nodes in a cluster.
	%		minTseg(number):  minimum number of segment to cut time interval to generate lifetime, note this is not the number of segments of lifetime because a lifetime segment can be a cancadination of adjacent segments.
	%		maxTseg(number):  max number of segment to cut time interval
	%		minRate(number):  the min base of edge-generating rate for a cluster, p = rate^(power)
	%		maxRate(number):  the max base
	%		minPow(number):   the min power for edge-generating rate.
	%		maxPow(number):	  the max power. 
	netClusterSet = {};	% each splitSet{n} contains 500 nodes, which split to many disjoint clusters.
	netClusterSet{numNet} = [];
	for n =1:numNet
		numClus = randi([minKClus, maxKClus]); numSplClus = randi([floor(numClus/2), floor(numClus/4*3)]);
		netClusterSet{n} = genNetCluster(netSize, numClus, numSplClus, minClusSize, maxClusSize);
		%generate asynchronized periodic lifetime
		[netClusterSet{n}.lifetimes, netClusterSet{n}.lifeTypes]= getKAsynPeriodicLife(T, netClusterSet{n}.K, minTseg, maxTseg, minRate, maxRate, minPow, maxPow, minAliveRate, maxAliveRate);
	end
end

function [lives lifeTypes]= getKAsynPeriodicLife(T, K, minSeg, maxSeg, minBase, maxBase, minPow, maxPow, minAliveRate, maxAliveRate)
	lives ={};
	lives{K} = {};
	lifeTypes ={}; lifeTypes{K} =[];
	for i = 1:K
		%nSeg = randi([minSeg, maxSeg]); baseRate = minBase +(maxBase-minBase)*rand(1);
		seg = randi([minSeg, maxSeg]);
		alivePercent = minAliveRate + rand()*(maxAliveRate-minAliveRate);
		[lives{i}, lifeTypes{i}]= genPeriodicLifetime(T, K, seg, alivePercent, minBase, maxBase, minPow, maxPow);
	end
end