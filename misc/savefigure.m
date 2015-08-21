function [ ] = savefigure( dir, name )
%SAVEFIGURE Summary of this function goes here
%   Detailed explanation goes here

mkdir(dir)
mkdir([dir, '/original'])

savename = [dir, '/', name];
original = [dir, '/original/', name];

savefig(original);
export_fig(savename, '-png', '-transparent');

end

