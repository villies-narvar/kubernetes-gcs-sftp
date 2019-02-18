#!/bin/bash

runuser -l user1 -c 'gcsfuse -o nonempty --only-dir user1 sftp-villies-test-inbound /home/user1/inbound'
runuser -l user1 -c 'gcsfuse -o nonempty --only-dir user1 sftp-villies-test-outbound /home/user1/outbound'

runuser -l user2 -c 'gcsfuse -o nonempty --only-dir user2 sftp-villies-test-inbound /home/user2/inbound'
runuser -l user2 -c 'gcsfuse -o nonempty --only-dir user2 sftp-villies-test-outbound /home/user2/outbound'
