function sym_test_everything()

	function p (message, result)
		if result
			status = 'passed';
		else
			status = 'failed';
		end
		disp([message ' ' status]);
	end

	i = imread('test-images/cross.png');
	fep = sym_frieze_expand(i, 11, 11, 91);
	r = all(size(fep) == [91 9]) && ~length(find(isnan(fep)));
	p('sym_frieze_expand', r);

	dft = [1i 0; 0 1i; 1 0];
	correct_esd = [1 0; 0 1; 1 0];
	esd = sym_esd(dft);
	r = all(size(esd) == [3 2]) && all(esd(:) == correct_esd(:));
	p('sym_esd', r);

	esd = [10 5; 0 1; 0 1; 0 2; 2 2];
	correct_k_peaks = [0 0; 0 0; 0 0; 0 0; 1 0];
	k_peaks = sym_dominant_frequencies(esd);
	r = all(k_peaks(:) == correct_k_peaks(:));
	p('sym_dominant_frequencies', r);

	j = sym_rss_image(i, 91);
	r = max(j(:)) == j(11, 11) && ~length(find(isnan(j)));
	p('sym_rss_image', r);

	j = sym_rss_image_fast(i, 91);
	r = max(j(:)) == j(11, 11) && ~length(find(isnan(j)));
	p('sym_rss_image_fast', r);

	i = rgb2gray(imread('test-images/fractal.jpg'));
	correct_types = {'continuous' 'dihedral' 'continuous' 'cyclic' 'cyclic'};
	symmetries = sym_classify_symmetries(i, 181, 204, 91);
	passed = all([symmetries.num_lobes] == [0 4 0 5 5]) && ...
		isequal({symmetries.type}, correct_types);
	p('sym_classify_symmetries', passed);

end
