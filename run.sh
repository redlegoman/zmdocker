set -x
docker run \
--name TEST \
--privileged=true  \
--stop-signal=SIGRTMIN+3 \
--tmpfs /run \
--tmpfs /run/lock \
-v /sys/fs/cgroup:/sys/fs/cgroup:ro \
-p=40022:22 \
-p=40080:80 \
-d redlegoman/zmdocker
