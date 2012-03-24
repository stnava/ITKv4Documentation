dim=2
m=beetle.jpg ;	f=ford.jpg
if [ ! -s $f ] ; then no fixed $f ; exit 1 ; fi 
if [ ! -s $m ] ; then no moving $m ; exit 1 ; fi 
its=1500x1500x1500x300x100x0
its2=200x200x200x200x150x50
smth=5x4x3x2x1x0
down=7x6x5x4x2x1
tx=" syn[ 0.25 , 3.0, 1 ] "
if [[ 0 == 1 ]] ; then 
antsRegistration -d $dim \
                        -m Mattes[  $f, $m , 1,  20, Random, 0.1 ] \
                         -t affine[ 2.0 ]  \
                         -i $its  \
                        -s $smth  \
                        -f $down \
                       -u 1 \
                       -o [cars_,cars_aff.nii.gz] 
MeasureImageSimilarity $dim 2 $f cars_aff.nii.gz
fi

#                        -m cc[  $f, $m , 1, 8 ] \
antsRegistration -d $dim -r [cars_0Affine.mat] \
                        -m Mattes[  $f, $m , 1,  32 ] \
                        -t $tx \
                        -i $its2  \
                        -s $smth  \
                        -f $down \
                       -u 1 \
                       -o [cars_,cars_diff.nii.gz,cars_diff_inv.nii.gz] 
MeasureImageSimilarity 2 2 $f cars_diff.nii.gz log.txt 

