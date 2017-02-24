function [ timeInfo ] = getLifeTime( globalThres, tsMtr, lambda, varargin )
% Given thresholds thres(t) at each time step for life time (the threshold
% are not smoothed), find the life time L = {t|ts_{smoothed}(t)>thres_{smoothed}(t)}
% Input
%   - globalThres:  T*1 array, the threshold to decide life time, need to
%   be smoothed with filtering technique
%   - tsMtr:        T*R matrxi, containing r time series, tsMtr(:,r) is a 
%   time series, need to be smoothed,
%   - lambda:       paramter for l_1 trend filtering
% Output
%   - timeInfo:     object, store the lifetimes of r time series, the
%   smoothed time series, and the smoothed thresholds.
%       - timeInfo.lifetime:  R*1 cells, lifetime{r} stores L for the r-th time
%       series.
%       - timeInfo.smTSMtr:  T*R matrix, smTSMtr(:,r) is the r-th smoothed time series
%       - timeInfo.smGT:     T*1 array, smoothed global thresholds.
%   Detailed explanation goes here

    %Initialization
    globalThres = globalThres(:);
    [T, R] = size(tsMtr);
    timeInfo = [];
    if T~= length(globalThres)
        if isempty(varargin)
            globalThres = changeGranularity(globalThres, floor(length(globalThres)/T));
        elseif length(varargin)>1 && strcmp(varargin{1}, 'granularity')
            globalThres = mergeTimeSteps(globalThres, varargin{2});
        end
        if T>length(globalThres)
            globalThres(end+1:T) = 0;
        else
            globalThres(T+1:end) =[];
        end
    end
    timeInfo.lifetime={}; timeInfo.lifetime{R} = [];
    timeInfo.smTSMtr = zeros(T, R);
    timeInfo.smGT = hp_filter(globalThres, 5);
    for r = 1:R
        timeInfo.smTSMtr(:,r) = l1tf(tsMtr(:,r), lambda);
        timeInfo.lifetime{r} = (timeInfo.smTSMtr(:,r)>timeInfo.smGT);
    end
    
end

