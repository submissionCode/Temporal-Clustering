% evaluate results
% run demo.m b
addpath('./evaluation');
disp('run demo.m before runnning this script');
pause
distMtr = getDistMtrForClusAndCommu( rankedClus, commuList, Fac );	%TODO check rankedClus
mapping = mapCommunity2( distMtr, rankedClus.compID);
% cluster recall
clusterRecall = 1.0*length(unique(mapping));
if length(find(mapping==-1))>0
	clusterRecall = clusterRecall -1;
end
clusterRecall = clusterRecall / length(commuList);
% PR curve and member recall
[prec, memRecall] = temporalClusterPRCurve(mapping, rankedClus,commuList);

% lifetime detections
if isempty(find(mapping~=-1))
	lifeAcc=0; lifePrec=0; lifeRecall = 0;
	timeInfo =[]; lifetimeSet = [];
else
	timeInfo = getLifeTime(density*1.0/prod(size(cellNet{1})), Fac.u{3}(:, rankedClus.compID(find(mapping~=-1))), l1ftlambda, 'granularity', Gs(g));
	lifetimeSet = cellfun(@reduceGranularity, timeInfo.lifetime, repmat({Gs(g)},size(timeInfo.lifetime)), repmat({length(density)}, size(timeInfo.lifetime)),'UniformOutput',false);
	[lifeAcc, lifePrec, lifeRecall] = accLifetime(mapping(find(mapping~=-1)), lifetimeSet, netClusterSet{1}.lifetimes);
end