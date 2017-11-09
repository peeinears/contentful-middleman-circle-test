# Copy static site
CWD=`pwd`

# Clone Pages repository
cd /tmp
git clone git@github.com:peeinears/contentful-middleman-circle-test.git build

cd build && git checkout -b gh-pages origin/gh-pages # If not using master

# Trigger Middleman rebuild
cd $CWD
bundle exec middleman contentful --rebuild

# Push newly built repository
cp -r $CWD/build/* /tmp/build

cd /tmp/build

git config --global user.email "ian@ianpearce.org"
git config --global user.name "Ian Pearce"

git add .
git commit -m "Automated Rebuild"
git push -f origin gh-pages
