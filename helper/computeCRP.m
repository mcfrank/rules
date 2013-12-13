% wrapper function for the crp prior

function prior = computeCRP(c,params)

% get the size of each class
for i = 1:max(c)
  class_sizes(i) = sum(c==i);
end

prior = crp(class_sizes, params.gamma);


