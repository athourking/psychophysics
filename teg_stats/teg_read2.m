function [D, varnames, vn2c] = teg_read2(fn)

skiplines = 0;
varnames = {};

fid = fopen(fn, 'r');
l{1} = fgetl(fid);
l{2} = fgetl(fid);
words{1} = regexp(l{1}, '\t', 'split');
words{2} = regexp(l{2}, '\t', 'split');
fclose(fid);
N = [0 0];
nNum = [0 0];
for n = 1:2,
    for m = 1:length(words{n}),
        x = str2num(words{n}{m});
        if ~isempty(x),
            nNum(n) = nNum(n) + 1;
        end;
        N(n) = N(n) + 1;
    end;
end;
r = nNum ./ N;
if r(1) < 0.5 * r(2),
    varnames = words{1};
    skiplines = 1;
end;

fid = fopen(fn, 'r');
D = [];
for n = 1:skiplines,
    l0 = fgetl(fid);
end;
while ~feof(fid),
    l0 = fgetl(fid);
    fs = find(isspace(l0));
    tmp = [];
    a = 1;
    for is = 1:(length(fs) + 1),
        if is <= length(fs),
            b = fs(is);
        else,
            b = length(l0) + 1;
        end;
        if a < b,
            num0 = str2num(l0(a:(b - 1)));
        else,
            num0 = NaN;
        end;
        if isempty(num0),
            num0 = NaN;
        end;
        a = b + 1;
        tmp = [tmp num0];
    end;
    e0 = length(tmp) - size(D, 2);
    if e0 > 0,
        F0 = NaN * zeros(size(D, 1), e0);
        D = [D F0];
    end;
    if e0 < 0,
        tmp = [tmp NaN * zeros(1, abs(e0))];
    end;
    D = [D; tmp];
end;
fclose(fid);

vn2c = struct;
for n = 1:length(varnames),
    vn2c = setfield(vn2c, varnames{n}, n);
end;
