function [max_peaks_rows max_peaks_cols] = sym_peaks_sub (rss_map, beta)
% Finds coordinates of local maxima greater than mean + beta * std

	maxima_mask = rss_map > imdilate(rss_map, [1 1 1; 1 0 1; 1 1 1]);
	threshold = rss_map(maxima_mask) >= mean(rss_map(:)) + ...
		beta * std(rss_map(:));
	[peaks_rows, peaks_cols] = find(maxima_mask);
	max_peaks_rows = peaks_rows(threshold);
	max_peaks_cols = peaks_cols(threshold);
end
