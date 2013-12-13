% RULES MODEL 3
% simulations for kovacs & mehler (2009), science
% score alternative hypotheses

clear all

params.expt = 'kovacs2009'; 
params.lang = '';
params.alpha = 1;
load('../mats/kovacs2009.mat');

%%
gammas = [1e-1 1e-2 1e-3 1e-4 1e-5];
alphas = [.5:.05:1];
num_subs = 100;

[~, original_train, correct, incorrect] = setupWorld(params);      
original_index_cache = cacheItems(original_train,correct,incorrect,hs); 
n = length(original_train);
  
for a = 1:length(alphas)
  for g = 1:length(gammas)
    for gd = g+1:length(gammas)
      for i = 1:num_subs
        disp([num2str(a) '-' num2str(g) '-' num2str(gd) '-' num2str(i)]);
        [train index_cache] = addNoiseToTraining(hs,original_train,params,original_index_cache);

        % -- two rules --
        c = [1 1 1 1 1 1 2 2 2 2 2 2];
        % bilingual
        params.alpha = alphas(a);
        params.gamma = gammas(g);
        two_post(1,a,g,gd,i) = computeNoisyLikelihood2(hs,c,train,params,index_cache) + ...
          computeCRP(c,params);

        % monolingual
        params.alpha = alphas(a);
        params.gamma = gammas(gd);
        two_post(2,a,g,gd,i) = computeNoisyLikelihood2(hs,c,train,params,index_cache) + ...
          computeCRP(c,params);

        % -- one rule --
        c = [1 1 1 1 1 1 1 1 1 1 1 1];
        % bilingual
        params.alpha = alphas(a);
        params.gamma = gammas(g);
        one_post(1,a,g,gd,i) = computeNoisyLikelihood2(hs,c,train,params,index_cache) + ...
          computeCRP(c,params);

        % monolingual
        params.alpha = alphas(a);
        params.gamma = gammas(gd);
        one_post(2,a,g,gd,i) = computeNoisyLikelihood2(hs,c,train,params,index_cache) + ...
          computeCRP(c,params);
      end
    end
  end
end

save mats/kovacs2009.mat one_post two_post

%% plots 

load mats/kovacs2009.mat
one_prob = exp(one_post) ./ (exp(one_post) + exp(two_post));
two_prob = exp(two_post) ./ (exp(one_post) + exp(two_post));

% first_prob = one_prob + two_prob;
% second_prob = two_prob;

choice_prob = (one_prob .* .5) + two_prob;
diff_score = (choice_prob - .5) .* 2;
mds = mean(diff_score,5);


figure(1);
clf

% full parameter space
subplot(1,3,1:2)
hold on
set(gca,'FontSize',12)
for g = 1:length(gammas)
  for gd = g+1:length(gammas)
    y = mean(-diff(two_prob(:,:,g,gd,:)),5);
    plot(alphas,y,'--ok')
    
    text(1.05,y(end),[num2str(gammas(g),'%0.e') '/' num2str(gammas(gd),'%0.e')])
  end
end
axis([.5 1.2 0 1])
set(gca,'XTick',.5:.25:1)
xlabel('\alpha (noise parameter) value')
ylabel('difference in probability of two rules')
title('Model 3: \alpha, \gamma_B, \gamma_M varied')

a = 9;
g = 1;
gd = 3;
plot(alphas(a),mean(-diff(two_prob(:,a,g,gd,:)),5),'k.','MarkerSize',20)

% then just one part of it

subplot(1,3,3)
set(gca,'FontSize',12)
h = bar([mean(one_prob(:,a,g,gd,:),5)'; mean(two_prob(:,a,g,gd,:),5)']');
set(h(1),'FaceColor',[.25 .25 .25]);
set(h(2),'FaceColor',[.75 .75 .75]);
axis([.5 2.5 0 1])
set(gca,'XTickLabel',{'bilingual','monolingual'})
ylabel('relative probability')
title(['Model 3: \alpha = ' num2str(alphas(a)) ', \gamma_B = ' ...
  num2str(gammas(g)) ', \gamma_M = ' num2str(gammas(gd))])
legend(h,'one rule','two rules')
set(gca,'Box','off')
