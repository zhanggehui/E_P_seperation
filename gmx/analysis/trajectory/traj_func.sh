function get_first_and_last_frame() {
    # 1.
    # echo "name OW $1" | $gmx select -f nvt-production.trr -s nvt-production.tpr -b 0 -e 0 -on
    # $gmx trjconv -f nvt-production.trr -s nvt-production.tpr -o $2 -pbc nojump -b 0 -e $3 -skip $3 -n index.ndx
    
    # 2.使用waterlayer.ndx
    echo "$1" | $gmx trjconv -f nvt-production.trr -s nvt-production.tpr -o $2 -pbc nojump -b 0 -e $3 -skip $3 -n waterlayer.ndx
    
    rm -rf \#*
    if [ -e index.ndx ]; then
        rm -rf index.ndx
    fi
}

function get_continuous_frame() {
    
    # 1.
    # 用于gmx select的例子
    # echo 'name OW and z { 3 to 7 }' z在3-7nm之间的OW分子
    # echo 'name OW NA' 
    # echo 'group Water'
    
    # echo "name $ion" | $gmx select -f nvt-production.trr -s nvt-production.tpr -b 0 -e 0 -on
    # $gmx trjconv -f nvt-production.trr -s nvt-production.tpr -o $1 -b $2 -e $3 -n index.ndx -dt $4 -pbc nojump

    # 2.使用waterlayer.ndx
    echo "$1" | $gmx trjconv -f nvt-production.trr -s nvt-production.tpr -o $2 -pbc nojump -b $3 -e $4 -n waterlayer.ndx

    # 2.使用index.ndx
    # echo "$1" | $gmx trjconv -f ../nvt-production.trr -s ../nvt-production.tpr -o $2 -pbc nojump -b $3 -e $4 -n index.ndx


    rm -rf \#* 
    # if [ -e index.ndx ]; then
    #     rm -rf index.ndx
    # fi
}
