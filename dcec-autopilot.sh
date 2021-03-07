#/bin/bash
WORKING_DIRECTORY=/home/ubuntu
SET_ENVIRONMENT_VARIABLES_FILE=/home/ubuntu/set-environment-variables.sh
#
cd $WORKING_DIRECTORY
. $SET_ENVIRONMENT_VARIABLES_FILE
tmux new-session -s terraform
git clone https://github.com/f5devcentral/f5-digital-customer-engagement-center
cd f5-digital-customer-engagement-center/solutions/delivery/application_delivery_controller/nginx/kic/aws
#Replace setup.sh file.
curl -O https://raw.githubusercontent.com/TonyMarfil/dcec-autopilot/main/setup.sh
#Invoke setup.sh file non-interactively. Record
. ./setup.sh non-interactive |& tee setup.log
if [ $? -eq 0 ]
then
  echo "The script ran ok" > $WORKING_DIRECTORY/success.log
else
  echo "The script failed" > $WORKING_DIRECTORY/failure.log
fi
