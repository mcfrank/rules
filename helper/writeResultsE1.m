%% calculate correct and incorrect probability
true_of_all_inds = find(true_of_all);

for i = 1:length(correct)
  for j = 1:length(true_of_all_inds)
    if applyRuleToString(hs.hs{true_of_all_inds(j)},correct{i})
      cp(i,j) = 1;
    else
      cp(i,j) = 0;
    end
    
    if applyRuleToString(hs.hs{true_of_all_inds(j)},incorrect{i})
      ip(i,j) = 1;
    else
      ip(i,j) = 0;
    end
  end
end

lcp = log(double(all(cp,2))) + log(1/sum(consistent_strings));
lip = log(double(all(ip,2))) + log(1/sum(consistent_strings));

fprintf('correct probability: %2.2f\n',sum(lcp));
fprintf('incorrect probability: %2.2f\n',sum(lip));
fprintf('correct/incorrect (one item): %2.2f   %2.2f\n',...
  lcp(1),lip(1));
