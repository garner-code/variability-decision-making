%%%%%%%%%% K. Garner - generating random numbers with mu and probs for
%%%%%%%%%% worlds
clear all
sigmas = [0.2, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2, 2.25, 2.5];
mu = 8;


out_dists = {};
t_dists = {};
for i = 1:length(sigmas)
    out_dists{i} = makedist('normal', 'mu', mu, 'sigma', sigmas(i));
    t_dists{i} = truncate(out_dists{i}, 1, 16);
end

x = 1:16;
h = {};% 16 bins
figure;
for i = 1:length(sigmas)
    subplot(5, 2, i);
    h{i} = plot(x, pdf(t_dists{i},x));
    title(sprintf('sigma = %.2f', sigmas(i)));
    xlim([0, 17]);
end

%%%%% now I have the y's, I'll generate binomial distribution using the
%%%%% probabilities frm the difference distributions, and then I'll make
%%%%% histograms - I will also add a small amount of noise to each one so
%%%%% that all locations have at least one occurrence
%%%%% subsequently removing noise
size_freqs = 100;
outhists = zeros(length(sigmas), 16);
figure;
hists={};
probs = zeros(length(sigmas), 16);
for i = 1:length(sigmas)
    
    probs(i, :) = h{i}.YData;
    probs(i,:) =  probs(i,:)./sum(probs(i,:));
    outhists(i, :) = mnrnd(size_freqs, probs(i,:));
    subplot(5, 2, i);
    hists{i} = bar(x, outhists(i,:));
    title(sprintf('sigma = %.2f', sigmas(i)));
    ylim([0, 40]);
   % xlim([0, 17]);
     
end

%%%%% now draw 20 random samples of 100 trials from the 'worlds' and see if the
%%%%% coefficient of variation is different between the two

%%%%% first trying w sd .5 and 1.5 (adding some noise)
small = mnrnd(100, probs(2,:), 20) + randi(20,20,16);
lrge  = mnrnd(100, probs(7,:), 20) + randi(20,20,16);

coeff_var_small = var(small, 0, 2)./mean(small,2);
coeff_var_lrge  = var(lrge,  0, 2)./mean(lrge,2);
[h,p,ci,stats] = ttest(coeff_var_small, coeff_var_lrge);

%%%%% going with .5 & 2 (probs 1 & 7) - with no noise
% probs_cert_world = probs(2,:);
% save('probs_cert_world_v2', 'probs_cert_world');
% 
% probs_uncert_world = probs(7,:);
% save('probs_uncert_world_v2', 'probs_uncert_world');

%%%%% manually defining probs for certain world
probs_cert_world = zeros(1, 16);
probs_cert_world(1:4) = [.25, .25, .25, .25];
probs_uncert_world = zeros(1, 16);
probs_uncert_world(1:12) = repmat(1/12, 1, 12);
save('probs_cert_world_v2', 'probs_cert_world');
save('probs_uncert_world_v2', 'probs_uncert_world');
