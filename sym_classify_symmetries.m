function [type, num_lobes, region] = sym_classify_symmetries (image, x, y, n)
% Classify symmetries centered at (x, y) in image

	half = ceil(n / 2);
	fep = sym_frieze_expand(image, x, y, n);
	subvector = @(v, i) v(i);
	dft_coeffs = cellfun(@(row) subvector(fft(row), 1:half), fep, ...
		'UniformOutput', false);
	esd = sym_esd(dft_coeffs);
	k_peaks = sym_dominant_frequencies(esd, 2);
	[clusters, cluster_indices, cluster_num_lobes] = ...
		sym_group_rows(esd, k_peaks);
	keyboard;
end
