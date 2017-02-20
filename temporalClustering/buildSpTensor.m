%% preprocess raw data and build a sparse tensor with sptensor function

rawdata = textread(strcat(inDir,inFile));
%[a row in rawdata]: 1 0 20 0.3232; where 1 is time in second, 0 and 20
%are the source and target node, 0.3232 is the distance
if exist('totalTime') == 0
	totalTime = length(rawdata(:,1));
end
rawdata = rawdata(:,1:3);
rawdata = rawdata(1:totalTime,:);
%adjust time interval to integer
if exist('timeUnit') 
	rawdata(:,1) = (rawdata(:,1) / timeUnit);
end
rawdata = rawdata - repmat(min(rawdata), [length(rawdata(:,1)) 1]) + 1;
if exist('apInfo') && exist(apInfo, 'file') && exist('rmCol') && exist('rmPer')
	%TODO: remove some AP
	apStat = csvread(apInfo);
	tbl = tabulate(apStat(:,rmCol));
	cumPer = cumsum(tbl(:,3));
	rmIdx = find(cumPer <= rmPer);
	rmIdx = find(apStat(:,rmCol) <= rmIdx(end));
	rawdata(rmIdx,:) = [];
else
	'full row/column will be used'
end

rawdata = round(rawdata);
%change rawdata into sptensor, first 3 column should change to integer for
%the indices, the last column is the value of the entry
%use sptensor to create tensors from matrix
if exist('accuRow') && accuRow == true
	rawdata = rawdata(:,[2,3,1]);
	[uniRow b c] = unique(rawdata, 'rows');
	c = accumarray(c, 1);
	X = sptensor(uniRow, c);
else
	X = sptensor(rawdata(:,[2,3,1]),1); 
end
%sptensor(subscriptMtr, valueVector), you can use 1-rawdata(:4) to replace
%the valueVector 1 for another way of evaluate the connection between nodes
%in a time step.
clear rawdata uniRow accuRow b c totalTime rmIdx rmCol cumPer tbl apStat apInfo timeIvtforRaw;
%save workspace as a mat file containing only the matrix X
save(strcat(outDir,'/','tensor',tensorFile),'X','-v7.3');
%[in another script]use sptensor to conver full tensor to sparse tensor

%[in another script]use main to get result

