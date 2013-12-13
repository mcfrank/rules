% caches the indices for the training and test items in the hypothesis
% space. useful for speeding up sums over likelihoods.

function ic = cacheItems(ts,cs,is,hs)

% consolidate all the strings if train and test are different
if length(hs.test_vocab) == length(hs.train_vocab) && ...
    hs.train_vocab(1) == hs.test_vocab(1)
  all_strings = hs.all_strings;
  true_of = hs.true_of;
else
  all_strings = [hs.all_strings hs.all_test_strings];
  true_of = [hs.true_of hs.true_of_test];  
end

items = [cs is];
for i = 1:length(ts)
%   ic.train(i) = find(cellfun(@(x) all(ts{i} == x),all_strings));
  ic.train(i) = findString(ts{i},all_strings);
end

for i = 1:length(items)
%   ic.items(i) = find(cellfun(@(x) all(items{i} == x),all_strings),1);
  ic.items(i) = findString(items{i},all_strings);
end

end

% for some reason this method is empirically faster than the cellfuns
% above, perhaps the error checking in cellfun?
function i = findString(s,as)

  for i = 1:length(as)
    if s(1) == as{i}(1) && s(2)==as{i}(2) && s(3)==as{i}(3)
      return;
    end
  end
end   