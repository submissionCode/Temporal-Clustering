function [ commuList ] = processCommuList( clIdx, ts, inProb, outProb, g, N )
% convert the parameters of ground truth communities to a format that can
% be used in mapping retrieved clusters.
% Input
%   - clIdx:    J*1 cells, clIdx{i} is community C*_j
%   - ts:       J*1 cells, ts{j} is C*_j's time series for the activity.
%   - inProb:   probability of generating an edge between nodes within community in unit
%   time.
%   - outProb:  probability of genreating an edge between nodes across
%   communities in unit time, note that if each community is viewed as a
%   generative model, the probability should be outProb/J on average.
%   - gran:     granularity of the time, ts{j} should be 
%   scaled to this.
%   - N:        interger, number of nodes in the network.
% OutPut
%   - commuList:    J*1 cells.
%       - commuList{j}.idx:  clIdx{j}
%       - commuList{j}.prob:    N*1 array, Probability
%       - commuList{j}.rates:   T/g * 1 array, edge-generating rate
%   Detailed explanation goes here
    % Initialized
    J = length(clIdx);
    commuList ={}; commuList{J} = {};
    T = length(ts{1});
    %obtain time window to format the time series;
    if mod(T, g)==0
        ii = linspace(0, T, T/g +1);
    else
        ii = zeros([ceil(T/g)+1 1]);
        ii(1:end-1) = linspace(0, floor(T/g)*g, ceil(T/g));
        % the last snapshot might not have a very good interval, remove it!
        ii(end) = T;
        % if ii(end) < ii(end-1)+ g/2
        %     ii(end) = [];
        %     ii(end) = T;
        % end
    end
    
    %generating community List with spectial format
    for j = 1:J
        commuList{j}.idx = clIdx{j};
        commuList{j}.prob = zeros(N,1); commuList{j}.prob(clIdx{j}) =1;
        commuList{j}.rates = zeros(length(ii)-1,1);
        for i = 1:(length(ii)-1)
            commuList{j}.rates(i) = sum(ts{j}((ii(i)+1):ii(i+1)))* inProb;
        end
        commuList{j}.rates = commuList{j}.rates + outProb/J;
    end
end

