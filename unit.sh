#!/bin/sh

read_param()
{
    in=$@
    #param empty, read from pipe
    if [ $# -eq 0 ]; then
        read in
    fi

    echo ${in}
}

unit_b()
{
    in=`read_param $@`

    echo ${in} | awk '
        {
            $1=s($1$2)
            printf("%.2f\n", $1)
        }

        function s(tmp)
        {
            if(tmp ~ /K|k/){
                tmp=tmp*1024
            }
            else if(tmp ~ /M|m/){
                tmp=tmp*1024*1024
            }
            else if(tmp ~ /G|g/){
                tmp=tmp*1024*1024*1024
            }
            else if(tmp ~ /T|t/){
                tmp=tmp*1024*1024*1024*1024
            }
            else if(tmp ~ /P|p/){
                tmp=tmp*1024*1024*1024*1024*1024
            }

            return tmp
        }
    '
}

unit_k(){
    in=`read_param $@`

    echo ${in} | unit_b | awk '{
        $1=$1/1024
        printf("%.2f\n", $1)
    }'
}

unit_m(){
    in=`read_param $@`

    echo ${in} | unit_b | awk '{
        $1=$1/1024/1024
        printf("%.2f\n", $1)
    }'
}

unit_g(){
    in=`read_param $@`

    echo ${in} | unit_b | awk '{
        $1=$1/1024/1024/1024
        printf("%.2f\n", $1)
    }'
}

unit_t(){
    in=`read_param $@`

    echo ${in} | unit_b | awk '{
        $1=$1/1024/1024/1024/1024
        printf("%.2f\n", $1)
    }'
}

unit_p(){
    in=`read_param $@`

    echo ${in} | unit_b | awk '{
        $1=$1/1024/1024/1024/1024/1024
        printf("%.2f\n", $1)
    }'
}

#if value has space must use double qoute:  unit_compare "$value1" "$value2"
unit_compare()
{
    unit1=`unit_b $1`
    unit2=`unit_b $2`

    res=`echo "$unit1 $unit2" | awk '
    {
        if($1<$2)
            printf("-1\n")
        else if($1>$2)
            printf("1\n")
        else
            printf("0\n")
    }
    '`
    return res;
}
