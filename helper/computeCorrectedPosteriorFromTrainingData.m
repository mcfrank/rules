% computes posterior probabilities over rules given training data for 
% model 1

% this function implements the correction for sampling without replacement,
% irrespective of order.

function ps = computeCorrectedPosteriorFromTrainingData(hs,train)

applies = zeros(length(hs.hs),length(train));

for i = 1:length(hs.hs)
  for j = 1:length(train)
    if applyRuleToString(hs.hs{i},train{j})
      applies(i,j) = 1;
    end        
  end
end

ls = ones(length(hs.hs),1);
ls(~all(applies,2)) = 0;

% m! (|r| - m)!  /  |r|!

rs = hs.cardinalities(ls==1);
m = length(train);

ls(ls==1) = factorial(m) .* factorial(rs - m) ./ factorial(rs);

ps = log(ls) + log(1/length(hs.hs));

ps(isnan(ps)) = -Inf;