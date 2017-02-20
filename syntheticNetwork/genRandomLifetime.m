function [life, lifeSegIdx, seg ] = genRandomLifetime(T, nSeg, baseRate, minPow, maxPow)
	life = zeros(1, T);
	seg = randperm(floor(T/5)-1);
	seg = sort(seg(1: (nSeg-1)))*5;
	if seg(end) ~=T
		seg(end+1) = T;
	end
	seg = [0, seg];
	numLife = randi([max(1, floor(nSeg/4)), floor(nSeg/4*3)],1,1);
	lifeSegIdx = randperm(nSeg); lifeSegIdx = sort(lifeSegIdx(1:numLife));
	for i = lifeSegIdx;
		life((seg(i)+1):seg(i+1)) = baseRate^(minPow+(maxPow-minPow)*rand(1));
	end
end