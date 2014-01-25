#!/bin/bash
#
export BINDIR=/Users/stnava/code/BRAINSTools-build/bin/
#
n1=$1
n2=$2
FV=brains/brain${n1}.nii.gz
MV=brains/brain${n2}.nii.gz
FVL=segs/${n1}_seg_83ROI.nii.gz
MVL=segs/${n2}_seg_83ROI.nii.gz
if [[ -s $FV ]] && [[ -s $MV ]] && [[ -s $FVL ]] && [[ -s $FVL ]] ; then
  ONM=eval/bfit${n2}to${n1}
  TRANSFORM=${ONM}.mat
  FITWARP=${ONM}.nii.gz
  RESAMPLEWARP=${ONM}bfitlab.nii.gz
  if [[ ! -s ${RESAMPLEWARP} ]] ; then
      time ${BINDIR}/BRAINSFit \
	  --costMetric MMI \
	  --fixedVolume ${FV}  \
	  --movingVolume ${MV}  \
	  --maskProcessingMode ROIAUTO \
	  --ROIAutoDilateSize 3 \
	  --numberOfSamples 500000  \
	  --numberOfIterations 1500 \
	  --numberOfHistogramBins 128 \
	  --minimumStepLength 0.0025,0.0025,0.0025,0.0025,0.00025 \
	  --transformType Rigid,ScaleVersor3D,ScaleSkewVersor3D,Affine,BSpline \
	  --maxBSplineDisplacement 20 \
	  --initializeTransformMode useCenterOfHeadAlign  \
	  --maskInferiorCutOffFromCenter 65  \
	  --splineGridSize 20,20,20 \
	  --outputTransform ${TRANSFORM} \
	  --outputVolume ${FITWARP}
  fi
  ${BINDIR}/BRAINSResample \
      --inputVolume ${MVL} \
      --referenceVolume ${FV} \
      --outputVolume ${RESAMPLEWARP} \
      --pixelType uchar \
      --interpolationMode NearestNeighbor \
      --warpTransform ${TRANSFORM}
  LabelOverlapMeasures 3 $FVL ${RESAMPLEWARP} 1 > ${ONM}.csv
else 
  echo this pair does not exist $n1 and $n2
fi

