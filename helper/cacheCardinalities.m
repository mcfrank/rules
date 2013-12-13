% cache the cardinality (size) of each rule, so that you can look up the
% likelihood rather than having to compute it on the fly. this is the
% fundamental caching step that makes the models quick to compute. we only
% do this once for each model and then save it as a .MAT file for future
% access.

function hs = cacheCardinalities(hs)

  disp('caching cardinalities for a new experiment.')
  disp('warning: if you are running this for an experiment with a large vocabulary,')
  disp('e.g. Gomez (2002), this could take a *very* long time (on the order of several days)');
  disp('')
  
  % get all strings in train vocab
  c = 1;
  for i = hs.train_vocab
    for j = hs.train_vocab
      for k = hs.train_vocab
        all_strings{c} = [i j k];
        c = c + 1;
      end
    end
  end
  
  % now for each rule, apply it to each string
  tic
  disp('testing each rule against each string')
  for i = 1:length(hs.hs)
    fprintf('%d ',i);
    if mod(i,20)==0, fprintf('\n'); end;
    
    for j = 1:length(all_strings)
      true_of(i,j) = applyRuleToString(hs.hs{i},all_strings{j});
    end
  end
  toc
  
  % now consolidate logically consistent hypotheses
  % do all pairwise comparisons
  tic
  disp('removing logically consistent hypotheses')
  disp('this part can take as long as or longer than testing each rule against each string')
  i = 1;
  while i < size(true_of,1)
    fprintf('%d ',i);
    if mod(i,20)==0, fprintf('\n'); end;

    j = i + 1;
    while j < size(true_of,1)
      if all(true_of(i,:) == true_of(j,:))
        true_of(j,:) = [];
        hs.hs(j) = [];
%         disp('deleted');
      else
        j = j + 1;
      end                
    end
    i = i + 1;
  end
  toc
  
  hs.all_strings = all_strings;
  hs.true_of = sparse(true_of); % store this as a sparse matrix, takes up less space
  hs.cardinalities = sum(true_of,2);
  hs.probs = 1./hs.cardinalities;  
  hs.probs(isinf(hs.probs)) = 0;
  hs.log_probs = log(hs.probs);  
end
