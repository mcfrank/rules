% MODEL 2
% instantiates the simple rules model of Frank & Tenenbaum
% one rule plus memory noise (via alpha parameter)
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
params.expt = 'gerken2006'; 
params.lang = 'ABx'; 

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

%% inference with memory noise

display('*** Evaluating noisy model ***');
params.n_subs = 16; % how many independent runs
params.alpha = .7;  % noise parameter

% make cache of corrupted items
index_cache = cacheItems(train,correct,incorrect,hs); 

for i = 1:params.n_subs
  all_ps(i,:) = computeNoisyPosterior(hs,train,params,index_cache);
  resps(i,:) = computeTest(hs,all_ps(i,:),correct,incorrect,params,index_cache);
  resps(i,:) = resps(i,:) - logsumexp(resps(i,:)');
  p_success(i) = exp(resps(i,1)) / sum(exp(resps(i,:)));
  surprisal(i) = diff(-resps(i,:));
end
writeResultsNoisy