function h = ent(dist)
% add a small smoothing factor epsilon
dist = (dist + eps) ./ nansum(nansum(dist+eps));
l_dist = log2(dist);
h = -nansum(nansum(dist .* l_dist));
