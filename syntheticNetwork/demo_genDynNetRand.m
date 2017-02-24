%% dataset1: generate dynamic networks contains minK~maxK randomly generated clusters. In  this dataset, each cluster has the edge-generating rate within [baseRate, mbaseRate], size within [PA.minClussize, PA.maxClusSize], lifetime segments are randomly generated.
% output to file
%	netClusterSet (cell array of dynamic networks): netClusterSet{nt} is a dynamic network
%		netClusterSet{nt}.clusters (cell array of interger arrays): netClusterSet{nt}.clusters{k} stores the node ID for the k-th ground truth cluster.
%		netClusterSet{nt}.lifetimes (cell array of double arrays): netClusterSet{nt}.lifetimes{k} stores the edge-generating rate from t=1,...,T. If the rate=0 at time step t, the cluster does not appear at that time step.
%		cellNet (cell array of network snapshot): for Evolutionary Clustering program to run
%		ecIds (cell array of node ID at snapshots): for Evolutionary clustering program to run.
clear all;
dirname = './rand/';
mkdir(dirname);

%demo
Ts = [1000];	%time steps
Ns = [200];	%network size
minK = [10];	% min # clusters
maxK = [10];	
mrateBase = [1];
rateBase = [0.8]; %	P
rateMinPower = [1];	%
rateMaxPower = rateMinPower;
repeat = 1;		% generate a network with the same parameters
PA.numNet = 1; 
PA.minClusSize = 5;	%minum number of nodes in a cluster
PA.maxClusSize = 15;	% max num
PA.minTseg = 4;			% min segments on the time interval[1, T] for generating cluster lifetime
PA.maxTseg = 10;

%
% Ts = [1000, 2000, 3000, 4000];	%time steps
% Ns = [200, 300, 400, 500];	%network size
% minK = [10, 20, 25, 30];	% # clusters
% maxK = [30, 40, 45, 50];
% mrateBase = [1, 0.8, 0.5, 0.25, 0.1, 0.05, 0.01]; %	P
% RateBase = [0.8, 0.6, 0.3, 0.15, 0.05, 0.005, 0.001]; %
% rateMinPower = [1];
% rateMaxPower = rateMinPower;
% repeat = 5;	
% PA.numNet = 1;
% PA.minClusSize = 10;
% PA.maxClusSize = 60;
% PA.minTseg = 4;
% PA.maxTseg = 10;

for t = 1:length(Ts)	% time 1 2 3
	T = Ts(t);
	PA.T = Ts(t);
	for n = 1:length(Ns)
		PA.netSize = Ns(n);
		for k = 1:length(minK)
			PA.minKClus = minK(k);
			PA.maxKClus = maxK(k);
			for p = 1:length(rateBase)
				PA.minRate = rateBase(p); PA.maxRate = mrateBase(p);
				for po = 1:length(rateMinPower)
					PA.minPow = rateMinPower(po); PA.maxPow = rateMaxPower(po);
					subDir = strcat('T',num2str(t),'N',num2str(n),'K', num2str(k),'Pr',num2str(p),'Pow',num2str(po),'/');
					mkdir(strcat(dirname,subDir));
					netClusterSet = genKSetOfNet(PA.numNet, PA.netSize, PA.minKClus, PA.maxKClus, PA.minClusSize, PA.maxClusSize, PA.T, PA.minTseg, PA.maxTseg, PA.minRate, PA.maxRate, PA.minPow, PA.maxPow);
					for nt = 1:PA.numNet
						for i=1:repeat
							[cellNet, ~, ecIDs]= dynamicNetGenerator(netClusterSet{nt}.clusters, netClusterSet{nt}.lifetimes);
							filename = strcat(dirname, subDir,'N',num2str(netClusterSet{nt}.N),'K',num2str(netClusterSet{nt}.K), 'T', num2str(PA.T), 'minRa', num2str(PA.minRate), 'maxRa', num2str(PA.maxRate), 'minPow', num2str(PA.minPow), 'maxPow', num2str(PA.maxPow),'_ver',num2str(nt),'_rep',num2str(i));
							save([filename,'.mat'],'PA','netClusterSet', 'cellNet', 'filename', 'ecIDs');
						end
					end
				end
			end
		end
	end
end


