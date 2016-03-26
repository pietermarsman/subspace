function [ ] = savefigure( dir, name )
%SAVEFIGURE Summary of this function goes here
%   Detailed explanation goes here

mkdir(dir)
mkdir([dir, '/original'])

dir = strrep(lower(dir), ' ', '_');
name = strrep(lower(name), ' ', '_');
name = strrep(name, '\', '');
name = strrep(name, '^', '');
name = strrep(name, '=', '');
name = strrep(name, '.', '');
savename = [dir, '/', name]
original = [dir, '/original/', name]

savefig(original);
export_fig(savename, '-pdf', '-transparent');

end

