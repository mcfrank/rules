% MODEL E1
%
% possible experiments:
% - marcus1999: ABB, ABA
% - endress2007: ABB, LHM
% - frank2009: uni, multi
% - gerken2006: AAB, AAx, AAx2
% - gerken2010: col, col+5, music+5
% - gomez2002: 2x, 6x, 12x, 24x
% - kovacs2009 (no conditions)
% see manuscript for more details

clear all
addpath('helper')

% parameters
params.expt = 'endress2007'; 
params.lang = 'LMH'; 

%% initialization

name = ['mats/' params.expt '.mat'];
[hs train correct incorrect] = setupWorld(params);

% either generate or load the hypothesis space
if size(dir(name),1)>0
  load(name);
% else
%   hs = createHypothesisSpace(hs);
%   hs = cacheCardinalities(hs);
%   hs = cacheTest(hs);
%   save(name,'hs');
end

%% find all rules compatible with all strings

ll = zeros(length(hs.hs),length(train));

for i = 1:length(hs.hs)
  for j = 1:length(train)
    if applyRuleToString(hs.hs{i},train{j})
      ll(i,j) = 1;
    end        
  end
end

true_of_all = mean(ll,2)==1;

%% then find strings consistent with true_of_all

consistent_strings = zeros(size(hs.all_strings));

for i = 1:length(hs.all_strings)
  if all(hs.true_of(true_of_all,i))
    consistent_strings(i) = 1;
  end
end

%% write test results

writeResultsE1