#!/usr/bin/env bash

git clone https://github.com/dartchina/dartchina.github.io.git site
git config user.name "HaiJun Gu"
git config user.email "243297288@qq.com"
cd site && rm -rf * && cp -r ../_site/* .
touch CNAME
echo "www.dartdoc.cn" >> CNAME
git add --all .
git commit -m "Travis CI Auto Builder"
git push --force https://$DEPLOY_TOKEN@github.com/dartchina/dartchina.github.io.git master
