%% 
% generate 3 mode tensor with ground truth clusters and their edge-generating rate
%	Input:
%		clus: 1*K cell array, clus{i} is a set, storing the node id of a cluster i 
%		lives: 1*K cell array, lives{i} is a 1*T array, lives{i}(t) is the edge-generating rate at time t
%	Output:
%		tensor: 1*T cell array, tensor{t} stores a sparse matrix of network snapshot
function [tensor density ecIDs]= dynamicNetGenerator(clus, lives, varargin)
	T = length(lives{1});
	K = length(clus);
	tmpArray = [];
	for k=1:K
		tmpArray = union(tmpArray, clus{k});
	end
	N = length(tmpArray);
	if length(varargin)>1 && strcmp(varargin{1},'noise')
		tensor = genBinaTensorWNoise(N, N, T, varargin{2});
	else
		tensor{1} = sparse(zeros(N));
		tensor = tensor(repmat(1,1,T));
	end
	for k=1:K 		% change to cell operation later
		for t = find(lives{k}>0)
			Nk = length(clus{k});
			tmpArray = rand(Nk); tmpArray = (tmpArray + tmpArray')/2; tmpArray = (tmpArray  <= lives{k}(t));
			tmpM = sparse(zeros(N));
			tmpM(clus{k},clus{k}) = tmpArray;
			tensor{t}= tensor{t} + tmpM;
		end
	end
	density = zeros(1,T);
	ecIDs ={}; ecIDs{T} = {};
	for t = 1:T
		ecIDs{t} = find(sum(tensor{t})>0);
		density(t) = nnz(tensor{t});
	end
end

function noisyTensor = genBinaTensorWNoise(I, J, K, rate)
	i{1} = [I];  I = i(repmat(1,1,K));
	j{1} = [J];  J = j(repmat(1,1,K));
	r{1} = [rate]; rate = r(repmat(1,1,K));
	noisyTensor = cellfun(@getNoiseSnapshot, I, J, rate,'UniformOutput',false);
end

function snapshot = getNoiseSnapshot(I, J, rate)
    snapshot = sparse(double(rand(I,J)<rate));
    snapshot = (snapshot + snapshot')/2;
end