its=200x200x200
if [[ 1 == 0 ]] ; then
rm logx1s.txt
dim=2
ImageMath 2 r64neg.nii.gz Neg r64slice.nii.gz
f=r16slice.nii.gz ; m=r64neg.nii.gz 
antsRegistration -d $dim  \
                        -m mi[  $f, $m , 1 , 20, Random , 0.05 ] \
                         -t affine[ 1.0 ] \
                         -i 2100x1200x1200x50  \
                        -s 3x2x1x0  \
                        -f 4x3x2x1 \
                        -m cc[  $f, $m , 1, 4 ] \
                         -t syn[ 0.25, 3, 0.0 ] \
                         -i 100x100x50  \
                        -s 2x1x0  \
                        -f 3x2x1 \
                       -u 1 \
                       -o [xtest_CC,xtest_CC.nii.gz,xtest_CC_inv.nii.gz] 

antsRegistration -d $dim  \
                        -m mi[  $f, $m , 1 , 20, Random , 0.05 ] \
                         -t affine[ 1.0 ] \
                         -i 2100x1200x1200x50  \
                        -s 3x2x1x0  \
                        -f 4x3x2x1 \
                        -m mi[  $f, $m , 1, 20 ] \
                         -t syn[ 0.25, 3, 0.0 ] \
                         -i 100x100x50  \
                        -s 2x1x0  \
                        -f 3x2x1 \
                       -u 1 \
                       -o [xtest_MI,xtest_MI.nii.gz,xtest_MI_inv.nii.gz] 

f=r16slice.nii.gz ; m=r64slice.nii.gz 
antsRegistration -d $dim  \
                        -m mi[  $f, $m , 1 , 20, Random , 0.05 ] \
                         -t affine[ 1.0 ] \
                         -i 2100x1200x1200x50  \
                        -s 3x2x1x0  \
                        -f 4x3x2x1 \
                        -m MeanSquares[  $f, $m , 1, 0 ] \
                         -t syn[ 0.25, 3, 0.0 ] \
                         -i 100x100x50  \
                        -s 2x1x0  \
                        -f 3x2x1 \
                       -u 1 \
                       -o [xtest_MSQ,xtest_MSQ.nii.gz,xtest_MSQ_inv.nii.gz] 

CreateWarpedGridImage 2 xtest_MSQ1Warp.nii.gz xtest_MSQ_grid.nii.gz 1x1 10x10 9x9 
CreateWarpedGridImage 2 xtest_MI1Warp.nii.gz xtest_MI_grid.nii.gz 1x1 10x10 9x9 
CreateWarpedGridImage 2 xtest_CC1Warp.nii.gz xtest_CC_grid.nii.gz 1x1 10x10 9x9 
ImageMath 2 xtest_CCn.nii.gz Neg xtest_CC.nii.gz
ImageMath 2 xtest_MIn.nii.gz Neg xtest_MI.nii.gz
ThresholdImage 2 r16slice.nii.gz mask.nii.gz 1  999 
MultiplyImages 2  xtest_MIn.nii.gz mask.nii.gz xtest_MIn.nii.gz
MultiplyImages 2  xtest_CCn.nii.gz mask.nii.gz xtest_CCn.nii.gz

f=r16slice.nii.gz
for sim in 0 1 2 ; do 
MeasureImageSimilarity 2 $sim $f xtest_MSQ.nii.gz logx1.txt
MeasureImageSimilarity 2 $sim $f xtest_CCn.nii.gz logx1.txt
MeasureImageSimilarity 2 $sim $f xtest_MIn.nii.gz logx1.txt
done

fi

rm logx.txt dice*
dim=2
ImageMath 2 r64neg.nii.gz Neg r64slice.nii.gz
f=r16slice.nii.gz ; m=r64neg.nii.gz 
antsRegistration -d $dim  \
                        -m gc[  $f, $m , 1 , 0, Random , 0.05 ] \
                         -t affine[ 1.0 ] \
                         -i 2100x1200x1200x50  \
                        -s 3x2x1x0  \
                        -f 4x3x2x1 \
                        -m cc[  $f, $m , 1, 4 ] \
                         -t syn[ 0.25, 3, 0.0 ] \
                         -i  $its  \
                        -s 2x1x0  \
                        -f 3x2x1 \
                       -u 1 \
                       -o [xtest_CC,xtest_CC.nii.gz,xtest_CC_inv.nii.gz] 

antsRegistration -d $dim  \
                        -m mi[  $f, $m , 1 , 20, Random , 0.05 ] \
                         -t affine[ 1.0 ] \
                         -i 2100x1200x1200x50  \
                        -s 3x2x1x0  \
                        -f 4x3x2x1 \
                        -m mi[  $f, $m , 1, 20 ] \
                         -t syn[ 0.25, 3, 0.0 ] \
                         -i  $its  \
                        -s 2x1x0  \
                        -f 3x2x1 \
                       -u 1 \
                       -o [xtest_MI,xtest_MI.nii.gz,xtest_MI_inv.nii.gz] 

f=r16slice.nii.gz ; m=r64slice.nii.gz 
antsRegistration -d $dim  \
                        -m MeanSquares[  $f, $m , 1 , 0, Random , 0.05 ] \
                         -t affine[ 1.0 ] \
                         -i 2100x1200x1200x50  \
                        -s 3x2x1x0  \
                        -f 4x3x2x1 \
                        -m MeanSquares[  $f, $m , 1, 0 ] \
                         -t syn[ 0.25, 3, 0.0 ] \
                         -i $its  \
                        -s 2x1x0  \
                        -f 3x2x1 \
                       -u 1 \
                       -o [xtest_MSQ,xtest_MSQ.nii.gz,xtest_MSQ_inv.nii.gz] 



CreateWarpedGridImage 2 xtest_MSQ1Warp.nii.gz xtest_MSQ_grid.nii.gz 1x1 10x10 9x9 
CreateWarpedGridImage 2 xtest_MI1Warp.nii.gz xtest_MI_grid.nii.gz 1x1 10x10 9x9 
CreateWarpedGridImage 2 xtest_CC1Warp.nii.gz xtest_CC_grid.nii.gz 1x1 10x10 9x9 
 ImageMath 2 xtest_CCn.nii.gz m xtest_CC.nii.gz 1
 ImageMath 2 xtest_MIn.nii.gz m xtest_MI.nii.gz 1
 ImageMath 2 xtest_CCn.nii.gz Neg xtest_CC.nii.gz
 ImageMath 2 xtest_MIn.nii.gz Neg xtest_MI.nii.gz
 ThresholdImage 2 r16slice.nii.gz mask.nii.gz 1  999 
 MultiplyImages 2  xtest_MIn.nii.gz mask.nii.gz xtest_MIn.nii.gz
 MultiplyImages 2  xtest_CCn.nii.gz mask.nii.gz xtest_CCn.nii.gz

Atropos -d 2 -x mask.nii.gz -c [5,0.00001] -k Gaussian -m [0.1,1x1] -w BoxPlot[0.01,0.99]  -a r16slice.nii.gz  -o r16seg.nii.gz -i kmeans[3]
ThresholdImage 2 r64slice.nii.gz mask.nii.gz 1  999 
Atropos -d 2 -x mask.nii.gz -c [5,0.00001] -k Gaussian -m [0.1,1x1] -w BoxPlot[0.01,0.99]  -a r64slice.nii.gz  -o r64seg.nii.gz -i kmeans[3]

antsApplyTransforms -d 2 -v 0 -t xtest_MSQ0Warp.nii.gz -t xtest_MSQ1Affine.mat -n  MultiLabel[1,4] -r  r16slice.nii.gz  -i r64seg.nii.gz -o  temp.nii.gz
ImageMath 2 diceMSQ DiceAndMinDistSum r16seg.nii.gz temp.nii.gz
antsApplyTransforms -d 2 -v 0 -t xtest_CC0Warp.nii.gz -t xtest_CC1Affine.mat -n  MultiLabel[1,4] -r  r16slice.nii.gz  -i r64seg.nii.gz -o  temp.nii.gz
ImageMath 2 diceCC DiceAndMinDistSum r16seg.nii.gz temp.nii.gz
antsApplyTransforms -d 2 -v 0 -t xtest_MI0Warp.nii.gz -t xtest_MI1Affine.mat -n  MultiLabel[1,4] -r  r16slice.nii.gz  -i r64seg.nii.gz -o  temp.nii.gz
ImageMath 2 diceMI DiceAndMinDistSum r16seg.nii.gz temp.nii.gz


rm logx.txt
f=r16slice.nii.gz
for sim in 0 1 2 ; do 
MeasureImageSimilarity 2 $sim $f xtest_MSQ.nii.gz logx.txt
MeasureImageSimilarity 2 $sim $f xtest_CCn.nii.gz logx.txt
MeasureImageSimilarity 2 $sim $f xtest_MIn.nii.gz logx.txt
MeasureImageSimilarity 2 $sim $f xtest_CC.nii.gz logx.txt
MeasureImageSimilarity 2 $sim $f xtest_MI.nii.gz logx.txt
done
