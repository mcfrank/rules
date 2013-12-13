% tests whether a rule is true of a string. gets used when caching
% cardinalities.

function tf = applyRuleToString(r,s)

tf = [0 0 0];

for i = 1:3 
  c = ((i-1)*2)+1;
  
  switch r{c}
    case 'na'
      tfs(i) = 1;
    case 'isa'
      tfs(i) = r{c+1} == s(i);
    case '='
      tfs(i) = s(r{c+1}) == s(i);
    case '>'
      tfs(i) = s(r{c+1}) < s(i);
    case '<'
      tfs(i) = s(r{c+1}) > s(i);
  end
end

tf = sum(tfs)==3;