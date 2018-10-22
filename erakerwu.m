dates = unique(complete.Date);
dates = dates(447:1821);
mat = 30:30:120;
ret = zeros(length(dates), length(mat));
for j=1:length(mat)
    for i=2:length(dates)
        date_prev = dates(i-1);
        date = dates(i);
        sel_prev = sortrows(complete(complete.Date == date_prev, [1 2 7 12]), ...
            'DaysToMat');
        sel_prev(sel_prev.DaysToMat == 0, :) = [];
        sel = sortrows(complete(complete.Date == date, [1 2 7 12]), ...
            'DaysToMat');
        if ismember(mat(j), sel_prev.DaysToMat)
            contract = sel_prev.Contract(sel_prev.DaysToMat == mat(j));
            sel_contr = [sel_prev(sel_prev.Contract == contract, :); ...
                         sel(sel.Contract == contract, :)];
            ret(i,j) = sel_contr.Settle(2)/sel_contr.Settle(1)-1;
        elseif isempty(find(sel_prev.DaysToMat < mat(j), 1))
            sel_contr = [sel_prev(1,:); sel(1,:)];
            ret(i,j) = sel_contr.Settle(2)/sel_contr.Settle(1)-1;
        else
            L_prev = sel_prev(sel_prev.DaysToMat < mat(j), :);
            H_prev = sel_prev(sel_prev.DaysToMat > mat(j), :);
            contracts = [L_prev.Contract(end) H_prev.Contract(1)];
            maturities = [L_prev.DaysToMat(end) H_prev.DaysToMat(1)];
            w = (30 - maturities(2))/(maturities(1) - maturities(2));
            ret(i,j) = w*(sel.Settle(sel.Contract == contracts(1))/ ...
                sel_prev.Settle(sel_prev.Contract == contracts(1)) - 1) + ...
                (1-w)*(sel.Settle(sel.Contract == contracts(2))/ ...
                sel_prev.Settle(sel_prev.Contract == contracts(2)) - 1);
        end
    end
end
plot(dates, cumprod(ret + 1))