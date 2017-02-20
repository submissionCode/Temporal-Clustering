function M = change3dMatrixGranularity(M, g)
	%% merage every g slides in the 3rd dimesion of a 3d matrix
	[I, J, K] = size(M);
	if mod(K, g)==0
		newK = K/g;
		M = reshape(M,[I, J, g, newK]);
		M = reshape(sum(M,3), [I, J, newK]);
	else
		newK = ceil(K/g);
		tmp = sum(M(:,:, ((newK-1)*g+1):end),3);
		M = reshape(sum(reshape(M(:,:,1:((newK-1)*g)), [I, J, g, newK-1]),3), [I, J, newK-1] );
		M(:,:,end+1) = tmp;
	end
end