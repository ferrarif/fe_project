idx = find(vix.Date <= vix.Date(end) - 30);
dates = vix.Date(1:idx(end));
rv = zeros(length(dates),1);
spx_log_ret = [0; log(spx.Close(2:end)./spx.Close(1:end-1))];
for i=1:length(dates)
    date_start = dates(i);
    date_end = date_start + 30;
    idxs = (spx.Date > date_start & spx.Date <= date_end);
    no_trad_days = sum(idxs);
    rv(i) = sqrt(252/no_trad_days*sum(spx_log_ret(idxs).^2))*100;
end
plot(dates,[vix.Close(1:idx(end)), rv])