function expansion = sym_frieze_expand (im, x, y, n)
% perform frieze expansion on image at specified coordinate

	expansion = {};
	[height, width] = size(im);
	radius = min([x, width - x, y, height - y]) - 1;
	if radius <= 1
		return;
	end
	angle_step = 2 * pi / n;
	angles = 0:angle_step:2 * pi - angle_step;
	relative_coords = mat2cell([radius * cos(angles); radius * sin(angles)], ...
		2, ones(1, n));

	function output = fast_improfile (d_x, d_y)
		steps = 0:radius / (radius - 1):radius;
		indices = sub2ind(size(im), ...
			round(y + steps * d_y), ...
			round(x + steps * d_x));
		output = im(indices);
	end

	expansion = cell2mat(transpose(arrayfun( ...
		@fast_improfile, ...
		cos(angles), ...
		sin(angles), ...
		'UniformOutput', false)));
end
