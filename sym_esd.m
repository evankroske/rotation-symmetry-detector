function esd = sym_esd (dft_coeffs)
	esd = cellfun(@(row) (row .* conj(row)), dft_coeffs, ...
		'UniformOutput', false);
end
