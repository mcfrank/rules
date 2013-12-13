%% write the results from model 1 in a compact way

clear cp
clear ip

inds = find(ps~=-Inf);
h = hs.hs(inds);
p = ps(inds) - logsumexp(ps(inds),2);
 
for i= 1:length(h)
  fprintf('%d: %s %d %s %d %s %d: %2.2f\n',inds(i),h{i}{1},h{i}{2},h{i}{3},...
    h{i}{4},h{i}{5},h{i}{6},p(i));
end

fprintf('posterior entropy: %2.4f\n',ent(exp(p)));


%% calculate correct and incorrect probability

for i = 1:length(correct)
  for j = 1:length(h)
    if applyRuleToString(h{j},correct{i})
      cp(i,j) = p(j) + hs.log_probs(inds(j));
    else
      cp(i,j) = -Inf;
    end
    
    if applyRuleToString(h{j},incorrect{i})     
      ip(i,j) = p(j) + hs.log_probs(inds(j));
    else
      ip(i,j) = -Inf;
    end
  end
end

fprintf('correct probability: %2.2f\n',logsumexp(sum(cp,1),2));
fprintf('correct probability (rev sum): %2.2f\n',sum(logsumexp(cp,2),1));
fprintf('incorrect probability: %2.2f\n',logsumexp(sum(ip),2));
fprintf('correct/incorrect (one item): %2.2f   %2.2f\n',...
  logsumexp(cp(1,:),2),logsumexp(ip(1,:),2));
