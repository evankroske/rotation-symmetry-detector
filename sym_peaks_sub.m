function [xs ys] = sym_peaks_sub (rss_map, beta)
% Finds coordinates of local maxima greater than mean + beta * std

	maxima_mask = rss_map > imdilate(rss_map, [1 1 1; 1 0 1; 1 1 1]);
	threshold = rss_map(maxima_mask) >= mean(rss_map(:)) + ...
		beta * std(rss_map(:));
	[all_xs, all_ys] = find(maxima_mask);
	xs = all_xs(threshold);
	ys = all_ys(threshold);
end
