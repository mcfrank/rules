% make sure that the set of classes is always contiguous (otherwise we will
% orphan some classes

function c = cleanUpClasses(c)

u = unique(c); % if a class became empty then there will be hole in u

for k = 1:length(u)
  if u(1) == 0    
    c(c==u(k)) = k-1;
  else
    c(c==u(k)) = k;
  end
end
