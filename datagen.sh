#! /bin/bash

cd $HOME/tpcds-kit/tools
./dsdgen -scale 150 -dir /home/ec2-user/tpcds -parallel 8 -child 1 &
./dsdgen -scale 150 -dir /home/ec2-user/tpcds -parallel 8 -child 2 &
./dsdgen -scale 150 -dir /home/ec2-user/tpcds -parallel 8 -child 3 &
./dsdgen -scale 150 -dir /home/ec2-user/tpcds -parallel 8 -child 4 &
./dsdgen -scale 150 -dir /home/ec2-user/tpcds -parallel 8 -child 5 &
./dsdgen -scale 150 -dir /home/ec2-user/tpcds -parallel 8 -child 6 &
./dsdgen -scale 150 -dir /home/ec2-user/tpcds -parallel 8 -child 7 &
./dsdgen -scale 150 -dir /home/ec2-user/tpcds -parallel 8 -child 8 &
