% MODEL 3
% instantiates the simple rules model of Frank & Tenenbaum
% multiple rules plus noise 
% begun 1/4/10
% submitted 4/7/10
%
% possible experiments:
% - marcus1999: ABB, ABA
% - endress2007: ABB, LHM
% - gerken2006: AAB, AAx, AAx2
% - gerken2010: col, col+5, music+5
% - gomez2002: 2x, 6x, 12x, 24x
% - kovacs2009 (no conditions)
% see manuscript for more details

clear all
addpath('helper')

%% parameters
params.expt = 'kovacs2009'; 
params.lang = 'ABB'; 
params.alpha = .9;     % memory noise parameter
params.gamma = .2;    % parameter for chinese restaurant process
params.num_iter = 100; % number of gibbs steps

%% initialization
name = ['mats/' params.expt '.mat'];
[hs train correct incorrect] = setupWorld(params);

if size(dir(name),1)>0
  load(name);
else
  hs = createHypothesisSpace(hs);
  hs = cacheCardinalities(hs);
  hs = cacheTest(hs);
  save(name,'hs');
end

% create a cache and then modify it for the noise for this particular
% simulation
index_cache = cacheItems(train,correct,incorrect,hs); 
[train index_cache] = addNoiseToTraining(hs,train,params,index_cache);

%% use gibbs sampler to find cluster assignment

% initialize with every sentence in its own cluster
n = length(train);
c = 1:n; 
c3 = zeros(n,params.num_iter);

% begin gibbs iterations
for i = 1:params.num_iter 
  fprintf('gibbs step %d',i);
  for j = 1:n 
    fprintf('.'); if mod(j,50)==0, fprintf('\n'); end;
    clear ll h2 c2 prior new_scores
    
    % try the assignment of this string to every cluster (inc. its own)
    for k = 1:max(c)+1
      c2{k} = c;
      c2{k}(j) = k;      
      ll(k) = computeNoisyLikelihood2(hs,c2{k},train,params,index_cache);
      prior(k) = computeCRP(c2{k},params);
      new_scores(k) = prior(k) + ll(k);
    end

    % now choose class & clean up if classes are empty
    % gibbs step: jump proportional to the relative probability   
    c(j) = chooseClass(new_scores);
    c = cleanUpClasses(c);
  end
  
  % now show what happened
  c3(:,i)=sort(c);
  imagesc(c3); drawnow; fprintf('\n');  
  displayOutputs;
end
