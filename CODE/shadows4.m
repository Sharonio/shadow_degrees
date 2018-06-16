%>>> check if preview window is open, if open close it.
fid = fopen('log.txt','at');
fprintf(fid, 'start at %s\n',datestr(now) );
fclose(fid);

if exist('vid','var')
    closepreview(vid);
end

%>>> Clear everything
close all; clc; clear

scaling_factor = 1;
now_val_date_vect = datevec(now);
% vid_out = VideoWriter( sprintf('.\\films\\%d_%d_%d_%d_%d_%d.avi',now_val_date_vect(1),now_val_date_vect(2),...
%     now_val_date_vect(3),now_val_date_vect(4),now_val_date_vect(5),...
%     round(now_val_date_vect(6)) ) ) ;
% open(vid_out);

% mode_array = { 'scrpt_mirror_shadow_code','scrpt_mirror_shadow_scaled_code',...
%     'scrpt_mirror_cartton_code','scrpt_mirror_shadow_all_scrn_code',...
%     'scrpt_white_shdw_all_scrn_code' };
mode_array = {'scrpt_mirror_shadow_upview_code' ,'scrpt_mirror_cartton_code', 'scrpt_white_shdw_all_scrn_code'}; %,'scrpt_mirror_shadow_all_scrn_code','scrpt_white_shdw_all_scrn_code' };
N_modes = length(mode_array);

%>>> Initialize camera and open preview window
vid = videoinput('winvideo', 1, 'YUY2_640x480');
src = getselectedsource(vid);
vid.FramesPerTrigger = 1;
h_prev = preview(vid);

%>>> Draw a white window. place it in the 'projector side'
h_white_scrn = figure;

% set(h_white_scrn,'Color','w','menubar','none','position',...
%     [      2000      1     1740        1058]);
set(h_white_scrn,'Color','w','menubar','none','position',...
    [1412           1        1896         994]);

% get(gcf,'position');
jFrame = undecorateFig(h_white_scrn);

axes
set(gca,'position',[0,0,1,1])
cur_xlim = get(gca,'xlim');
cur_ylim = get(gca,'ylim');

%>>> Pause 1 second to let the camera start working
pause(3);
scrpt_calibrate_interest_area;
% save('calibration_26_12.mat', 'x_left_border', 'x_right_border',...
%     'y_bottom_border', 'y_up_border','img_height', 'img_width');
load('calibration_26_12.mat');
% scrpt_calibrate_interest_area2

%>>> Draw a window with subplots for debugging purposes
debug_mode_flg = 0; % mark with '1' to draw this window
if (debug_mode_flg==1)
    h_shadow_maps = figure;
    set( h_shadow_maps , 'position' , [680,71,1202,907] );
    h1 = subplot(4,2,1);
    h2 = subplot(4,2,2);
    h3 = subplot(4,2,3);
    h4 = subplot(4,2,4);
    h5 = subplot(4,2,[5,6,7,8]);
end

%% the loop
k = 0;
N_sec_per_mode = 20;
try
    
    while(1)
        k=k+1;
        script_to_run_in_loop = mode_array{ mod(round(k/(N_sec_per_mode*25)),N_modes)+1 }; % 100 is 4 sec
        
        %     script_to_run_in_loop = mode_array{2};
        
        run( script_to_run_in_loop );
        drawnow
        %scrp_video_recorder;
        
        scrpt_chk_time_and_reset;
    end
catch ME
    fid = fopen('log.txt','at');
    fprintf(fid, 'Stopped due to error! %s , %s\n',datestr(now) , ME.identifier );
    fclose(fid);
    
    %     setpref('Internet','SMTP_Server','myserver.myhost.com');
    %     sendmail('oriansharoni@gmail.com',sprintf('Stopped due to error! %s , %s\n',datestr(now) , ME.identifier ));
    
    stoppreview(vid);
    %    close(vid_out);
    disp('catched');
end

