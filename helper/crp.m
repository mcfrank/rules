% function l = crp(ns, gamma) 
% probability of the partition in ns under a CRP with concentration parameter
% gamma (note that gamma here is NOT the gamma function but just a number)
%
% Provided by Charles Kamp 2006

function l = crp(ns, gamma) 

ns=ns(ns~=0); % only consider classes that are not empty
k = length(ns); % number of classes
n = sum(ns); % number of samples
l = sum(gammaln(ns))+k*log(gamma)+gammaln(gamma)-gammaln(n+gamma); 
