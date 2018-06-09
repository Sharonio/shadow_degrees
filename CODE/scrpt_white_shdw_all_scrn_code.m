% scrpt_mirror_shadow_code

%%>>> get new image from preview window
new_img = get(h_prev,'CData');
new_img_gray = uint8( mean( new_img,3 ) );
if (debug_mode_flg==1)
    figure(h_shadow_maps)
    subplot(h1);
    imshow(new_img_gray);
end

%%>>> cut only the interesting area from what the camera sees
interest_area_img = new_img_gray(  round(img_height/2)+[y_up_border:y_bottom_border] , round(img_width/2)+[x_left_border:x_right_border] );
if (debug_mode_flg==1)
    subplot(h2);
    imshow(interest_area_img);
end

%%>>> Perform edge detection using the Sobel method
[~, threshold] = edge(interest_area_img, 'sobel');
fudgeFactor = 0.9;
BWs = edge(interest_area_img,'sobel', threshold * fudgeFactor);
if (debug_mode_flg==1)
    subplot(h1);
    imshow(BWs);
end

%%>> Make lines in the image fat using strel
se90 = strel('line', 2, 90);
se0 = strel('line', 2, 0);
BWsdil = imdilate(BWs, [se90 se0]);
if (debug_mode_flg==1)
    subplot(h2);
    imshow(BWsdil);
end

%%>> put a frame on the image border to make shadows at bottom 'valid
%  holes'
borderLineImage= BWsdil;
borderLineImage(end,:) = 1;
borderLineImage(:,end) = 1;
borderLineImage(:,1) = 1;
if (debug_mode_flg==1)
    subplot(h3);
    imshow(borderLineImage);
end

%%>> Fill holes. holes are black spots not touching the border
BWdfill = imfill(borderLineImage, 'holes'); % fills all blacks in white
if (debug_mode_flg==1)
    subplot(h4);
    imshow(BWdfill);
end

%%>> Delete the frame on the border we added
Image_no_border= BWdfill;
Image_no_border(end,:) = 0;
Image_no_border(:,end) = 0;
Image_no_border(:,1) = 0;
if (debug_mode_flg==1)
    subplot(h5);
    imshow(Image_no_border);
end

%%>> Skipping a step that cleans the image border (?)
BWnobord = Image_no_border;
%     BWnobord = imclearborder(BWdfill, 4);
%     subplot(h5);
%     imshow(BWnobord);

seD = strel('diamond',1);
BWfinal = imerode(BWnobord,seD);

if (debug_mode_flg==1)
    subplot(h5);
    imshow(BWfinal)
end

%%>> inverting the image, changing the color range from 0-1 to 0-255,
%%converting to uint8 - all this in order to use image command insted
%%of imshow.
tmp = uint8((1-BWfinal)*255);
im_to_show = 255*ones( size(tmp),'uint8' );

%>> mirror all right side to left side of the image
halfImage=ceil(size(interest_area_img, 2)/2);
middle_fixing = 3;
% im_to_show( : , 1:(halfImage-middle_fixing)) = tmp( : , end:-1:(end-(halfImage-middle_fixing)+1));
im_to_show( : , :) = tmp( : , end:-1:1);

if (debug_mode_flg==1)
    subplot(h5);
    image(im_to_show);
    colormap(gray);
end

% if mod(k, 100)==0
%     im_to_show=ones(size(im_to_show), 'uint8');
% end

%>> Print it on the "progector side" window
figure(h_white_scrn)
image( im_to_show );
colormap(gray);
axis off

cur_xlim = get(gca,'xlim');
cur_ylim = get(gca,'ylim');

xlim( mean(cur_xlim) + 1.0*(cur_xlim-mean(cur_xlim))  );
ylim( mean(cur_ylim) + 1.0*(cur_ylim-mean(cur_ylim))  );


% drawnow