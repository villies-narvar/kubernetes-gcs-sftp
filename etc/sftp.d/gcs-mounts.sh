#!/bin/bash
# File mounted as: /etc/sftp.d/mount_user_directories.sh

runuser -l user1 -c 'gcsfuse -o nonempty --only-dir user1 sftp-villies-test /home/user1/ftp'

runuser -l user2 -c 'gcsfuse -o nonempty --only-dir user2 sftp-villies-test /home/user2/ftp'
