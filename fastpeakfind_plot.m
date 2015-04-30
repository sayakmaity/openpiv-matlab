function out = fastpeakfind_plot(cc)
p = FastPeakFind(cc);

px = p(1:2:end);
py = p(2:2:end);


pks = zeros(length(px),1); % has to be even length
for i = 1:length(pks)
    pks(i) = cc(py(i),px(i));
end

[~,j] = sort(pks,'descend');

figure, imagesc(cc); hold on
for i = 1:2
    plot(px(j(i)),py(j(i)),'k+');
end

out = [px(j(1:2)),py(j(1:2))];
