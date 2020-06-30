#!/bin/bash
set -eux
if [ -d "$ACCESS_OM2_DIR" ]
then
  default_archive_dir=$(cd "$ACCESS_OM2_DIR/../archive"; pwd)
else
  default_archive_dir=$(cd "../../../archive"; pwd)
fi
archive_dir=${1:-$default_archive_dir}
DRYRUN=""
orig_exp=$(basename $(pwd))
orig_branch=$(git branch | grep '*' | cut -d' ' -f2)
config_branches=$(git branch -a | grep config)
$DRYRUN ln -s -f $archive_dir archive
for branch in $config_branches
do 
  config=$(basename $branch)
  copy_exp=${config/config/$orig_exp}
  $DRYRUN rm -rf ../$copy_exp
  $DRYRUN cp -a . ../$copy_exp
  $DRYRUN pushd ../$copy_exp
    $DRYRUN git checkout $branch
  $DRYRUN popd
done
$DRYRUN git checkout $orig_branch
