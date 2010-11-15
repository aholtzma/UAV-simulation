function guitest

%close all
%m = imread('map.png');
%image(m);

figure(1);
[survey] = load_sequence('example_sequence/Plevna.seq');
plot_survey(survey);


if (0)
	% Draw a bounding box (still in UTM!)
	tmp = tline.ref_pt1 + 500 * [sin(tline.theta) -cos(tline.theta)];
	h = line([tline.ref_pt1(1) tmp(1)], [tline.ref_pt1(2) tmp(2)]);
	set(h,'Color','Black')

	foo = tline.ref_pt1 + -150 * [cos(cline.phi) sin(cline.phi)];
	tmp = foo + 15 * 300 / sin(cline.intersection_angle) * [cos(tline.theta) sin(tline.theta)];
	h = line([foo(1) tmp(1)], [foo(2) tmp(2)]);
	set(h,'Color','Black')

	foo = tline.ref_pt1 + (150 + (tline.n_lines-1) * tline.spacing / sin(cline.intersection_angle)) * [cos(cline.phi) sin(cline.phi)];
	tmp = foo + 15 * 300 / sin(cline.intersection_angle) * [cos(tline.theta) sin(tline.theta)];
	h = line([foo(1) tmp(1)], [foo(2) tmp(2)]);
	set(h,'Color','Black')
	tline.ref_pt1
end
