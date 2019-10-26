mix edeliver stop production
ssh jarmotion << EOF
rm -rf ./app_build
rm -rf ./app_release
EOF
