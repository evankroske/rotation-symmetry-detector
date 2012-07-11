function expansion = sym_frieze_expand (im, x, y, n)
% perform frieze expansion on image at specified coordinate

% returns cell array of rows of the frieze expansion pattern
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
	expansion = mat2cell( ...
		cell2mat(cellfun( ...
			@(rel_coord) ( ...
				improfile( ...
					im, ...
					[x x + rel_coord(1)], ...
					[y y + rel_coord(2)], ...
					floor(radius))), ...
			relative_coords, ...
			'UniformOutput', false)), ...
		ones(1, radius), ...
		n);
end
