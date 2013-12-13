function [ll h] = findMLHypotheses(c,train,hs,params,index_cache)

  N_s = length(hs.all_strings);
  N_r = length(hs.hs);
  log_alpha = log(params.alpha);
  log_notalpha = log(1-params.alpha);

   % now compute the likelihood of these data
  for k = 1:max(c)
    this_train = train(c==k);
    cache_inds = find(c==k);

    noise_vals = log_notalpha + log(1 ./ (N_s - hs.cardinalities));
    lls{k} = repmat(noise_vals,[1 sum(c==k)]);
    
    % now compute the posterior on these data
    for i = 1:length(this_train)    
      poss_rules = find(hs.true_of(:,index_cache.train(cache_inds(i))));
      for r = 1:length(poss_rules);
        lls{k}(poss_rules(r),i) = logsumexp([log_alpha + hs.log_probs(poss_rules(r)); ...
          log_notalpha + log(hs.cardinalities(poss_rules(r))/N_s) + hs.log_probs(poss_rules(r))]);
      end    
    end

    p = sum(lls{k},2) + log(1/N_r);
    non_0_ps = p(~isinf(p));
    ll = logsumexp(non_0_ps);
    
    h{k} = hs.hs{p==max(p)};
  end
end