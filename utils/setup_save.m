function [ savefile ] = setup_save( exp_name )
%SETUP_SAVE Summary of this function goes here
%   Detailed explanation goes here

folder = ['data/'];
mkdir(folder);
savefile = [folder, exp_name, '.mat'];

end

