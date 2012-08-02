# Introduction

The library's functions can be divided into three categories: functions which are used to identify centers of rotational symmetries, functions which are used to classify rotational symmetries, and functions which are used by the previous two categories.

## Functions for identifying rotational symmetries

<dl>
<dt>`sym_rss_point`</dt>
<dd>Calculates a value representing the likelihood that a given point is the center of a rotational symmetry. This value is called the RSS value of the point.</dd>
<dt>`sym_rss_image`</dt>
<dd>Calculates the RSS value for every point in a given image using `sym_rss_point`. Slow.</dd>
<dt>`sym_rss_image_fast`</dt>
<dd>Calculates approximate RSS value for each point in an image quickly. Doesn't work well.</dd>
</dl>

## Functions for classifying rotational symmetries

<dl>
<dt>`sym_classify_symmetries`</dt>
<dd>Classifies rotational symmetries centered at a given point by type, number of lobes, and region.</dd>
<dt>`sym_segment_by_freq`</dt>
<dd>Segments FEP by considering its ESD.</dd>
<dt>`sym_group_rows`</dt>
<dd>Groups rows of the FEP into rings by their frequency.</dd>
<dt>`sym_merge_rings`</dt>
<dd>Merges rings based on their frequencies and their width.</dd>
</dl>

## Functions used by the previous two categories

<dl>
<dt>`sym_frieze_expand`</dt>
<dd>Produces frieze expansion of an image at a given point.</dd>
<dt>`sym_esd`</dt>
<dd>Produces energy spectral density of a FEP given its DFT coefficients.</dd>
</dl>

