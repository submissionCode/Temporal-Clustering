%%  clusters of periodic synchronized lifetime  
%% dataset2: generate dynamic networks contains minK~maxK randomly generated clusters. In  this dataset, each cluster has the edge-generating rate within [minBase, maxBase], size within [PA.minClussize, PA.maxClusSize], lifetime segments are randomly generated.
% output to file
%	netClusterSet (cell array of dynamic networks): netClusterSet{nt} is a dynamic network
%		netClusterSet{nt}.clusters (cell array of interger arrays): netClusterSet{nt}.clusters{k} stores the node ID for the k-th ground truth cluster.
%		netClusterSet{nt}.lifetimes (cell array of double arrays): netClusterSet{nt}.lifetimes{k} stores the edge-generating rate from t=1,...,T. If the rate=0 at time step t, the cluster does not appear at that time step.
%		cellNet (cell array of network snapshot): for Evolutionary Clustering program to run
%		ecIds (cell array of node ID at snapshots): for Evolutionary clustering program to run.
clear all;
dirname = './synperiodicMat/';
mkdir(dirname);
Ts = [3000];	%time steps
Ns = [400];	%network size
minK = [15];	% # clusters
maxK = [30];
minAliveRate = [0.3];
maxAliveRate = [0.7];
minBase = [0.1]; %	P
maxBase = [0.5];
rateMinPower = [1];
rateMaxPower = [4];
repeat = 5;

% Ts = [1000, 2000, 3000, 4000];	%time steps
% Ns = [200, 300, 400, 500];	%network size
% minK = [10, 20, 25, 30];	% # clusters
% maxK = [30, 40, 45, 50];
% minAliveRate = [0.1, 0.2, 0.5, 0.7];
% maxAliveRate = [0.4, 0.5, 0.8, 0.9];
% maxBase = [1, 0.8, 0.5, 0.25, 0.1, 0.05, 0.01]; %	P
% minBase = [0.8, 0.6, 0.3, 0.15, 0.05, 0.005, 0.001]; %
% rateMinPower = [1];
% rateMaxPower = rateMinPower;
% repeat = 5;	
% PA.numNet = 1;
% PA.minClusSize = 10;
% PA.maxClusSize = 60;
% PA.minTseg = 4;
% PA.maxTseg = 10;

PA.numNet = 1;
PA.netSize = 250;
PA.minKClus = 8;
PA.maxKClus = 20;
PA.minClusSize = 10;
PA.maxClusSize = 60;
PA.T = 1000;
PA.minTseg = 4;
PA.maxTseg = 10;
PA.minRate = 0.8;
PA.maxRate = 0.8;
PA.minPow = 1;
PA.maxPow = 1;
PA.minAliveRate = 0.1;
PA.maxAliveRate = 0.4;
for t = 1:length(Ts)	% time 1 2 3
	PA.T = Ts(t);
	for n = 1:length(Ns)
		PA.netSize = Ns(n);
		for k = 1:length(minK)
			PA.minKClus = minK(k);
			PA.maxKClus = maxK(k);
			for p = 1:length(minBase)
				PA.minRate = minBase(p); PA.maxRate = maxBase(p);
				for po = 1:length(rateMinPower)
					PA.minPow = rateMinPower(po);
					PA.maxPow = rateMaxPower(po);
					for pl = 1:length(minAliveRate)
						PA.minAliveRate = minAliveRate(pl);
						PA.maxAliveRate = maxAliveRate(pl);
						%% all clusters have the same periodicity, but not the same edge-generating rates
						netClusterSet = genKSetClusWSynPeriodLife(PA.numNet, PA.netSize, PA.minKClus, PA.maxKClus, PA.minClusSize, PA.maxClusSize, PA.T, PA.minTseg, PA.maxTseg, PA.minRate, PA.maxRate, PA.minPow, PA.maxPow, PA.minAliveRate, PA.maxAliveRate);
						subDir = strcat('T',num2str(t),'N',num2str(n),'K', num2str(k),'Pr',num2str(p),'Pow',num2str(po), 'Perid',num2str(pl), '/');
						mkdir(strcat(dirname,subDir));
						for i=1:repeat
							[cellNet, density, ecIDs]= dynamicNetGenerator(netClusterSet{1}.clusters, netClusterSet{1}.lifetimes, 'noise', 0.0001);
							filename = strcat(dirname, subDir,'N',num2str(netClusterSet{1}.N),'K',num2str(netClusterSet{1}.K), 'T', num2str(PA.T), 'minRa', num2str(PA.minRate), 'maxRa', num2str(PA.maxRate), 'minPow', num2str(PA.minPow), 'maxPow', num2str(PA.maxPow), 'minPeriodLen', num2str(PA.minAliveRate), 'maxPeriodLen', num2str(PA.maxAliveRate), '_',num2str(i),'dens',num2str(meanDensity,2));
							save([filename,'.mat'],'PA','netClusterSet', 'cellNet', 'filename', 'ecIDs','-v7.3');
						end
					end
				end
			end
		end
	end
end


