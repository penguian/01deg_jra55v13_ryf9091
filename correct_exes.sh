#!/bin/bash
set -eux
DRYRUN=""
access_om2_dir=${1:-$ACCESS_OM2_DIR}
if [ ! -d "$access_om2_dir" ]
then
  echo "Directory ${access_om2_dir} not found"
  exit 1
fi
bin_dir=${access_om2_dir}/bin
yatm_exe=$(ls ${bin_dir}/yatm_*.exe | cut -d' ' -f1)
fms_exe=$(ls ${bin_dir}/fms_*.x | cut -d' ' -f1)
combine_exe=$(ls ${bin_dir}/mppnccombine)
base_exp=$(pwd);
experiments=$(cd ..;ls -d ${base_exp}.*.*.*)
for exp in $experiments
do 
  pushd $exp
  cice_config=$(basename $(pwd) | cut -d'.' -f 4)
  cice_exe=$(ls ${bin_dir}/cice_auscom_${cice_config}_3600x2700_*p.exe)
  for config_yaml in config.yaml*
  do
    $DRYRUN sed -i "s#exe: .*bin/yatm.*.exe#exe: ${yatm_exe}#;s#exe: .*/bin/fms.*.x#exe: ${fms_exe}#;s#exe: .*/bin/cice_auscom.*.exe#exe: ${cice_exe}#;s#exe: .*bin/mppnccombine#exe: ${combine_exe}#" $config_yaml
    grep "exe:" $config_yaml
  done
  popd
done 
