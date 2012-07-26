function [rings, ring_indices, ring_num_lobes] = ...
	sym_group_rows(k_peaks)
	n = length(k_peaks{1});
	rings = {};
	ring_indices = zeros(1, n);
	ring_num_lobes = [];
	i = 1;
	j = 1;
	last_num_lobes = -1;
	while j <= length(k_peaks);
		k_peaks_row = k_peaks{j};
		a = 0:n - 1;
		peak_indices = a(k_peaks_row);
		min_peak_index = min(peak_indices);
		max_peak_index = max(peak_indices);
		if ~length(peak_indices) || ~any(mod(peak_indices, min_peak_index))
			if length(peak_indices)
				num_lobes = max_peak_index;
			else
				num_lobes = 0;
			end
			if num_lobes ~= last_num_lobes
				i = length(rings) + 1;
				rings{i} = [];
				ring_num_lobes(i) = num_lobes;
			else
				i = find(ring_num_lobes == num_lobes, 1, 'last');
			end
			ring_indices(j) = i;
			rings{i} = [rings{i} j];
			last_num_lobes = num_lobes;
		end
		j = j + 1;
	end
end
