% scrpt_calibrate_interest_area_manual.m

new_img = get(h_prev,'CData');
new_img_gray = uint8( mean( new_img,3 ) );
margin_vert = 20;
margin_horiz = 30;

tolerance = 0.98;

figure()

im_threshold = new_img_gray > 50;
img_width = size( im_threshold,2 );
img_height = size( im_threshold,1 );

imshow(im_threshold);

x_left_border = -10;
x_right_border = 10;
y_up_border = -10;
y_bottom_border = 10;
rect_sum = 1;

text( round((img_width/2))+10 , round(img_height/2) , '1. Click Left upper corner & go clockwise' );


corners = ginput(4)
scatter(corners(:,1),corners(:,2),'r','+')

disp('Time to PARTY!!') %end of calibration

hold on

pause(2);
close(gcf);
% set(h_white_scrn,'Color','k');

% imshow(curr_rect)

% save('calibration_museum1.mat', 'x_left_border', 'x_right_border',...
%     'y_bottom_border', 'y_up_border','img_height', 'img_width');