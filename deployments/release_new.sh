CURRENT_BRANCH=$(git branch | grep \* | cut -d ' ' -f2)
echo "Building branch ${CURRENT_BRANCH}"
mix edeliver build release --branch=${CURRENT_BRANCH} --skip-mix-clean --skip-git-clean
mix edeliver deploy release to production
mix edeliver stop production
mix edeliver start production
