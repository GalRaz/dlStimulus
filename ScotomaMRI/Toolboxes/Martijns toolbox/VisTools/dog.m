function A = dog(n, s)% DOG  makes a 1D difference-of-gaussians. %% usage:%	DOG(N, S) makes a vector of length n containing a DOG% 	with equal + and - areas and space constant s.%     % see also: gab, gaus, ddog, ggab, ggaus% % Authors Name% history:% 3/24/97   lkc Wrote it.% 7/2/02    lkc Cleaned up comments.A=zeros(n);x=-n/2:n/2-1;temp1=3.*exp(-x.^2./(s^2));		temp2=2.*exp(-x.^2./(2.25*(s^2)));A=temp1-temp2;