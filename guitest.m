function guitest

close all
%m = imread('map.png');
%image(m);

figure(1);
[tline cline] = load_sequence('example_sequence/Plevna.seq');

for i = [1:tline.n_lines]
	h = line([tline.line(i).pt1(1) tline.line(i).pt2(1)],  ...
	         [tline.line(i).pt1(2) tline.line(i).pt2(2)]);
	set(h,'ButtonDownFcn',@button_down)
	if(i == 1)
		set(h,'Color','Red')
	else
		set(h,'Color','Blue')
	end
end

for i = [1:cline.n_lines]
	h = line([cline.line(i).pt1(1) cline.line(i).pt2(1)],  ...
	         [cline.line(i).pt1(2) cline.line(i).pt2(2)]);
	set(h,'ButtonDownFcn',@button_down)
	if(i == 1)
		set(h,'Color','Red')
	else
		set(h,'Color','Green')
	end
end
axis equal

function button_down(src, event)

	if(strcmp(get(src,'Selected'), 'on'))
		set(src,'Selected','off')
	else
		set(src,'Selected','on')
	end
