CURRENT_BRANCH=$(git branch | grep \* | cut -d ' ' -f2)
FROM_VERSION=$1

if [[ $FROM_VERSION == "" ]]
 then
 echo "Upgrade from version not specified"
 exit 1
fi

echo "Building branch ${CURRENT_BRANCH}"
echo "Upgrade from version ${FROM_VERSION}"

mix edeliver build upgrade --with=${FROM_VERSION} --branch=${CURRENT_BRANCH}
mix edeliver deploy upgrade to production
