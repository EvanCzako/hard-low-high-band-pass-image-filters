# hard-low-high-band-pass-image-filters
Applies a spatial frequency filter to images using upper and lower frequency thresholds. Includes scale factor input for physical data.

Takes input image, modifies its frequency domain according to upper and lower spatial frequency thresholds, and returns the filtered image. This is a "hard" filter in that all values in the frequency domain within the threshold frequencies are multiplied by 1 and all values outside of the thresholds are multiplied by 0.

This program is useful for isolating specific frequencies; however, some filtered images come back with "wavy" artifacts, especially around the edges, as a result of the discontinuous nature of the filter. I will soon be uploading a Gaussian filter in which the user-specified thresholds correspond to the full width at half maximum (FWHM) of the Gaussian function. That filter will produce much smoother images but is not as good at isolating specific wavelengths. Your choice of filter will depend on the application for which to intend to use it.

This function also includes a scale factor for physical data. This should be utilized any time the height of an image differs physically from its width (e.g. an image that physically represents a 2 mm x 3 mm area).

Please see function description and examples for a more in-depth explanation and demonstration of its use.

[![View Hard low pass, high pass, and band pass filtering for images on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/72682-hard-low-pass-high-pass-and-band-pass-filtering-for-images)
