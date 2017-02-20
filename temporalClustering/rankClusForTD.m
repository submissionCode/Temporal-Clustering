function clusRank = rankClusForTD(mode1, mode2,mode3, lambdas, clusResult,varargin)
	cNum = 0;
	R = size(mode1, 2);
	if(R ~= length(clusResult))
		'cluster component not match Rank'
	end
	for i = 1:R
		cNum = cNum + clusResult{i}.OptimalK;
	end
	clusRank.clusters = {};
	clusRank.clusters{cNum} = [];
	tmpClus = {};
	tmpClus{cNum} = [];
	cIdx = zeros([1 cNum]);
	cscore = zeros([1 cNum]);
	tmpIdx = 1;
	for i = 1:R
		for j = 1:clusResult{i}.OptimalK;
			cIdx(tmpIdx) = i;
			tmpClus{tmpIdx} = find(clusResult{i}.idx == j);
			len = length(tmpClus{tmpIdx});
			%cscore(tmpIdx) = lambdas(i) * sum(sum((mode1(tmpClus{tmpIdx},i)*mode2(tmpClus{tmpIdx},i)')))* sum(mode3(:,i)) / len / len;
			posTime = find(mode3(:,i)>0);
			cscore(tmpIdx) = lambdas(i) * sum(sum((mode1(tmpClus{tmpIdx},i)*mode2(tmpClus{tmpIdx},	  i)')))* sum(mode3(posTime,i)) / len / len;
			%cscore(tmpIdx) = lambdas(i) * sum(sum((mode1(tmpClus{tmpIdx},i)*mode2(tmpClus{tmpIdx},i)')))* sum(mode3(posTime,i)) / len / len /length(posTime);
			tmpIdx = tmpIdx + 1;
		end	
	end
	[clusRank.score idx] = sort(cscore,'descend');
	clusRank.compID = cIdx(idx);
	for i = 1:cNum
		clusRank.clusters{i} = tmpClus{idx(i)};
	end
end
