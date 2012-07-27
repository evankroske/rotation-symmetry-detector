function [segments, segment_num_lobes] = sym_segment_by_freq(k_peaks, esd)
% Segment fep using peak frequencies

	[rings, ring_indices, ring_num_lobes] = sym_group_rows(k_peaks);
	[segments, segment_num_lobes] = sym_merge_rings(rings, ring_num_lobes, ...
		k_peaks, esd);
end
