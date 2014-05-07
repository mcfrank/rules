% compute the likelihood p(d|h) 
% assuming the noisy likelihood (models 2 and 3)
% this is the fastest version yet
% corrected 2/18/14 via Florent Meyniel

function loglike = computeNoisyLikelihood2(hs,c,train,params,index_cache)

  % some constants
  N_s = length(hs.all_strings);
  N_r = length(hs.hs);
  log_alpha = log(params.alpha);
  log_notalpha = log(1-params.alpha);
  noise_vals = repmat(log_notalpha + log(1 ./ (N_s)),[N_r 1]);

  % now compute the likelihood of these data for each cluster
  for k = 1:max(c)
    this_train = train(c==k);
    cache_inds = find(c==k);

    % fill in likelihood of data if produced by noise from some rule    
    ll_rule_string{k} = repmat(noise_vals,[1 sum(c==k)]);

    % compute likelihood of the data under each other possible rule
    for i = 1:length(this_train)    
      poss_rules = find(hs.true_of(:,index_cache.train(cache_inds(i))));
      for r = 1:length(poss_rules);
        ll_rule_string{k}(poss_rules(r),i) = logsumexp([log_alpha + hs.log_probs(poss_rules(r)); ...
          log_notalpha + log(hs.cardinalities(poss_rules(r))/N_s) + hs.log_probs(poss_rules(r))]);
      end    
    end
        
    % now product over rules
    ll_rule{k} = sum(ll_rule_string{k},2) + log(1/N_r);
 
    % now sum for that cluster over all those that aren't -Inf
    ll_cluster(k) = logsumexp(ll_rule{k}(~isinf(ll_rule{k})));
  end
  
  % now product over clusters
  loglike = sum(ll_cluster);
end
