function [symmetries] = sym_classify_symmetries (image, x, y, n)
% Classify symmetries centered at (x, y) in image

	half = ceil(n / 2);
	fep = sym_frieze_expand(image, x, y, n);
	subvector = @(v, i) v(i);
	dft_coeffs = cellfun(@(row) subvector(fft(row), 1:half), fep, ...
		'UniformOutput', false);
	esd = sym_esd(dft_coeffs);
	k_peaks = sym_dominant_frequencies(esd, 2);
	[rings, ring_indices, ring_num_lobes] = sym_group_rows(k_peaks);
	ring_min_width = 5;
	wide_ring_mask = cellfun(@(ring) length(ring) > 5, rings);

	symmetries = [];
	for i = find(wide_ring_mask)
		min_radius = min(rings{i}) - 1;
		max_radius = max(rings{i}) - 1;
		if ring_num_lobes(i) > 0
			symmetries(i).type = 'cyclic';
		else
			symmetries(i).type = 'continuous';
		end
		symmetries(i).num_lobes = ring_num_lobes(i);
		region = logical(zeros(size(image)));
		region(y-max_radius:y+max_radius, x-max_radius:x+max_radius) = ...
			strel('disk', max_radius, 0).getnhood;
		region(y-min_radius:y+min_radius, x-min_radius:x+min_radius) = ...
			region(y-min_radius:y+min_radius, x-min_radius:x+min_radius) - ...
			strel('disk', min_radius, 0).getnhood;
		symmetries(i).region = region;
	end
	keyboard;
end
