% gets posterior for model 2 
% useful for simulations

% this is a hack for the Frank 2009 multimodal condition

% corrected via Florent Meyniel 2/18/14

function [p ll] = computeNoisyPosteriorMultimodal(hs,train,params,index_cache,cond)

  if strcmp(cond,'multi') % multimodal
    N_s = length(hs.all_strings)^2; 
  else % unimodal
    N_s = length(hs.all_strings);    
  end
  
  N_r = length(hs.hs);
  log_alpha = log(params.alpha);
  log_notalpha = log(1-params.alpha);
    
  % now compute the posterior on these data
  for i = 1:length(train)
    % first noise up the training data
    % flip an alpha-weighted coin and change on symbol of the sentence if it 
    % comes up 1-alpha.
    if rand > params.alpha
      train{i} = hs.all_strings{Randi(length(hs.all_strings))};
      index_cache.train(i) = find(cellfun(@(x) all(train{i} == x),hs.all_strings));
    end  
    
    for r = 1:N_r
      if hs.true_of(r,index_cache.train(i)) 
        ll(r,i) = logsumexp([log_alpha + hs.log_probs(r); ...
          log_notalpha + log(hs.cardinalities(r)/N_s) + hs.log_probs(r)]);
      else        
        ll(r,i) = log_notalpha + log(1 / (N_s));
      end        
    end    
  end
  
  p = sum(ll,2) + log(1/N_r);
  
  % normalize rule posterior
  p = p - logsumexp(p);
end
