% scrpt_chk_time_and_reset

% every day at 2am - restart computer
now_freeze = now;
if ( ( hour(now_freeze)==shutdown_time(1) ) && (minute(now_freeze)==shutdown_time(2)) && (second(now_freeze)<=shutdown_time(3)) )
    
    if ( shutdown_initiated_flg==false)
        fid = fopen('log.txt','at');
        fprintf(fid, 'shutdown at %s\n',datestr(now) );
        fclose(fid);
        
        shutdown_initiated_flg = true;
        system('shutdown -r');
    end
    
end