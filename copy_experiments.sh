#!/bin/bash
set -ax
DRYRUN=""
orig_exp=$(basename $(pwd))
config_branches=$(git branch -a | grep config)
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

