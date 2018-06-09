% scrp_video_recorder


cur_xlim = get(gca,'xlim');
cur_ylim = get(gca,'ylim');

%>>><<<
curr_xlimm = get(gca,'XLim');
curr_ylimm = get(gca,'YLim');
pizza_x_center = curr_xlimm(1) + 0.05*diff(curr_xlimm);
pizza_y_center = curr_ylimm(1) + 0.1*diff(curr_ylimm);
pizza_r = 10;
x_coeff = 1.1;
alpha =   2*pi-    2*pi*(  0.5+mod((k/(N_sec_per_mode*25)),N_modes) -...
round(mod((k/(N_sec_per_mode*25)),N_modes)));

pizza_x_contour = pizza_r * x_coeff * cos( linspace(0,alpha,20) );
pizza_y_contour = pizza_r * sin( linspace(0,alpha,20) );
 
hold on
h_p = patch( pizza_x_center + [0,pizza_x_contour,0] ,...
    pizza_y_center+[0,pizza_y_contour,0] , 0.5*[1,1,1] );
% set(h_p,'FaceAlpha',0.5)
hold off
drawnow
%>>>><<<

now_val_date_vect = datevec(now);

if (length(dir('rec.txt'))==1)
% if ( (now_val_date_vect(5)>=30) && ( now_val_date_vect(5) <=40 ) )
    writeVideo(vid_out,new_img);
end