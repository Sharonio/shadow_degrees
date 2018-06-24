%>>> check if preview window is open, if open close it.
fid = fopen('log.csv','at');
fprintf(fid, 'wakeup,%s\n',datestr(now) );
fclose(fid);

if exist('vid','var')
    closepreview(vid);
end

%>>> Clear everything
close all; clc; clear

% >>> autoshutdown and time-log related
shutdown_time = [02,02,02]; % hours,minutes, smaller than seconds
shutdown_initiated_flg = false;
alive_log_period_min = 15;
last_time_alive_log_written = now - alive_log_period_min/(24*60);

% >>> Loop related
N_sec_per_mode = 25;
last_time_mode_changed = now;
show_ghost_flg = 1;

% >>> Others
scaling_factor = 1;
now_val_date_vect = datevec(now);
person_detect_log_period_min = 1;
last_time_person_detect_log_written = now - person_detect_log_period_min/(24*60);

% >>> Person detectiopn related
person_detection_threshold = 0.05;
person_detection_flg = false;

% % time_from_last_person_detection


% vid_out = VideoWriter( sprintf('.\\films\\%d_%d_%d_%d_%d_%d.avi',now_val_date_vect(1),now_val_date_vect(2),...
%     now_val_date_vect(3),now_val_date_vect(4),now_val_date_vect(5),...
%     round(now_val_date_vect(6)) ) ) ;
% open(vid_out);

% mode_array = { 'scrpt_mirror_shadow_code','scrpt_mirror_shadow_scaled_code',...
%     'scrpt_mirror_cartton_code','scrpt_mirror_shadow_all_scrn_code',...
%     'scrpt_white_shdw_all_scrn_code' };
% mode_array = {'scrpt_mirror_shadow_upview_code' ,'scrpt_mirror_cartton_code'}; %, 'scrpt_white_shdw_all_scrn_code'}; %,'scrpt_mirror_shadow_all_scrn_code','scrpt_white_shdw_all_scrn_code' };
mode_array = {'scrpt_mirror_cartton_code_trapeze' ,'scrpt_mirror_cartton_code', 'scrpt_mirror_shadow_code_trapeze', 'scrpt_mirror_shadow_code'};


% mode_array = {'scrpt_mirror_cartton_code' ,'scrpt_mirror_cartton_code'}; %, 'scrpt_white_shdw_all_scrn_code'}; %,'scrpt_mirror_shadow_all_scrn_code','scrpt_white_shdw_all_scrn_code' };

N_modes = length(mode_array);

%>>> Initialize camera and open preview window
% vid = videoinput('winvideo', 1, 'YUY2_640x480');
% vid = videoinput('winvideo', 1, 'RGB24_640x480');

vid = videoinput('winvideo', 1, 'RGB24_800x600');
% vid = videoinput('winvideo', 1, 'RGB24_960x720');
% vid = videoinput('winvideo', 1, 'RGB24_1920x1080');

src = getselectedsource(vid);

src.BacklightCompensation = 'off';
src.ExposureMode = 'manual';
src.FocusMode = 'manual';
src.Focus = 0;
src.WhiteBalanceMode = 'manual';
src.Zoom = 100;


vid.FramesPerTrigger = 1;
h_prev = preview(vid);

%>>> Draw a white window. place it in the 'projector side'
h_white_scrn = figure;

% set(h_white_scrn,'Color','w','menubar','none','position',...
%     [      2000      1     1740        1058]);
set(h_white_scrn,'Color','w','menubar','none','position',...
    [       -1922         226        1270         800]);

% get(gcf,'position')
jFrame = undecorateFig(h_white_scrn);

axes
set(gca,'position',[0,0,1,1])
cur_xlim = get(gca,'xlim');
cur_ylim = get(gca,'ylim');

%>>> Pause 1 second to let the camera start working
pause(2);
% scrpt_calibrate_interest_area_manual;
% scrpt_calibrate_interest_area;
% scrpt_calibrate_interest_area_museum
% save('calibration_museum_trapeze.mat', corners);
load('calibration_museum_trapeze.mat');

% save('calibration_museum2.mat', 'x_left_border', 'x_right_border',...
%     'y_bottom_border', 'y_up_border','img_height', 'img_width');
load('calibration_museum1.mat');
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

try
    
    while(1)
        
        if ( ((now-last_time_mode_changed)*24*60*60) > N_sec_per_mode )
            k=mod(k+1,N_modes);
            last_time_mode_changed = now;
        end
        
        script_to_run_in_loop = mode_array{ k+1 };
        
%         script_to_run_in_loop = mode_array{ mod(round(k/(N_sec_per_mode*25)),N_modes)+1 }; % 100 is 4 sec
        
        %     script_to_run_in_loop = mode_array{2};
        
        run( script_to_run_in_loop );
        drawnow
        %scrp_video_recorder;
        
        scrpt_chk_time_and_reset;
    end
catch ME
    fid = fopen('log.csv','at');
    fprintf(fid, 'Stopped,%s,%s\n',datestr(now) , ME.identifier );
    fclose(fid);
    
    %     setpref('Internet','SMTP_Server','myserver.myhost.com');
    %     sendmail('oriansharoni@gmail.com',sprintf('Stopped due to error! %s , %s\n',datestr(now) , ME.identifier ));
    
    stoppreview(vid);
    %    close(vid_out);
    disp('catched');
end

