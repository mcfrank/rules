% gets posterior for model 2 
% useful for simulations

% this is a hack for the Gerken 2010 +5 conditions where some sentences are
% not heard as many times as others; alpha2 is the higher noise parameter
% for the strings that are only heard once.

function [p ll] = computeNoisyPosteriorGerken2010(hs,train,params,index_cache,alpha2)

  N_s = length(hs.all_strings);
  N_r = length(hs.hs);
  log_alpha = log(params.alpha);
  log_notalpha = log(1-params.alpha);
    
  % now compute the posterior on these data
  for i = 1:length(train)
    % assign alpha depending on what condition/sentence it is    
    switch params.lang
      case 'col'
        effective_alpha = params.alpha;
      case 'col+5'
        if i > 4
          effective_alpha = alpha2;
        else
          effective_alpha = params.alpha;
        end
      case 'music+5'      
        effective_alpha = alpha2;
    end    

    % first noise up the training data
    % flip an alpha-weighted coin and change on symbol of the sentence if it 
    % comes up 1-alpha.
    if rand > effective_alpha
      train{i} = hs.all_strings{Randi(length(hs.all_strings))};
      index_cache.train(i) = find(cellfun(@(x) all(train{i} == x),hs.all_strings));
    end  
  
    for r = 1:N_r
      if hs.true_of(r,index_cache.train(i)) 
        ll(r,i) = logsumexp([log_alpha + hs.log_probs(r); ...
          log_notalpha + log(hs.cardinalities(r)/N_s) + hs.log_probs(r)]);
      else        
        ll(r,i) = log_notalpha + log(1 / (N_s - hs.cardinalities(r)));
      end        
    end    
  end
  
  p = sum(ll,2) + log(1/N_r);
  
  % normalize rule posterior
  p = p - logsumexp(p);
end
