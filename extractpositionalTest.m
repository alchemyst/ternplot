testargs = {'this', 'is', 'a', 'majors', 20, 'test'};
outputargs = {'this', 'is', 'a', 'test'};

%% Normal parsing
[args, value] = extractpositional(testargs, 'majors', 10);
assert(all(strcmp(args, outputargs)), 'Incorrect arguments passed back');
assert(value == 20, 'Incorrect value extracted');

%% Default behaviour
[args, value] = extractpositional(outputargs, 'majors', 10);
assert(all(strcmp(args, outputargs)), 'Args changed');
assert(value == 10, 'Incorrect value extracted');

%% Edge case: empty list
[args, value] = extractpositional({}, 'majors', 10);
assert(isempty(args), 'Empty args not handled correctly');
assert(value == 10, 'Empty args not handled correctly');
