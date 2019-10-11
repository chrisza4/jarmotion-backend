ssh jarmotion << EOF
source ./env.sh
cd jarmotion-backend
git reset --hard
git pull
chmod u+x ./deployments/restart_and_deploy.sh
./deployments/restart_and_deploy.sh
EOF
