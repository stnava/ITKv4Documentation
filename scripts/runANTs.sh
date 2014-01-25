#!/bin/bash
n1=$1
n2=$2
FV=brains/brain${n1}.nii.gz
MV=brains/brain${n2}.nii.gz
FVL=segs/${n1}_seg_83ROI.nii.gz
MVL=segs/${n2}_seg_83ROI.nii.gz
if [[ -s $FV ]] && [[ -s $MV ]] && [[ -s $FVL ]] && [[ -s $FVL ]] ; then
  ONM=eval/ants${n2}to${n1}
  RESAMPLEWARP=${ONM}antslab.nii.gz
  if [[ ! -s ${RESAMPLEWARP} ]] ; then
      time ./antsRegistrationSyN.sh -d 3 -f $FV -m $MV -o ${ONM} -n 4 
  fi
  antsApplyTransforms -d 3 -i $MVL -o ${RESAMPLEWARP} -t ${ONM}1Warp.nii.gz -t ${ONM}0GenericAffine.mat -r $FV -n NearestNeighbor
  LabelOverlapMeasures 3 $FVL ${RESAMPLEWARP} 1 > ${ONM}.csv
  echo compare $FVL ${RESAMPLEWARP} ${ONM}.csv
  rm temp.nii.gz
else 
  echo this pair does not exist $n1 and $n2
fi
