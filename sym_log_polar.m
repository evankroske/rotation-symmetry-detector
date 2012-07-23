function out = sym_log_polar (image, x, y, radius, n_radials, n_rings, ...
	log_width)
% Produce log-polar representation of a point in an image

	if nargin < 7
		log_width = radius;
	end
	if nargin < 6
		n_rings = floor(radius / 3);
	end

	out = [];
	angle_step = 2 * pi / n_radials;
	angles = 0:angle_step:2 * pi - angle_step;

	function indices = calc_sample_bucket_indices (n_samples, n_buckets, width)
		a = 1:width / n_buckets:1 + width;
		b = log(a);
		c = cumsum(b);

		upper_bound = max(c);
		sample_values = 0:upper_bound / (n_samples - 1): ...
			upper_bound;
		indices = [];
		j = 1;
		for i = 1:length(c) - 1
			while j <= n_samples && sample_values(j) >= c(i) && ...
				sample_values(j) < c(i + 1)
				indices = [indices i];
				j = j + 1;
			end
		end
		if length(indices) < n_samples
			indices = [indices length(c) - 1];
		end
	end

	function output = log_improfile (d_x, d_y)
		steps = 0:radius / (radius - 1):radius;
		sample_indices = sub2ind(size(image), ...
			round(y + steps * d_y), ...
			round(x + steps * d_x));
		samples = image(sample_indices);

		bucket_indices = calc_sample_bucket_indices(radius, n_rings, log_width);
		buckets = cell(1, n_rings);
		buckets(:) = {[]};
		for i = 1:radius
			buckets{bucket_indices(i)} = [buckets{bucket_indices(i)} ...
				samples(i)];
		end
		output = transpose(cellfun(@mean, buckets));
	end

	out = uint8(cell2mat(arrayfun( ...
		@log_improfile, ...
		cos(angles), ...
		sin(angles), ...
		'UniformOutput', false)));
end
