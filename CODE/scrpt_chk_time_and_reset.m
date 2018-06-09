% scrpt_chk_time_and_reset

% every day at 2am - restart computer
if ( hour(now)==2 )
    fid = fopen('log.txt','at');
    fprintf(fid, 'shutdown at %s\n',datestr(now) );
    fclose(fid);
    
    system('shutdown -r');
end