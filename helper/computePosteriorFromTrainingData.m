% computes posterior probabilities over rules given training data for 
% model 1

function ps = computePosteriorFromTrainingData(hs,train)

for i = 1:length(hs.hs)
  for j = 1:length(train)
    if applyRuleToString(hs.hs{i},train{j})
      ll(i,j) = hs.log_probs(i);
    else
      ll(i,j) = -Inf;
    end        
  end
  
  ps(i) = sum(ll(i,:)) + log(1/length(hs.hs));
end
