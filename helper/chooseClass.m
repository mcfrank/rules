% choose a class randomly proportional to marginal probability

function nc = chooseClass(new_scores)

c = 1:length(new_scores);
new_scores = new_scores - max(new_scores); % add constant to make calculation of ratios possible
ps = exp(new_scores); % calculate relative probabilities
ps = ps / sum(ps); % normalize to 1
cumPs = cumsum(ps);
nc = c(find(rand<cumPs,1,'first'));
