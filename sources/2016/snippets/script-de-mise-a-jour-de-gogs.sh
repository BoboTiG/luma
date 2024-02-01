#!/bin/bash
#
# https://gogs.io/docs/upgrade/upgrade_from_binary
#
set -e

usage() {
    echo 'À exécuter en tant que root !'
    echo "$0 VERSION"
    echo "$0 0.13.0"
    exit 1
}

main() {
    local new_version="$1"
    local fname="gogs_${new_version}_linux_armv7.zip"
    local output="${fname}-${new_version}"
    local url="https://github.com/gogs/gogs/releases/download/v${new_version}/${fname}"
    local today
    local su='/bin/su - git -c'

    today="$(/bin/date '+%Y-%m-%d_%H')"

    cd /home/git
    /usr/sbin/service gogs stop
    $su "/usr/bin/wget ${url} -O ${output}"
    [ -d gogs ] && $su "/bin/mv gogs gogs_${today}"
    $su "/usr/bin/unzip ${output}"
    $su "/bin/cp -Rv gogs_${today}/custom gogs"
    $su "/bin/cp -Rv gogs_${today}/data gogs"
    $su "/bin/cp -Rv gogs_${today}/log gogs"
    /usr/sbin/service gogs start
}

[ $EUID -eq 0 ] || usage
[ -z "$1" ] && usage

main "$@"


chmod a+x update-gogs.sh
./update-gogs.sh "0.13.0"
