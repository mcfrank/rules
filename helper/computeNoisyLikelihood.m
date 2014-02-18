% compute the likelihood p(d|h) 
% assuming the noisy likelihood (models 2 and 3)
% this version is slower than computeNoisyLikelihood2

function loglike = computeNoisyLikelihood(hs,c,train,params,index_cache)

  N_s = length(hs.all_strings);
  N_r = length(hs.hs);
  log_alpha = log(params.alpha);
  log_notalpha = log(1-params.alpha);
    
  % now compute the likelihood of these data
  for k = 1:max(c)
    this_train = train(c==k);
    cache_inds = find(c==k);

    ll_rule_string{k} = 0;
    
    % now compute the posterior on these data
    for i = 1:length(this_train)    
      for r = 1:N_r
        if hs.true_of(r,index_cache.train(cache_inds(i))) 
          ll_rule_string{k}(r,i) = logsumexp([log_alpha + hs.log_probs(r); ...
            log_notalpha + log(hs.cardinalities(r)/N_s) + hs.log_probs(r)]);
        else        
          ll_rule_string{k}(r,i) = log_notalpha + log(1 / (N_s));
        end        
      end    
    end

    ll_rule{k} = sum(ll_rule_string{k},2) + log(1/N_r);
 
    % take the sum over all those that aren't -Inf
    ll_cluster(k) = logsumexp(ll_rule{k}(~isinf(ll_rule{k})));
  end
 
  loglike = sum(ll_cluster);
end
