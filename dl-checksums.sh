#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://dagger-io.s3.amazonaws.com/dagger/releases

dl() {
    local ver=$1
    local lchecksums=$2
    local os=$3
    local arch=$4
    local archive_type=${5:-tar.gz}
    local platform="${os}_${arch}"
    local file="dagger_v${ver}_${platform}.${archive_type}"
    local url=$MIRROR/$ver/$file
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(grep -e "$file\$" $lchecksums | awk '{print $1}')
}

dl_ver() {
    local ver=$1
    local url=$MIRROR/$ver/checksums.txt
    local lchecksums=$DIR/dagger-${ver}-checksums.txt
    if [ ! -e $lchecksums ];
    then
        curl -sSLf -o $lchecksums $url
    fi

    printf "  # %s\n" $url
    printf "  '%s':\n" $ver

    dl $ver $lchecksums darwin amd64
    dl $ver $lchecksums darwin arm64
    dl $ver $lchecksums linux amd64
    dl $ver $lchecksums linux armv7
    dl $ver $lchecksums linux arm64
    dl $ver $lchecksums windows arm64 zip
    dl $ver $lchecksums windows armv7 zip
    dl $ver $lchecksums windows amd64 zip
}

dl_ver 0.8.5
dl_ver ${1:-0.8.7}
