function [remainingargs, value] = extractpositional(args, name, default)
remainingargs = {};
skipping = false;
value = default;
for i = 1:length(args)
    if strcmp(args{i}, name)
        value = args{i+1};
        skipping = true;
    elseif skipping
        skipping = false;
    else
        remainingargs{end+1} = args{i};
    end
end
