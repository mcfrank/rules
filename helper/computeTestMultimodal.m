%% calculate correct and incorrect probability with noise
% probability of some string is
% sum over rule of p(string | rule) p(rule)

function resps = computeTestMultimodal(hs,p_rule,correct,incorrect,params,index_cache,cond)

% consolidate all the strings if train and test are different
if length(hs.test_vocab) == length(hs.train_vocab) && ...
    hs.train_vocab(1) == hs.test_vocab(1)
  all_strings = hs.all_strings;
  true_of = hs.true_of;
else
  all_strings = [hs.all_strings hs.all_test_strings];
  true_of = [hs.true_of hs.true_of_test];  
end

% some values for the likelihood
N_r = length(hs.hs);

if strcmp(cond,'multi') % multimodal
  N_s = length(hs.all_strings)^2; 
else % unimodal
  N_s = length(hs.all_strings);    
end
log_alpha = log(params.alpha);
log_notalpha = log(1 - params.alpha);

items = [correct incorrect]; % consolidate items for ease

% sum over all rules
item_p = nan(N_r,length(items));

for i = 1:length(items)  
  % then relative probability over rules
  for r = 1:N_r 
    % we don't use the noisy model for these simulations
    % clean version
    if true_of(r,index_cache.items(i)) 
      p_string_given_rule = hs.log_probs(r); 
    else
      p_string_given_rule = -Inf;
    end

    item_p(r,i) = p_string_given_rule + p_rule(r);
  end
end

% resplit items
resps = [logsumexp(sum(item_p(:,1:length(correct)),2)) ...
  logsumexp(sum(item_p(:,length(incorrect)+1:end),2))];
