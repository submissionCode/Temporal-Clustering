function [ M ] = changeGranularity( tsMtr, g )
% given a time series a smallest granularity, change the granularity
% accroding to the time window to merge time step.
%   a T*1 time series will become a ceil(T/g) *1 time series.
% Input
%   - tsMtr:    T*r matrix, tsMtr(:,r) represent the r-th time series.
%   - g:        integer, window size of merging time steps.
% Output
%   - M:        ceil(T/wsize)* r matrix, M(:,r) is the r-th precess time
%   series.
%   Detailed explanation goes here
    %initialization
    [T R] = size(tsMtr);
    if mod(T, g)==0
        ii = linspace(0, T, T/g +1);
    else
        ii = zeros([ceil(T/g)+1 1]);
        ii(1:end-1) = linspace(0, floor(T/g)*g, ceil(T/g));
        ii(end) = T;
        if ii(end) < ii(end-1)+ g/2
            ii(end) = [];
            ii(end) = T;
        end
    end
    
    % merge time steps within a time window with size g
    M = zeros(length(ii)-1, R);
    for j = 1:R
        for i = 1:(length(ii)-1)
            M(i,j) = sum(tsMtr((ii(i)+1):ii(i+1),j));
        end
    end

end

