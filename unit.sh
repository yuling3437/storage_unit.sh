#!/bin/sh

unit()
{
    in=$@
    #param empty, read from pipe
    if [ $# -eq 0 ]; then
        read in
    fi

    res=`echo ${in} | awk '
        {
                $1=s($1)
        }

        function s(tmp)
        {
                if(tmp ~ /K|k/){
                    tmp=tmp/1024/1024
                }
                else if(tmp ~ /M|m/){
                    tmp=tmp/1024
                }
                else if(tmp ~ /G|g/){
                    sub("G", "", tmp)
                }
                else if(tmp ~ /T|t/){
                    tmp=tmp*1024
                }
                else if(tmp ~ /P|p/){
                    tmp=tmp*1024*1024
                }
                else if(tmp ~ /B/)
                {
                    tmp=tmp/1024/1024/1024
                }

                return tmp
        }

        END{
                printf("%.2f G\n", $1, $1);
        }
    '`
    echo $res
}


#test

echo 102400m | unit

unit 102400MiB

