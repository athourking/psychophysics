function [F, dfM, dfE, p, SSM, SSE, MSM, MSE, eta, eps0, bModel, X_ind, dfM_adj, dfE_adj] = teg_RMF_ANOVA(expanded0, X0, B, Bcoder)

nSubj = size(expanded0, 1);
subjM = mean(expanded0, 2);

X_ind = [];
for iX = 1:size(X0, 2),
    tmp = reshape(X0(:, iX), size(expanded0));
    newcol = tmp(1, :)';
    newcol = newcol ./ sqrt(var(newcol));
    X_ind = [X_ind newcol];
end;

transformed0 = [];
if ~isempty(X0),
    expanded0_red = zeros(size(expanded0));
    for iSubj = 1:size(expanded0, 1),
        y = expanded0(iSubj, :);
        y = y(:) - mean(y(:));
        
        X = X_ind;

        if length(find(X ~= 0)) > 0,
            b = inv(X'*X)*X'*y;
            model = X*b;
        else
            model = zeros(size(y));
        end;
        expanded0_red(iSubj, :) = model;
        
        transformed0 = [transformed0; y' * X];
        
        number_of_dims = size(X, 2);
    end;
else,
    expanded0_red = expanded0;
    X0 = ones(size(expanded0_red));
    X_ind = [];
end;

if ~isempty(Bcoder),
    % recode B to index values
    Blevels = [];
    for iB = 1:size(B, 2),
        bv = B(:, iB);
        u = unique(bv);
        tmp = zeros(size(bv));
        for iu = 1:length(u),
            f = find(bv == u(iu));
            tmp(f) = iu;
        end;
        B(:, iB) = tmp;
        Blevels = [Blevels length(u)];
    end;
    Bdummy = [];
    for iSubj = 1:size(B, 1),
        grVars = B(iSubj, :);
        % Find dummy coder for this combination of group-variables
        row = 1;
        for iB = 1:size(B, 2),
            if iB < length(Blevels),
                skipper = prod(Blevels((iB + 1):end));
            else,
                skipper = 1;
            end;
            row = row + (grVars(iB) - 1) * skipper;
        end;
        Bdummy = [Bdummy; Bcoder(row, :)];
    end;
    % Expand with within-subject coders
    tmpX = [];
    X02 = X0;
    for iX = 1:size(X02, 2),
        X02v = reshape(X02(:, iX), size(expanded0_red));
        for iB = 1:size(Bdummy, 2),
            tmp2 = Bdummy(:, iB) * ones(1, size(X02v, 2));
            tmp2 = tmp2 .* X02v;
            tmpX = [tmpX tmp2(:)];
        end;
    end;
    X02 = tmpX;
    X0 = X02;
end;


X = X0;
y = expanded0_red(:);
b = inv(X'*X)*X'*y;
model = X*b;
err = y - model;
SSM = sum(model.^2);
SSE = sum(err.^2);

bModel = b;

% Calc eps.
if size(transformed0, 2) > 1,
    vars = var(transformed0);
    eps_num = sum(vars) .^ 2;
    eps_den = length(vars) * sum(vars .^ 2);
    eps0 = eps_num / eps_den;
else
    eps0 = 1;
end;

dfM = size(X0, 2);
dfM = dfM;
dfE = (nSubj - 1) * dfM;
dfM_adj = eps0 * dfM;
dfE_adj = eps0 * dfE; 
MSM = SSM / dfM;
MSE = SSE / dfE;
F = MSM / MSE;
p = teg_fsig(F, dfM_adj, dfE_adj);
eta = SSM / (SSM + SSE);

