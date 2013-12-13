% display model 3 outputs in a pretty format

% find the maximum likelihood hypothesis for each cluster (because this
% helps you interpret what a cluster means)
[ll mlhs] = findMLHypotheses(c,train,hs,params,index_cache);
pr = computeCRP(c,params);

for i = 1:length(mlhs)
  fprintf('rule %d: %s %d %s %d %s %d\n',i,mlhs{i}{1},mlhs{i}{2},mlhs{i}{3},...
    mlhs{i}{4},mlhs{i}{5},mlhs{i}{6})
end

disp(['likelihood = ' num2str(ll,'%2.0f') ' / prior = ' num2str(pr,'%2.0f') ...
  ' / score = ' num2str(ll+pr,'%2.0f')]); 

fprintf('\n');
