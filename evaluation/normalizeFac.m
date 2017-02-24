function [ result ] = normalizeFac( fac )
%NORMALIZEFAC Summary of this function goes here
%   Detailed explanation goes here
    [~, R] = size(fac.u{1}); 
    for r = 1:R
       maxVal = max(fac.u{1}(:,r));
       %minVal = min(fac.u{1}(:,r));
       fac.u{1}(:,r) = fac.u{1}(:,r)/maxVal;
       fac.lambda(r) = fac.lambda(r) * maxVal;
       maxVal = max(fac.u{2}(:,r));
       %minVal = min(fac.u{2}(:,r));
       fac.u{2}(:,r) = fac.u{2}(:,r)/maxVal;
       fac.lambda(r) = fac.lambda(r) * maxVal;
       fac.u{3}(:,r) = fac.u{3}(:,r) * fac.lambda(r);
       fac.lambda(r) = 1;
    end
    result = fac;
end

