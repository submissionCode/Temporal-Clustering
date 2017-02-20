function [lifetime, periodType]= genPeriodicLifetime(T, K, seg, alivePercent, minBase, maxBase, minPow, maxPow)
	periodType = [];
	lifetime = zeros(1, T);
	periodType.type = 'periodic';
	periodType.seg = seg;
	periodType.periodLen = floor(T/seg);
	periodType.alive = ceil(periodType.periodLen * alivePercent);
	periodType.meanRate = 0;
	periodType.baseRates = zeros(1, seg);
	periodType.pow = zeros(1, seg);
	for i = 1:seg
		periodType.baseRates(i) = minBase + (maxBase-minBase)*rand();
		periodType.pow(i) = minPow+(maxPow-minPow)*rand();
		lifetime(((i-1)*periodType.periodLen+1):((i-1)*periodType.periodLen+periodType.alive)) = periodType.baseRates(i)^(periodType.pow(i));
	end


end