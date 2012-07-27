function symmetries = sym_classify_symmetries (image, x, y, n)
% Classify symmetries centered at (x, y) in image

	function out = is_dihedral (fep, num_lobes, max_std_diff)
		lobe = fep(1:floor(n / num_lobes), :);
		level = graythresh(fep);
		fep_bw = double(im2bw(fep, level));
		lobe_bw = double(im2bw(lobe, level));
		lobe_corr = xcorr2(fep_bw, lobe_bw);
		lobe_corr_std = std(lobe_corr(:, floor(size(fep, 2) / 2)));
		lobe_r_bw = lobe_bw(size(lobe_bw, 1):-1:1, :);
		lobe_r_corr = xcorr2(fep_bw, lobe_r_bw);
		lobe_r_corr_std = std(lobe_r_corr(:, floor(size(fep, 2) / 2)));
		out = abs(lobe_corr_std - lobe_r_corr_std) <= max_std_diff;
	end

	half = ceil(n / 2);
	fep = sym_frieze_expand(image, x, y, n);
	subvector = @(v, i) v(i);
	dft_coeffs = cellfun(@(row) subvector(fft(row), 1:half), fep, ...
		'UniformOutput', false);
	esd = sym_esd(dft_coeffs);
	k_peaks = sym_dominant_frequencies(esd, 2);
	[rings, ring_num_lobes] = sym_segment_by_freq( ...
		transpose(cell2mat(k_peaks)), ...
		transpose(cell2mat(esd)));
	ring_min_width = 5;
	wide_ring_mask = cellfun(@(ring) length(ring) > 5, rings);

	symmetries = [];
	j = 1;
	for i = find(wide_ring_mask)
		min_radius = min(rings{i}) - 1;
		max_radius = max(rings{i}) - 1;
		if ring_num_lobes(i) > 0
			if is_dihedral(transpose(cell2mat(fep(rings{i}))), ...
				ring_num_lobes(i), 0.2)
				symmetries(j).type = 'dihedral';
			else
				symmetries(j).type = 'cyclic';
			end
		else
			symmetries(j).type = 'continuous';
		end
		symmetries(j).num_lobes = ring_num_lobes(i);
		region = logical(zeros(size(image)));
		region(y-max_radius:y+max_radius, x-max_radius:x+max_radius) = ...
			strel('disk', max_radius, 0).getnhood;
		region(y-min_radius:y+min_radius, x-min_radius:x+min_radius) = ...
			region(y-min_radius:y+min_radius, x-min_radius:x+min_radius) - ...
			strel('disk', min_radius, 0).getnhood;
		symmetries(j).region = region;
		j = j + 1;
	end
end
