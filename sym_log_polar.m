function out = sym_log_polar (image, x, y, radius, n_radials)
% Produce log-polar representation of a point in an image

	out = {};
	angle_step = 2 * pi / n_radials;
	angles = 0:angle_step:2 * pi - angle_step;

	function [indices, n_buckets] = calc_sample_bucket_indices (n_samples, n_buckets, width)
		max_step = 1;
		while log(factorial(max_step)) < n_samples - 1
			max_step = max_step + 1;
		end
		upper_bound = log(factorial(max_step));
		sample_values = 0:upper_bound / (radius - 1): ...
			upper_bound;
		a = 1:max_step;
		b = log(a);
		c = cumsum(b);
		indices = [];
		j = 1;
		for i = 1:length(c) - 1
			while j <= n_samples && sample_values(j) >= c(i) && ...
				sample_values(j) < c(i + 1)
				indices = [indices i];
				j = j + 1;
			end
		end
		if length(indices) < radius
			indices = [indices length(c) - 1];
		end
		n_buckets = max_step - 1;
	end

	function output = log_improfile (d_x, d_y)
		steps = 0:radius / (radius - 1):radius;
		sample_indices = sub2ind(size(image), ...
			round(y + steps * d_y), ...
			round(x + steps * d_x));
		samples = image(sample_indices);


		%min_step = steps(2);
		%max_step = steps(radius);
		%bucket_indices = [1 floor((log(steps(2:radius)) - log(min_step)) / ...
			%(log(max(steps)) - log(min_step)) * n_rings - 2) + 2];
		[bucket_indices, n_buckets] = calc_sample_bucket_indices(radius);
		
		buckets = cell(1, n_buckets);
		buckets(:) = {[]};
		for i = 1:radius
			buckets{bucket_indices(i)} = [buckets{bucket_indices(i)} ...
				samples(i)];
		end
		output = transpose(cellfun(@mean, buckets));
	end

	out = cell2mat(arrayfun( ...
		@log_improfile, ...
		cos(angles), ...
		sin(angles), ...
		'UniformOutput', false));
end
