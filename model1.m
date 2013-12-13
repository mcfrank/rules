% MODEL 1
% instantiates the simple rules model of Frank & Tenenbaum
% all examples remembered exaxctly, only one rule
% begun 1/4/10
% submitted 4/7/10
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
else
  hs = createHypothesisSpace(hs);
  hs = cacheCardinalities(hs);
  hs = cacheTest(hs);
  save(name,'hs');
end

% make a quick exception for the multimodal condition of frank 2009
% (this fix is the same as computing probabilities when the dimensionality
% is squared)
if strcmp(params.lang,'multi') 
  hs.log_probs = hs.log_probs*2;      
  hs.cardinalities = hs.cardinalities.^2;
end

%% exact posterior inference 

ps = computePosteriorFromTrainingData(hs,train);
writeResults