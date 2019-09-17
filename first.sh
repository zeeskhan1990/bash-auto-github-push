#!/bin/sh
# This is a comment!

#apt-get is idempotent, so the following commands will install the packages only if they aren't installed already, else would do nothing
sudo apt-get install jq
sudo apt-get install moreutils

for d in */ ; do
    d=${d%/}

    echo "Current directory - "
    echo "$d"

    if [ -d $d/.git ]; then
        echo "It is a git project"
        cd $d

        file="package.json"
        if [ -f $file ]; then
            #Updates the name of the npm project to match the directory and repository name

            echo "Its a node project, too";
            var_xy=$d
            var_yz='.name='\""$var_xy"\"''

            echo "New package name - "
            echo $var_yz

            jq $var_yz package.json | sponge package.json
        fi
        
        git add .
        git commit -m "Auto git push bash script"
        git remote add origin git@github.com:<Your_Username>/$d.git

        echo "Git Remote origin - "
        git remote -v

        var_repo_name='{'\"name\":\""$d"\"}''
        curl -u <Your_Username>:<Your_Password> https://api.github.com/user/repos -d $var_repo_name
        git push -u origin master

        echo "Git Remote repository - "
        echo $var_repo_name

        git remote rm origin
        cd ..
    else
        echo "It is NOT a git project"
    fi

    #break
done