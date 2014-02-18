function se = stderr(data)

[m n] = size(data);

denom = sqrt(ones(1,n) .* m);
se = nanstd(data) ./ denom;
