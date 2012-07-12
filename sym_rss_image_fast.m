function rss_image = sym_rss_image_fast (image, n)
% Compute RSS values for image quickly

	scale_factor = 0.5;
	if numel(image) <= 400
		% Calculate RSS values for tiny image
		rss_image = sym_rss_image(image, n);
	else
		small_rss_image = sym_rss_image_fast( ...
			imresize(image, scale_factor), ...
			n);
		rss_image = imresize(small_rss_image, size(image));
		[ys, xs] = find(rss_image > mean(rss_image(:)) + 3 * std(rss_image(:)));
		rss_image(sub2ind(size(rss_image), ys, xs)) = arrayfun( ...
			@(x, y) (sym_rss_point(image, x, y, n)), ...
			xs, ...
			ys);
	end
end
