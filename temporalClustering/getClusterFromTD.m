%% Cluster on each component from TD with silouette criterion
%	Input:
%		fac: object
%			fac.u:	cell, fac.u{r}, the r-th mode of a k-tensor
%	Output:
%		myClusters:	cell, myClusters{r} is an object, 
%							myClusters{r}.criterionValues: number, is the silouette score
%							myClusters{r}.OptimalK: number, number of clusters
%							myClusters{r}.idx:	array, indicator array for clusters.

function myClusters = getClusterFromTD(fac)
	numX = size(fac.u{1}, 2);
	myClusters = {};
	%X = zeros([size(fac.u{1},2), size(fac.u{2},2)]);
	for i = 1:numX
		% if nargin == 2
		% 	figName = '';
		% else
		% 	figName = strcat(figPre,'Comp',num2str(i));
		% end
		X = fac.u{1}(:,i) * fac.u{2}(:,i)';
		X = (X + X')/2;
		eva = evalclusters(X,'kmeans','silhouette','KList',[1:6]);
		myClusters{i}.CriterionValues = eva.CriterionValues;
		myClusters{i}.OptimalK = eva.OptimalK;
		myClusters{i}.idx = kmeans(X, eva.OptimalK);
	end
end