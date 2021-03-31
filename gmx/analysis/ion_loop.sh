ions=("CS" "LI" "NA" "K" "CA" "MG")
n_ions=${#ions[@]}

for((i=0; i<$n_ions; i++)); do
    ion=${ions[$i]}
    cd ./$ion/0Mpa-0V
    source .sh
    cd ../../
done
