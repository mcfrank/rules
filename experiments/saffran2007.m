% RULES MODEL 2
% Saffran et al. (2007) simulations

clear all
addpath('../helper')

% parameters
params.expt = 'marcus1999'; 
params.lang = 'ABB';
params.n_subs = 50;

alphas = .05:.05:.95;

% initialization
name = ['../mats/' params.expt '.mat'];
[hs train correct incorrect] = setupWorld(params);
load(name);

%%
% inference with noisy subjects
for a = 1:length(alphas)
  tic
  params.alpha = alphas(a);  
  index_cache = cacheItems(train,correct,incorrect,hs); 


  for i = 1:params.n_subs
    ps = computeNoisyPosterior(hs,train,params,index_cache);
    resps = computeTest(hs,ps,correct,incorrect,params,index_cache);
    resps = resps - logsumexp(resps');
      
    % luce choice rule
    p_success(a,i) = exp(resps(1)) / sum(exp(resps));     
      
    % surprisal
    surprisal(a,i) = diff(-resps);
  end
  
  toc
end

save ../mats/saffran2007.mat p_success surprisal

%% plot
load ../mats/saffran2007.mat

figure(1)
clf
set(gca,'FontSize',12)
xs = repmat(alphas',1,params.n_subs);
plot(xs+rand(size(xs))*.01,surprisal,'ko','MarkerSize',4)
b = regress(reshape(surprisal,[numel(surprisal) 1]),...
  [ones(size(reshape(surprisal,[numel(surprisal) 1])))  reshape(xs,[numel(surprisal) 1])]);
line([min(xs) max(xs)],[b(1) + min(xs)*b(2) b(1) + max(xs)*b(2)],'Color',[0 0 0])
xlabel('\alpha (noise parameter) value')
ylabel('difference in surprisal (bits)')

[r p] = corr(reshape(xs,[numel(xs) 1]),reshape(surprisal,[numel(xs) 1]));
set(gca,'FontSize',12);
set(gca,'Box','off')