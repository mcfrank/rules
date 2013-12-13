% RULES MODEL 2
% Marcus, Johnson, & Fernandes (2007) simulations

clear all
addpath('..')

% parameters
params.expt = 'marcus1999';
params.lang = 'ABB';
params.n_subs = 100;

% initialization
name = ['../mats/' params.expt '.mat'];
[hs train correct incorrect] = setupWorld(params);
load(name);
index_cache = cacheItems(train,correct,incorrect,hs); 

alphas = 0:.1:1;
p_success = nan([length(alphas)-1 length(alphas)-1 4 params.n_subs]);

for a1 = 2:length(alphas)
  % inference with noisy subjects
  for a2 = 1:a1-1 % a2 is always less than a1
    disp(['*** a1 = ' num2str(alphas(a1)) ' a2 = ' num2str(alphas(a2)) ' ***'])  
    tic        
    
    for i = 1:params.n_subs
      % normal marcus 1999
      params.alpha = alphas(a1);  
      ps = computeNoisyPosterior(hs,train,params,index_cache);
      resps = computeTest(hs,ps,correct,incorrect,params,index_cache);
      resps = resps - logsumexp(resps');
      p_success(a1-1,a2,1,i) = exp(resps(1)) / sum(exp(resps));
      surprisal(a1-1,a2,1,i) = diff(-resps);
            
      % a1 for training, a2 for test
      params.alpha = alphas(a1);
      ps = computeNoisyPosterior(hs,train,params,index_cache);
      params.alpha = alphas(a2);
      resps = computeTest(hs,ps,correct,incorrect,params,index_cache);
      resps = resps - logsumexp(resps');     
      p_success(a1-1,a2,2,i) = exp(resps(1)) / sum(exp(resps));
      surprisal(a1-1,a2,2,i) = diff(-resps);
            
      % a2 for training and test
      params.alpha = alphas(a2);
      ps = computeNoisyPosterior(hs,train,params,index_cache);
      resps = computeTest(hs,ps,correct,incorrect,params,index_cache);
      resps = resps - logsumexp(resps');
      p_success(a1-1,a2,3,i) = exp(resps(1)) / sum(exp(resps));
      surprisal(a1-1,a2,3,i) = diff(-resps);
    end    

    toc
  end
end

save ../mats/marcus2007.mat p_success surprisal

%% composite figure
load ../mats/marcus2007.mat
mps = mean(surprisal,4);
mpe = stderr(surprisal,4);

sns_diff = mps(:,:,2) - mps(:,:,3);
sns_diff(sns_diff == 0) = NaN;

close all
figure(1)
clf
set(gcf,'Position',[440 358 1000 350])
% set(gcf,'Color','none')

subplot(1,4,1:2)
set(gca,'FontSize',12)
plot(sns_diff,'ko--');
xlabel('\alpha_S')
ylabel('difference in surprisal (bits)')
title('Model 2: \alpha_S and \alpha_{NS} varied')
set(gca,'XTickLabel',alphas(1:2:end))
axis([0 11 0 20])
set(gca,'Box','off')

for i = [1 2 3 4 5 6 7 8]
  text(10.3,sns_diff(10,i),num2str(alphas(i),'%2.1f'));
end

hold on
plot(9,sns_diff(9,3),'ok','MarkerFaceColor',[0 0 0]);
  

subplot(1,4,3)
set(gca,'FontSize',12)
bar(squeeze(mps(9,3,:)),'FaceColor',[.5 .5 .5])
axis([0 4 0 25])
ylabel('difference in surprisal (bits)')
title('Model 2: \alpha_S = .9, \alpha_{NS} = .2')
set(gca,'Box','off')
set(gca,'XTickLabel',{'S-S','S-NS','NS-NS'})
rotateticklabel(gca,90);

subplot(1,4,4)
set(gca,'FontSize',12)
data = [2.1 1.6 .2];
bar(data,'FaceColor',[.5 .5 .5])
title('Experimental data')
ylabel('difference in looking times (s)')
set(gca,'Box','off')
set(gca,'XTickLabel',{'S-S','S-NS','NS-NS'})
rotateticklabel(gca,90);


% rotate_xlabel(90,{'S-S','S-NS','NS-NS'})


%% basic figure

load ../mats/marcus2007.mat
mps = mean(surprisal,4);
mpe = stderr(surprisal,4);

% t-tests to mark frames
n = 9;
for i = 1:n
  for j = 1:n
    for k = 1:2
      t(i,j,k) = ttest2(surprisal(i,j,k,:),surprisal(i,j,k+1,:));            
    end
  end
end

% now make the composite plot
n = 9;
figure(1)
clf
for i = 1:n
  for j = 1:n
    subplot(n,n,((i-1)*n)+j)
    set(gca,'FontSize',8)
    data = squeeze(mps(i,j,:));
    err = squeeze(mpe(i,j,:));
    
    if ~any(isnan((data))) && any(data>0)
      hold on      
      bar(data,'FaceColor',[.5 .5 .5]);
      axis([.25 3.75 0 max(data)*1.3])     
      set(gca,'XTick',[],'YTick',[])
          
      if t(i,j,2)
        text(1.9,(max(data)*1.1),'*','FontSize',12)
      end

      if j == 1
        text(-5,(max(data)*1.3)/2,['\alpha_S = ' num2str(alphas(i)+.1)]);
      end
      
      if i == n
        text(0,-(max(data)*1.7)/2,['\alpha_{NS} = ' num2str(alphas(j))]);
      end        
      
    else
      axis off
    end
  end
end

%% make inset figure (which we use illustrator to paste in)

