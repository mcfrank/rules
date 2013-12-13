% RULES MODEL
% frank, slemmer, marcus, & johnson (2009) simulations
%
% result was that multimodal rule learning succeeded with 5mos while
% unimodal rule learning failed.

clear all
addpath('..')

% parameters
params.expt = 'frank2009';
langs = {'uni','multi'};
params.n_subs = 100;

% initialization
alphas = 0:.05:1;
p_success = nan([length(alphas) 3 params.n_subs]);

  
%% simulations 

for l = 1:length(langs) 
  disp(['*** lang = ' langs{l} ' ***'])  
  
  params.lang = langs{l}; 
  name = ['../mats/' params.expt '.mat'];
  [hs train correct incorrect] = setupWorld(params);
  load(name);
  index_cache = cacheItems(train,correct,incorrect,hs); 

  % square the hypothesis space if we're multimodal
  if strcmp(langs{l},'multi')   
    hs.log_probs = hs.log_probs*2;      
    hs.cardinalities = hs.cardinalities.^2;
  end

  % now iterate through the parameters
  for a = 1:length(alphas)      
    params.alpha = alphas(a);  

    tic            
    for i = 1:params.n_subs     
      
      ps = computeNoisyPosteriorMultimodal(hs,train,params,index_cache,langs{l});
      resps = computeTestMultimodal(hs,ps,correct,incorrect,params,index_cache,langs{l});
      
      resps = resps - logsumexp(resps');
      p_success(a,l,i) = exp(resps(1)) / sum(exp(resps));   
      surprisal(a,l,i) = diff(-resps);
    end    
    toc
  end
end

save frank2009.mat p_success surprisal

%% plot
load mats/frank2009.mat

figure(1)
clf
hold on
set(gca,'FontSize',12)
mps = mean(surprisal,3);
plot(alphas,mps(:,1),'k-')
plot(alphas,mps(:,2),'k--')

alphas = round(alphas*100)/100;
axis([0 1 floor(min(min(mps))) ceil(max(max(mps)))])
xlabel('\alpha (noise parameter) value')
ylabel('difference in surprisal (bits)')
legend({'unimodal rule','multimodal rule'},'Location','NorthWest')