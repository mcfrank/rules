% write the results from model 2 in a compact way

ps = exp(mean(all_ps,1)); % consolidate across subjects

inds = find(ps>prctile(ps,95));
p = ps(inds);
[p ix] = sort(p,2,'ascend'); % sort so it's easier to read
inds = inds(ix);
h = hs.hs(inds);
 
for i= 1:length(h)
  fprintf('%s %d %s %d %s %d: %2.2f\n',h{i}{1},h{i}{2},h{i}{3},...
    h{i}{4},h{i}{5},h{i}{6},p(i));
end

fprintf('posterior entropy: %2.2f\n',ent(exp(p)));
fprintf('mean surprisal: %2.2f\n',mean(surprisal));
