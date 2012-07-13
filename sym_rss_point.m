function rss_value = sym_rss_point (im, x, y, n)
% Compute RSS value for a given point

	function esd = energy_spectral_density (dft_coeffs)
		esd = cellfun(@(row) (row .* conj(row)), dft_coeffs, ...
			'UniformOutput', false);
	end

	function k_peaks = dominant_frequencies (esd)
		half = floor(n / 2);
		k_peaks = cellfun( ...
			@(row) row > ...
				mean(row(2:half)) + ...
				2 * std(row(2:half)), ...
			esd, ...
			'UniformOutput', false);
	end

	function x = row_rss_value (k_peaks_r, esd_r)
		if any(esd_r) && any(k_peaks_r)
			a = 1:n;
			x = ~any(mod(a(k_peaks_r), min(a(k_peaks_r)))) * ...
				mean(esd_r(k_peaks_r)) / mean(esd_r);
		else
			x = 0;
		end
	end

	rss_value = 0;
	fep = sym_frieze_expand(im, x, y, n);
	if length(fep) == 0
		return;
	end
	dft_coeffs = cellfun(@(row) (fft(row)), fep, 'UniformOutput', false);
	esd = energy_spectral_density(dft_coeffs);
	k_peaks = dominant_frequencies(esd);
	rss_value = sum(cell2mat( ...
		cellfun( ...
			@row_rss_value, ...
			k_peaks, ...
			esd, ...
			'UniformOutput', false)));
end
