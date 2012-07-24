function [clusters, cluster_indices, cluster_num_lobes] = sym_group_rows( ...
	esd, k_peaks)
	n = length(esd{1});
	clusters = {};
	cluster_indices = zeros(1, n);
	cluster_num_lobes = [];
	i = 1;
	j = 1;
	while j <= length(k_peaks);
		k_peaks_row = k_peaks{j};
		num_lobes = 0;
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
			if ~any(cluster_num_lobes == num_lobes)
				i = length(clusters) + 1;
				clusters{i} = [];
				cluster_num_lobes(i) = num_lobes;
			else
				i = find(cluster_num_lobes == num_lobes);
			end
			cluster_indices(j) = i;
			clusters{i} = [clusters{i} j];
		end
		j = j + 1;
	end
end
