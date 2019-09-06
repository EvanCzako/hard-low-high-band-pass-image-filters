function im_2 = hard_filter(im_1,low_freq,high_freq,show_freq_domain,y_over_x_scale_factor)
    
    % Returns a filtered version of im_1. Applies a hard pass filter to
    % im_1 by acquiring its frequency domain and including only those 
    % spatial frequencies that are above low_freq and below high_freq.
    % By marking boolean input show_freq_domain as true, you can compare 
    % the filtered image to the original image, visualize the filter 
    % window, and compare the filtered frequency domain to the original 
    % frequency domain to better understand the mechanism behind this 
    % filter.
    % If your image corresponds to physical data, you should utilize the 
    % y_over_x_scale_factor input variable, which is the ratio of the
    % physical height of the image to the physical width of the image. If
    % this value is set to 1, the filter assumes the physical height and
    % width of the image are equivalent, even if there are more columns
    % than rows or vice versa.
    % Spatial frequencies are by default defined with respect to the
    % boundaries of the image. If you have a 258x350 image, then a
    % frequency of 1 corresponds to a wavelength of 258 pixels in the
    % y-direction and a wavelength of 350 pixels in the x-direction.
    %
    % Please see examples for further explanation and demonstration of this
    % function.
    %
    %
    % Example 1:
    % 
    %     % Superimpose a series of linear and circular waves. You can change the
    %     % angles, frequencies, and amplitudes of the waves. This image is a square
    %     % grid, and thus all spatial frequencies are definied with respect to
    %     % variable gridSize; if gridSize is 200, then a spatial frequency of 1 
    %     % corresponds to a wavelength of 200 pixels.
    %     % Noise is also added to the image to demonstrate how this filter responds
    %     % to unwanted high frequency artifacts.
    %     % Currently, the frequencies of all waves in this example are multiples of
    %     % 5; therefore, the filters I apply tend to center around 5. For example,
    %     % in order to isolate the circular wave with a spatial frequency of 25, I 
    %     % mark the lower frequency limit as 22 and the higher frequency limit as 
    %     % 28. You could narrow or widen this frequency band (e.g. 24 to 26 versus 
    %     % 21 to 29). If you are trying to isolate certain frequencies, there is an 
    %     % ideal frequency band that may take some trial and error to achieve.
    % 
    %     gridSize = 200;
    %     [X,Y] = meshgrid(0:gridSize-1,0:gridSize-1);
    % 
    %     % Create linear waves
    %     Y = flipud(Y);
    %     theta1 = 45;
    %     freq1 = 10;
    %     Amp1 = 10;
    %     theta2 = 90;
    %     freq2 = 15;
    %     Amp2 = 10;
    %     theta3 = -67;
    %     freq3 = 20;
    %     Amp3 = 10;
    % 
    %     linearWave = Amp1*cos((X*cos(theta1*pi/180)-Y*sin(theta1*pi/180))*2*pi/(gridSize/freq1))+1;
    %     linearWave = linearWave + Amp2*cos((X*cos(theta2*pi/180)-Y*sin(theta2*pi/180))*2*pi/(gridSize/freq2));
    %     linearWave = linearWave + Amp3*cos((X*cos(theta3*pi/180)-Y*sin(theta3*pi/180))*2*pi/(gridSize/freq3));
    % 
    %     % Create circular waves
    %     AmpCirc1 = 10;
    %     freqCirc1 = 5;
    %     centerCirc1 = [gridSize/2,gridSize/2];
    %     AmpCirc2 = 10;
    %     freqCirc2 = 25;
    %     centerCirc2 = [gridSize/2+15,gridSize/2];
    % 
    %     circularWave = AmpCirc1*cos(2*pi/(gridSize/freqCirc1)*sqrt((X-centerCirc1(1)).^2+(Y-centerCirc1(2)).^2));
    %     circularWave = circularWave + AmpCirc2*cos(2*pi/(gridSize/freqCirc2)*sqrt((X-centerCirc2(1)).^2+(Y-centerCirc2(2)).^2));
    % 
    %     % Superimpose all waves into image im_1
    %     im_1 = linearWave+circularWave;
    % 
    %     % Add noise
    %     im_1 = im_1 + randi([-10,10],gridSize);
    % 
    %     figure, imagesc(im_1);
    %     title('Original image - Superimposed waves with noise');
    %     figure, imagesc(hard_filter(im_1,0,8,false,1));
    %     title('Spatial frequencies between 0 and 8');
    %     figure, imagesc(hard_filter(im_1,8,12,false,1));
    %     title('Spatial frequencies between 8 and 12');
    %     figure, imagesc(hard_filter(im_1,12,18,false,1));
    %     title('Spatial frequencies between 12 and 18');
    %     figure, imagesc(hard_filter(im_1,18,22,false,1));
    %     title('Spatial frequencies between 18 and 22');
    %     figure, imagesc(hard_filter(im_1,22,28,false,1));
    %     title('Spatial frequencies between 22 and 28');
    %     figure, imagesc(hard_filter(im_1,0,28,false,1));
    %     title('All spatial frequencies below 28');
    %     figure, imagesc(hard_filter(im_1,28,inf,false,1));
    %     title('All spatial frequencies above 28');
    %
    %
    % Example 2:
    % 
    %     % Apply a hard filter to image 'trees.tif'.
    %     % Currently the lower frequency limit is set to 0 and the upper frequency 
    %     % limit is set to 10. Hence, this behaves as a lowpass filter with an upper
    %     % frequency threshold of 10 Hz. You can adjust this to behave as a bandpass
    %     % filter or highpass filter as well.
    %     % Since the dimensions of this image are not equivalent (more columns than
    %     % rows), a spatial frequency of 1 in the x-direction corresponds to a
    %     % wavelength of 350 pixels, whereas a spatial frequency of 1 in the
    %     % y-direction corresponds to a wavelength of 258 pixels. If you know the
    %     % physical dimensions of your image, you should utilize the 
    %     % y_over_x_scale_factor input variable. In this example, if a single pixel
    %     % represented the same amount of physical space in the x- and y-directions
    %     % (e.g. 1mm x 1mm), then the y_over_x_scale factor would be 258/350, since
    %     % the height of the image is 258 mm and the width of the image is 350 mm.
    %     % This ensures that the filter limits correspond to real spatial 
    %     % frequencies as opposed to spatial frequencies defined by the image 
    %     % boundaries.
    % 
    %     pic = imread('trees.tif');
    %     hard_filter(pic,0,10,true,1);
    %
    %
    % Evan Czako, 9.6.2019.
    % -------------------------------------------
    
    num_rows = size(im_1,1);
    num_cols = size(im_1,2);
    [X,Y] = meshgrid(1:num_cols,num_rows:-1:1);
    freq_domain = fft2(im_1);
    freq_domain_shifted=fftshift(freq_domain);
    freq_pass_window = zeros(size(im_1));
    freq_pass_window_center_x = floor(size(freq_pass_window,2)/2)+1;
    freq_pass_window_center_y = floor(size(freq_pass_window,1)/2)+1;
    for x = 1:num_cols
        for y = 1:num_rows
            if sqrt((x-freq_pass_window_center_x)^2+(y-freq_pass_window_center_y)^2/y_over_x_scale_factor^2) <= high_freq
                if low_freq <= sqrt((x-freq_pass_window_center_x)^2+(y-freq_pass_window_center_y)^2/y_over_x_scale_factor^2)

                    freq_pass_window(y,x) = 1;

                end
            end
        end
    end
    windowed_freq_domain_shifted = freq_domain_shifted.*freq_pass_window;
    adjusted_freq_domain = ifftshift(windowed_freq_domain_shifted);
    im_2 = ifft2(adjusted_freq_domain);
    
    if show_freq_domain
        figure, imagesc(im_1);
        title('Original image');
        figure, imagesc(freq_pass_window);
        title('Filter');
        figure, imagesc(log10(abs(freq_domain_shifted)));
        title('log_1_0(Original frequency domain)');
        figure, imagesc(log10(abs(windowed_freq_domain_shifted)));
        title('log_1_0(Filtered frequency domain)');
        figure, imagesc(abs(freq_domain_shifted));
        title('Original frequency domain');
        figure, imagesc(abs(windowed_freq_domain_shifted));
        title('Filtered frequency domain');
        figure, imagesc(im_2);
        title('Filtered image');
    end
    
end