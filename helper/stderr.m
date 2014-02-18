function se = stderr(data,varargin)

if nargin > 1
  dim = varargin{1};
else
  dim = 1;
end

d = size(data);
new_d = d;
new_d(dim) = 1;

denom = sqrt(ones(new_d) .* d(dim));
se = nanstd(data,0,dim) ./ denom;
