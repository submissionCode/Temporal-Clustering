function [lifetime lenType] = genLifetimeWLen(T, K, seg, minRate, maxRate, minPow, maxPow, distr, distrMean)
	lenType = [];
	lifetime = zeros(1, T);
	lenType.typeID = distr;
	if distr == 1	% uniform
		lenType.distPara = min(3*T/4, 2*distrMean);
		len = randi([1, lenType.distPara]);	
		lenType.typeName ='uniform'	;
	elseif distr == 2	%geometric
		lenType.distPara = 1.0/distrMean;
		len = min(T/4*3, geornd(lenType.distPara) );
		lenType.typeName ='geometric'	;
	else
		% alpha = 2 => k=1/2; xm = sig/k => sig = xm/alpha, theta = sig/k
		alpha = 2.0; xm = (alpha-1)*distrMean/alpha;
		lenType.distPara=[alpha, xm];
		len = min(T/4*3,gprnd(1/alpha, xm/alpha, xm))	;
		lenType.typeName ='pareto'	;
	end
	

	len = max(seg*10, floor(len));
	lenType.len = len;
	idx = randperm(floor((len)/10-1)); idx = [0, (sort(idx(1:(seg-1)))*10), len];
	inserIdx = 1;
	lenType.baseRates = zeros(1, seg);
	lenType.pow = zeros(1,seg);
	for i = 1:(length(idx)-1);
		inserIdx = randi([inserIdx, T - idx(end)+idx(i)]);
		lenType.baseRates(i) = minRate + (maxRate-minRate)*rand(1);
		lenType.pow(i) = minPow+(maxPow-minPow)*rand(1);
		lifetime(inserIdx: (inserIdx+ idx(i+1)-idx(i)-1)) = lenType.baseRates(i)^(lenType.pow(i));
		inserIdx = (inserIdx+ idx(i+1)-idx(i));
	end
end