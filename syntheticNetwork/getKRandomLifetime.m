function lives = getKRandomLifetime(T, K, minSeg, maxSeg, minBase, maxBase, minPow, maxPow)
	lives ={};
	lives{K} = {};
	for i = 1:K
		nSeg = randi([minSeg, maxSeg]); baseRate = minBase +(maxBase-minBase)*rand(1);
		lives{i} = genRandomLifetime(T, nSeg, baseRate, minPow, maxPow);
	end
end