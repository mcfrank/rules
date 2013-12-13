% RULES MODEL 2
% gerken (2006) and gerken (2010) simulations

clear all
addpath('../helper')

% parameters
expts = {'gerken2006','gerken2006','gerken2006','gerken2010','gerken2010'};
langs = {'AAB','AAx','AAx2','col+5','music+5'};
params.n_subs = 100;

% initialization
alphas = 0:.05:1;
alpha_decrease = .3; % the amount you cut down alpha for the +5
p_success = nan([length(alphas) 5 params.n_subs]);

%% simulations

for l = 1:length(langs) 
  disp(['*** lang = ' langs{l} ' ***'])  
  
  params.expt = expts{l};
  params.lang = langs{l}; 
  name = ['../mats/' params.expt '.mat'];
  [hs train correct incorrect] = setupWorld(params);
  load(name);
  index_cache = cacheItems(train,correct,incorrect,hs); 

  for a = 1:length(alphas)      
    params.alpha = alphas(a);  

    tic            
    for i = 1:params.n_subs  
      if l > 3
        ps = computeNoisyPosteriorGerken2010(hs,train,params,index_cache,...
          alphas(a) - alpha_decrease);
      else
        ps = computeNoisyPosterior(hs,train,params,index_cache);
      end
      resps = computeTest(hs,ps,correct,incorrect,params,index_cache);
      surprisal(a,l,i) = diff(-( resps - logsumexp(resps')));
    end        
    toc
  end
end

save gerken2006_2010.mat surprisal

%% plot
load mats/gerken2006_2010.mat
aval = 17; % which value of alpha do we use?

figure(1)
clf
set(gcf,'Position',[440 358 1000 350])
set(gcf,'Color','none')

subplot(1,4,1:2)
set(gca,'Color','none')
hold on
set(gca,'FontSize',12)
mps = mean(surprisal,3);
err = stderr(surprisal,3);
r = 1:length(alphas)-1;
plot(alphas(r),mps(r,1),'k-o')
plot(alphas(r),mps(r,2),'k-s')
plot(alphas(r),mps(r,3),'k-d')
plot(alphas(r),mps(r,4),'k-^')
plot(alphas(r),mps(r,5),'k-v')

% fill the markers for the parameters we use
plot(alphas(aval),mps(aval,1),'ok','MarkerFaceColor',[0 0 0])
plot(alphas(aval),mps(aval,2),'sk','MarkerFaceColor',[0 0 0])
plot(alphas(aval),mps(aval,3),'dk','MarkerFaceColor',[0 0 0])
plot(alphas(aval),mps(aval,4),'^k','MarkerFaceColor',[0 0 0])
plot(alphas(aval),mps(aval,5),'vk','MarkerFaceColor',[0 0 0])


alphas = round(alphas*100)/100;
axis([0 1 floor(min(min(mps))) ceil(max(max(mps)))])
xlabel('\alpha (noise parameter) value')
ylabel('difference in surprisal (bits)')
title('Model 2: \alpha varied')
set(gca,'YTick',0:5:15)
set(gca,'XTick',0:.2:1)
axis([0 1.2 0 15])

labels = {'AAB','AAx','AAx2','column+5','music+5'};

for i = 1:5
  text(1,mps(end-1,i),labels{i},'FontSize',12);
end

subplot(1,4,3)
cla
set(gca,'Color','none')
set(gca,'FontSize',12)
hold on
bar(mps(aval,:),'FaceColor',[.5 .5 .5])
errorbar(1:5,mps(aval,:),err(aval,:),'k.','MarkerSize',.1);
ylabel('difference in surprisal (bits)')
set(gca,'XTick',1:5,'XTickLabel',{'AAB','AAx','AAx2','col+5','mus+5'})
th = rotateticklabel(gca);
set(th,'FontSize',12)
title(['Model 2: \alpha = ' num2str(alphas(aval)) ... 
  ', \alpha_{+5} = ' num2str(alphas(aval)-alpha_decrease)]);
set(gca,'Box','off')
m = max(mps(aval,:));
axis([0 6 0 round(m*1.1)])

subplot(1,4,4)
set(gca,'Color','none')
set(gca,'FontSize',12)
lt_diffs = [3.37 0.56 3.08 (10.7 - 8.5) (16.4 - 14.3)];
bar(lt_diffs,'FaceColor',[.5 .5 .5]);
ylabel('difference in looking time (s)')
set(gca,'XTick',1:5,'XTickLabel',{'AAB','AAx','AAx2','col+5','mus+5'})
th = rotateticklabel(gca);
set(th,'FontSize',12)
title('Experimental data')
set(gca,'Box','off')
axis([0 6 0 4])
