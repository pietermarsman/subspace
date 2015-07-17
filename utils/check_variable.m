clc
if ~exist(variable, 'var')
    error('Variable "%s" should be set beforehand', variable)
end