awk -v ion=$ion \
'
{
    if( match($0, ion) ){
        a_index=substr($0,16,5)
        a_index=a_index+0
        printf("%d\n", a_index)
    }
}
' ../nvt-production.gro > index.txt
