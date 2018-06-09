% scrpt_calibrate_interest_area2.m

new_img = get(h_prev,'CData');
new_img_gray = uint8( mean( new_img,3 ) );
margin = 5; % kill the misgeret of the white dgima in advance
tolerance = 0.999; % how much black pixels do we allow on the calibrted rectangle?
tolerancex = 0.999;
tolerancey = 0.999;

figure()

im_threshold = new_img_gray > 39; % threshold between black and white pixels
img_width = size( im_threshold,2 );
img_height = size( im_threshold,1 );


imshow(im_threshold);

x_left_border = -10;
x_right_border = 10;
y_up_border = -10;
y_bottom_border = 10;
rect_sum = 1;



while( rect_sum>=tolerancex);
    x_left_border = x_left_border-1;
    curr_rect = im_threshold( round(img_height/2)+[y_up_border:y_bottom_border] , round(img_width/2)+[x_left_border:x_right_border] );
    rect_sum = sum( curr_rect(:) )/length(curr_rect(:));
end
x_left_border = x_left_border+margin;
rect_sum = tolerancex;
disp('Ready');

while( rect_sum>=tolerancex);
    x_right_border = x_right_border+1;
    curr_rect = im_threshold( round(img_height/2)+[y_up_border:y_bottom_border] , round(img_width/2)+[x_left_border:x_right_border] );
    rect_sum = sum( curr_rect(:) )/length(curr_rect(:));
end
x_right_border = x_right_border-margin;
rect_sum = tolerancex;
disp('steady');

while( rect_sum>=tolerancey);
    y_up_border = y_up_border-1;
    curr_rect = im_threshold( round(img_height/2)+[y_up_border:y_bottom_border] , round(img_width/2)+[x_left_border:x_right_border] );
    rect_sum = sum( curr_rect(:) )/length(curr_rect(:));
end
y_up_border = y_up_border+margin;
rect_sum = tolerancey;
disp('go');


while( rect_sum>=tolerancey);
    y_bottom_border = y_bottom_border+1;
    curr_rect = im_threshold( round(img_height/2)+[y_up_border:y_bottom_border] , round(img_width/2)+[x_left_border:x_right_border] );
    rect_sum = sum( curr_rect(:) )/length(curr_rect(:));
end
y_bottom_border = y_bottom_border-margin;

rect_sum = tolerancey;

disp('Time to PARTY!!') %end of calibration


g=ginput(4);
y_up_border = g(1,2)-round(img_height/2);
x_right_border = g(2,1)-round(img_width/2);
y_bottom_border = g(3,2)-round(img_height/2);
x_left_border = g(4,1)-round(img_width/2);

% img_height 480, img_width 640, x_left_border -195, x_right_border 265,
% y_bottom_border 54, y_up_border -118


hold on
plot( round(img_width/2)+[x_left_border,x_right_border,x_left_border,x_right_border] , ...
    round(img_height/2)+[y_up_border,y_bottom_border,y_bottom_border,y_up_border] , 'or' );

pause(2);
button = questdlg('save this calibration?','save this calibration?','yep','nope mam','nope mam');
if ( strcmp( button,'yep' ) )
    save('calibration1.mat' , 'y_up_border', 'img_height', 'img_width', 'x_left_border', 'x_right_border',...
        'y_bottom_border');
end
close(gcf);
