function [segments, segments_num_lobes] = sym_merge_rings (rings, ...
	ring_num_lobes, k_peaks, esd);
	
	function certainty = num_lobes_certainty (segment, num_lobes)
		certainty = mean(cellfun(@(esd_r) esd_r(num_lobes + 1), ...
			esd(segment)));
	end

	segments = rings;
	segments_num_lobes = ring_num_lobes;
	i = 1;
	j = 2;
	a = 0:size(k_peaks, 1);
	while j <= length(segments)
		if segments_num_lobes(i) > segments_num_lobes(j)
			big = i;
			small = j;
		else
			big = j;
			small = i;
		end
		if min(segments{j}) - max(segments{i}) < 10 && ...
			~mod(segments_num_lobes(big), segments_num_lobes(small)) && ...
			mean(k_peaks(segments_num_lobes(small) + 1, segments{big})) > 0.5
			new_segment = [segments{i} segments{j}];
			new_num_lobes = segments_num_lobes(small);
			segments(j) = [];
			segments_num_lobes(j) = [];
			segments{i} = new_segment;
			segments_num_lobes(i) = new_num_lobes;
		else
			i = j;
			j = j + 1;
		end
	end
end
