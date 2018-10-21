dates = unique(complete.Date);
fixed_mat = 0:30:210;
ts = zeros(length(dates),length(fixed_mat));
for i=1:length(dates)
    vix_fut_sel = complete(complete.Date == dates(i), [1, 7, 12]);
    vix_fut_sel(vix_fut_sel.DaysToMat == 0, :) = [];
    mat = [0; vix_fut_sel.DaysToMat];
    vix_settle = [vix.Close(vix.Date == dates(i)); vix_fut_sel.Settle];
    ts(i,:) = interp1(mat, vix_settle, fixed_mat);
end
plot(dates,ts)