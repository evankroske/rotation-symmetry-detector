function rss_value = sym_rss_point (im, x, y, n)
% Compute RSS value for a given point

	half = ceil(n / 2);

	function x = cellify (mat)
		x = mat2cell(mat, size(mat, 1), ones(1, size(mat, 2)));
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
	dft = fft(fep);
	dft_half = dft(1:half, :);
	esd = sym_esd(dft_half);
	k_peaks = sym_dominant_frequencies(esd);
	rss_value = sum(cell2mat( ...
		cellfun( ...
			@row_rss_value, ...
			cellify(k_peaks), ...
			cellify(esd), ...
			'UniformOutput', false)));
end
