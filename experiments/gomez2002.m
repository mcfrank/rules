% RULES MODEL 3
% simulations for gomez (2002), psych science
% score alternative hypotheses

clear all

params.expt = 'gomez2002'; 
params.lang = '2x';
params.alpha = 1;
params.gamma = 1; % hyperparameter for the chinese restaurant process

name = ['../mats/' params.expt '.mat'];
[~, train correct incorrect] = setupWorld(params);
load(name);

% initialization
conds = {'2x','6x','12x','24x'};
gammas = [1];
alphas = [0:.05:1];
num_subs = 100;

%% simulations 
clear one_post two_post

for cond = 1:length(conds)
  disp(conds{cond});
  params.lang = conds{cond};
  [~, original_train, ~, ~] = setupWorld(params);      
  original_index_cache = cacheItems(original_train,correct,incorrect,hs); 
  n = length(original_train);
  
  for a = 1:length(alphas)
    for g = 1:length(gammas)
      for i = 1:num_subs
        disp([num2str(a) '-' num2str(g) '-' num2str(i)]);
        params.alpha = alphas(a);
        params.gamma = gammas(g);
                
        [train index_cache] = addNoiseToTraining(hs,original_train,params,original_index_cache);

        c = repmat([1 2],[1 n/2]);
        two_post(cond,a,g,i) = computeNoisyLikelihood2(hs,c,train,params,index_cache) + ...
          computeCRP(c,params);

        c = ones(1,n);
        one_post(cond,a,g,i) = computeNoisyLikelihood2(hs,c,train,params,index_cache) + ...
          computeCRP(c,params);
        
      end
    end
  end
end

save ../mats/gomez2002.mat

%% plot 

load ../mats/gomez2002.mat

gamma = 1;
ones = mean(one_post,4);
twos = mean(two_post,4);
odds = twos-ones;
two_probs = exp(two_post(:,:,gamma,:))./(exp(one_post(:,:,gamma,:))+exp(two_post(:,:,gamma,:)));
one_probs = exp(one_post(:,:,gamma,:))./(exp(one_post(:,:,gamma,:))+exp(two_post(:,:,gamma,:)));

% luce choice rule
choice_probs = (one_probs .* .5) + two_probs;
mcps = mean(choice_probs,4);

figure(1)
set(gcf,'Position',[440 358 1000 350])
clf

% left half
subplot(1,4,1:2)
set(gca,'Fontsize',12)
title('model 3, \alpha varied, \gamma = 1')
h = plot([2 6 12 24],mcps(:,:),'k--o');
axis([-1 25 .4 1])
xlabel('number of X elements')
set(gca,'XTick',[2 6 12 24])
ylabel('choice probability')

for i = 1:11
  text(-0.5,mcps(1,i),num2str(alphas(i),'%2.2f'));
end
title('model 3: \alpha varied, \gamma = 1')
set(gca,'Box','off')

% middle
subplot(1,4,3)
hold on
set(gca,'Fontsize',12)

bar(mean(choice_probs(:,5,:,:),4),'FaceColor',[.5 .5 .5])
title('model 3: \alpha = .4, \gamma = 1')
axis([0 5 .4 1])
set(gca,'XTickLabel',[2 6 12 24],'XTick',[1 2 3 4])


% right side
trained = [88 87 77 100];
untrained = [68 54 47 20];
gomez = mean([trained; 100-untrained]) ./ 100;
sems = [11 12 14 11] ./ 100;

subplot(1,4,4)
hold on
set(gca,'Fontsize',12)
bar(gomez,'FaceColor',[.5 .5 .5])
errorbar(1:4,gomez,sems,'.k','MarkerSize',.1)
axis([0 5 .4 1])
set(gca,'XTickLabel',[2 6 12 24],'XTick',[1 2 3 4])
title('experimental data')
