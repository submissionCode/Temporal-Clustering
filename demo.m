%% Before running this script, make sure the required tool box are installed and add to path in workspace.
close all; clear all;
addpath('./syntheticNetwork');
addpath('./temporalClustering');

disp('Make sure the required packages are installed, press any key to continue');
pause;
% generate a random dynamic network with clusters
demo_genDynNetRand;

ten = reshape(full(cell2mat(cellNet)), [netClusterSet{1}.N, netClusterSet{1}.N, length(netClusterSet{1}.lifetimes{1})]);
g = 1 % granularity
r = netClusterSet{1}.K; % decomposition rank for nonegative PARAFAC, set to the number of clusters in the network.
if g==1
	Y = tensor(ten);
else
	Y = tensor(changeMatrixGranularity(ten, g));
end

opts.maxit = 200;
opts.tol = 1e-8;
opts.modIdx = [1, 2]; %  constraint that the mode for the nodes should be equal if the dynamic network is undirected. 
Fac = ncp(Y,r,opts);	% run nonnegative PARAFAC without constraint.
% Fac = ncpMod(Y,r,opts);	modified version of ncp to deal with opts.modIdx.

Fac = normalizeComponents([1 2], Fac, 3);
% obtain a ranked list of clusters from the PARAFAC results.
rankedClus = rankClusForTD(Fac.u{1}, Fac.u{2}, Fac.u{3}, Fac.lambda, getClusterFromTD(Fac));

%%evaluation
% demo_evaluation 