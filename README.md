
This image should run zoneminder 1.30 out of the box. Seperate volumes have been configured for the mysql and zoneminder config so they are persistent. I have also changed values in the db so the ffmpeg and cgi-bin are correct, aswell as a couple of other values I always like to change. The OS root password is "root" and the mysql root password is also "root". SSH is enabled and root logins are allowed.
php.ini has the timezone of "Europe/London". You might want to change that or your timeline dates will be out. Unless you're in the London timezone of course.


Run the image using this command line:


  docker run \ 
  --privileged=true \ 
  --stop-signal=SIGRTMIN+3 \ 
  --tmpfs /run \ 
  --tmpfs /run/lock \ 
  -v /sys/fs/cgroup:/sys/fs/cgroup:ro \ 
  -p=40022:22 \ 
  -p=40080:80 \ 
  -d redlegoman/zmdocker



Change the ports of drop the 22 (ssh) as you see fit.
