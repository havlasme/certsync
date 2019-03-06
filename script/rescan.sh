#!/bin/bash

set -o errexit
set -o nounset
shopt -s nullglob

function _rescan_main() {
    local dist="$1"; shift
    local release

    if [[ ! -f "${dist}/generate" ]]; then
        echo "no distribution (${dist}) configuration"
        exit 1
    fi

    mkdir -p cache

    apt-ftparchive generate "${dist}/generate"

    for release in "./${dist}/release/"*; do
        release="$(basename "$release")"

        apt-ftparchive -c "./${dist}/release/${release}" release "public/${dist}/dists/${release}" > "public/${dist}/dists/${release}/Release"
        rm "public/${dist}/dists/${release}/Release.gpg"; gpg --output "public/${dist}/dists/${release}/Release.gpg" -ba "public/${dist}/dists/${release}/Release"
        rm "public/${dist}/dists/${release}/InRelease"; gpg --output "public/${dist}/dists/${release}/InRelease" --clearsign "public/${dist}/dists/${release}/Release"
    done
}

_rescan_main "$@"
