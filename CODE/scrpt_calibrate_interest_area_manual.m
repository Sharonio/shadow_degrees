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

text( round((img_width/2))+10 , round(img_height/2) , '1' );
text( round((img_width/2)) , round(img_height/2)+10 , '2' );
text( round((img_width/2))-10 , round(img_height/2) , '3' );
text( round((img_width/2)) , round(img_height/2)-10 , '4' );

g = ginput(1);
x_right_border = g(1) - round(img_width/2);
g = ginput(1);
y_bottom_border=g(2) - round(img_height/2);
g = ginput(1);
x_left_border=g(1) - round(img_width/2);
g = ginput(1);
y_up_border =g(2) - round(img_height/2);
% while( rect_sum>=tolerance);
%     y_up_border = y_up_border-1;
%     curr_rect = im_threshold( round(img_height/2)+[y_up_border:y_bottom_border] , round(img_width/2)+[x_left_border:x_right_border] );
%     rect_sum = sum( curr_rect(:) )/length(curr_rect(:));
% end
% y_up_border = y_up_border+margin_vert;
% rect_sum = tolerance;
% disp('go');
% 
% 
% while( rect_sum>=tolerance);
%     y_bottom_border = y_bottom_border+1;
%     curr_rect = im_threshold( round(img_height/2)+[y_up_border:y_bottom_border] , round(img_width/2)+[x_left_border:x_right_border] );
%     rect_sum = sum( curr_rect(:) )/length(curr_rect(:));
% end
% y_bottom_border = y_bottom_border-margin_vert;
% % y_bottom_border = y_bottom_border-50;
% % y_bottom_border = y_bottom_border+50;
% rect_sum = tolerance;
% 
% while( rect_sum>=tolerance);
%     x_left_border = x_left_border-1;
%     curr_rect = im_threshold( round(img_height/2)+[y_up_border:y_bottom_border] , round(img_width/2)+[x_left_border:x_right_border] );
%     rect_sum = sum( curr_rect(:) )/length(curr_rect(:));
% end
% x_left_border = x_left_border+margin_horiz;
% rect_sum = tolerance;
% disp('Ready');
% 
% while( rect_sum>=tolerance);
%     x_right_border = x_right_border+1;
%     curr_rect = im_threshold( round(img_height/2)+[y_up_border:y_bottom_border] , round(img_width/2)+[x_left_border:x_right_border] );
%     rect_sum = sum( curr_rect(:) )/length(curr_rect(:));
% end
% x_right_border = x_right_border-margin_horiz;
% rect_sum = tolerance;
% disp('steady');



disp('Time to PARTY!!') %end of calibration

hold on
plot( round(img_width/2)+[x_left_border,x_right_border,x_left_border,x_right_border] , ...
    round(img_height/2)+[y_up_border,y_bottom_border,y_bottom_border,y_up_border] , 'or' );

pause(2);
close(gcf);
% set(h_white_scrn,'Color','k');

% imshow(curr_rect)


% save('calibration_museum1.mat', 'x_left_border', 'x_right_border',...
%     'y_bottom_border', 'y_up_border','img_height', 'img_width');