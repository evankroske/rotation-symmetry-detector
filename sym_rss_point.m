function rss_value = sym_rss_point (im, x, y, n)
% Compute RSS value for a given point

	half = ceil(n / 2);

	function esd = energy_spectral_density (dft_coeffs)
		esd = cellfun(@(row) (row .* conj(row)), dft_coeffs, ...
			'UniformOutput', false);
	end

	function output = dominant_frequencies (esd)
		mask = logical(ones(1, half));
		mask(1:2) = false;
		output = cellfun( ...
			@(row) row > ...
				mean(row(2:half)) + ...
				1 * std(row(2:half)) & ...
				mask, ...
			esd, ...
			'UniformOutput', false);
	end

	function x = row_rss_value (k_peaks_r, esd_r)
		if any(k_peaks_r)
			a = 0:half - 1;
			peak_indices = a(k_peaks_r);
			min_peak_index = min(peak_indices);
			rho_r = ~any(mod(peak_indices, min_peak_index));
			x = rho_r * mean(esd_r(k_peaks_r)) / mean(esd_r(2:half));
		else
			x = 0;
		end
	end
	
	function x = subvector (v, indices)
		x = v(indices);
	end

	rss_value = 0;
	fep = sym_frieze_expand(im, x, y, n);
	if length(fep) == 0
		return;
	end
	dft_coeffs = cellfun(@(row) subvector(fft(row), 1:half), fep, ...
		'UniformOutput', false);
	esd = energy_spectral_density(dft_coeffs);
	k_peaks = dominant_frequencies(esd);
	rss_value = sum(cell2mat( ...
		cellfun( ...
			@row_rss_value, ...
			k_peaks, ...
			esd, ...
			'UniformOutput', false)));
end
