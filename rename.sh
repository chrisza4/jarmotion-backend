CURRENT_OTP=jarmotion_backend
CURRENT_NAME=JarmotionBackend
NEW_OTP=jarmotion
NEW_NAME=Jarmotion
git grep -l $CURRENT_OTP | xargs sed -i '' -e "s/$CURRENT_OTP/$NEW_OTP/g"
git grep -l $CURRENT_NAME | xargs sed -i '' -e "s/$CURRENT_NAME/$NEW_NAME/g"

mv lib/$CURRENT_OTP lib/$NEW_OTP
mv lib/$CURRENT_OTP.ex lib/$NEW_OTP.ex
