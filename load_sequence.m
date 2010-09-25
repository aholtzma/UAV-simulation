function [tlines clines] = load_sequence(file_name)
% [tlines clines] = load_sequence(file_name)
%     Loads an SGL survey sequence file. Returns two structures defining the 
%     traverse and control survey lines.

f = fopen(file_name,'r');

%
% First line we skip for now
%
s = fgets(f);

%
% Second line defines the traverse reference line
%
s = fgets(f);
C = textscan(s,'%f %f %f %f %f %s %f');
tlines.ref_pt1= [C{1} C{2}];
tlines.ref_pt2 = [C{3} C{4}];
tlines.spacing = C{7};
tlines.n_lines = 0;
tlines.line = [];
theta = atan2(C{4} - C{2}, C{3} - C{1});

%
% Third line line defines the control reference line
%
s = fgets(f);
C = textscan(s,'%f %f %f %s %f');
clines.start_offset = C{1};
clines.intersection_angle = C{2};
clines.spacing = C{5};
clines.n_lines = 0;
clines.line = [];
phi = theta - clines.intersection_angle * pi / 180;

%
% Traverse lines
%
s = fgets(f);
if(~strncmp(s,'TLIMITS', 7))
	error('Invalid sequence file');
	return;
end

s = fgets(f);
while(~strncmp(s,'CLIMITS',7))
	n_lines = tlines.n_lines + 1;
	C = textscan(s,'%d %fm %fm');

	tlines.n_lines = n_lines;
	tlines.line(n_lines).num = C{1};
	start_lim = C{2};
	end_lim = C{3};

	tmp = tlines.ref_pt1 + (n_lines-1) * tlines.spacing * [sin(theta) -cos(theta)];
	tlines.line(n_lines).pt1 =  tmp + start_lim * [cos(theta) sin(theta)];
	tlines.line(n_lines).pt2 =  tmp + end_lim * [cos(theta) sin(theta)];

	s = fgets(f);
end

%
% Control lines
%
s = fgets(f);
while(~strncmp(s,'ENDGRID',7))
	n_lines = clines.n_lines + 1;
	C = textscan(s,'%d T%d%f T%d%f');

	clines.n_lines = n_lines;
	clines.line(n_lines).num = C{1};
	start_lim = C{3}
	end_lim = C{5}

	clines.line(n_lines).pt1 = tlines.line(1).pt1 +  ...
	  ((n_lines-1) * clines.spacing + clines.start_offset) * [cos(theta) sin(theta)] + ...
	  start_lim * [cos(phi) sin(phi)];

	clines.line(n_lines).pt2 = tlines.line(tlines.n_lines).pt1 +  ...
	  ((n_lines-1) * clines.spacing + clines.start_offset) * [cos(theta) sin(theta)] + ...
	  end_lim * [cos(phi) sin(phi)];

	s = fgets(f);
end
