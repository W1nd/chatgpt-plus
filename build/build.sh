#!/bin/bash

version=$1
arch=${2:-amd64}

# build go api program
cd api
make clean $arch

cd ..

# build web app
cd web
npm run build
cd ..

# build docker images
cd build

# remove docker image if exists
docker rmi -f w1ndw/chatgpt-plus-api-go:$version-$arch
# build docker image for chatgpt-plus-go
docker build -t w1ndw/chatgpt-plus-api-go:$version-$arch -f dockerfile-api-go ../

# build docker image for chatgpt-plus-vue
docker rmi -f w1ndw/chatgpt-plus-vue:$version-$arch
docker build --platform linux/amd64 -t w1ndw/chatgpt-plus-vue:$version-$arch -f dockerfile-vue ../

if [ "$3" = "push" ];then
  docker push w1ndw/chatgpt-plus-api-go:$version-$arch
  docker push w1ndw/chatgpt-plus-vue:$version-$arch
fi
