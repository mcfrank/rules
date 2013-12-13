% noise up the training data
% flip an alpha-weighted coin and change on symbol of the sentence if it 
% comes up 1-alpha.

function [train index_cache] = addNoiseToTraining(hs,train,params,index_cache)

for i = 1:length(train)
  if rand > params.alpha
    ind = Randi(length(hs.all_strings));
    train{i} = hs.all_strings{ind};
    index_cache.train(i) = ind;
    %find(cellfun(@(x) all(train{i} == x),hs.all_strings));
  end  
end