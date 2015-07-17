function [ savefile ] = setup_save( exp_name )
%SETUP_SAVE Summary of this function goes here
%   Detailed explanation goes here

time_str = strjoin(strsplit(num2str(now), '.'), '');
exp_name = sprintf('%s_%s', exp_name, time_str);
folder = ['data/'];
mkdir(folder);
savefile = [folder, exp_name, '.mat'];

end