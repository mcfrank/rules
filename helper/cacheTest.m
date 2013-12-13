% cache whether each rule applies to each test string. (same as
% cacheCardinalities, more or less).

function hs = cacheTest(hs)

  % done if train and test are the same
  if length(hs.test_vocab) == length(hs.train_vocab) && ...
      all(hs.test_vocab == hs.train_vocab)
    hs.true_of_test = hs.true_of;
    hs.all_test_strings = hs.all_strings;
    return;
  end
  
  % get all strings in test vocab
  c = 1;
  for i = hs.test_vocab
    for j = hs.test_vocab
      for k = hs.test_vocab
        hs.all_test_strings{c} = [i j k];
        c = c + 1;
      end
    end
  end  
  
  % now for each rule, apply it to each string
  tic
  for i = 1:length(hs.hs)
    for j = 1:length(hs.all_test_strings)
      hs.true_of_test(i,j) = applyRuleToString(hs.hs{i},hs.all_test_strings{j});
    end
  end
  toc  
end
