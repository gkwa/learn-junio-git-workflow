#!/bin/sh

set -e

topdir=`pwd`

ai='tm'

rm -rf myproject

mkdir -p myproject &&
    cd myproject &&
    touch Makefile &&
    touch script.sh &&
    git init &&
    git add -A &&
    git commit -am "Initial commit"

cd $topdir/myproject

git checkout -B $ai/scpinsteadrsync master &&
    touch copyscript.sh &&
    echo scp host1 host2:/tmp >copyscript.sh &&
    git add copyscript.sh &&
    git commit -am "Use SCP instead of rsync because remote host might not support rsync" &&
    echo >>copyscript.sh &&
    git add copyscript.sh &&
    git commit -am "Add witespace"

cd $topdir/myproject

git checkout -B $ai/funkyidea master &&
    touch funk.sh &&
    echo ehco my shoes are funky smelling >funk.sh &&
    git add funk.sh &&
    git commit -am "tell the world about my funky shoes" &&
    echo >>funk.sh &&
    git add funk.sh &&
    git commit -am "Add funk"

cd $topdir/myproject

git checkout -B $ai/pythonreplacebash master &&
    touch funk.py &&
    git add funk.py &&
    git commit -am "python beats bash any day"

##################################################
# Add meta
##################################################

cd $topdir/myproject
git clone $topdir/git Meta
cd $topdir/myproject/Meta
[ -z "$(git show-ref refs/heads/todo)" ] &&
    git checkout origin/todo

# Now we have the myproject/Meta/cook script in place

# truncate Meta/whats-cooking.txt
cd $topdir/myproject/Meta
perl -i.bak -ane '$x=qq/-/x50; $count++ if ($x eq pop(@F)); print if ($count<2)' whats-cooking.txt
perl -e 'print qq/-/x50,qq/\n/' >>whats-cooking.txt
cd $topdir/myproject
cat Meta/whats-cooking.txt

# Now we have the myproject/Meta/whats-cooking.txt logfile in place

cd $topdir/myproject

# Fork integration branches from master
git checkout -B maint master
git checkout -B next master
git checkout -B pu master

##################################################
# Topics not listed in the file but are found in master..pu are added to
# the "New topics" section,
##################################################

cd $topdir/myproject

git checkout pu
git merge --no-edit $ai/funkyidea
Meta/cook
cat Meta/whats-cooking.txt

git checkout next
git merge --no-edit $ai/scpinsteadrsync
Meta/cook
cat Meta/whats-cooking.txt

##################################################
# topics listed in the file that are no longer found in master..pu are
# moved to the "Graduated to master" section
##################################################

cd $topdir/myproject

git checkout master
git merge next

Meta/cook
cat Meta/whats-cooking.txt

##################################################
# topics whose commits changed their states (e.g. used to be only in
# 'pu', now merged to 'next') are updated with change markers "<<" and
# ">>".
##################################################

cd $topdir/myproject

git checkout next
git merge --no-edit pu

Meta/cook
cat Meta/whats-cooking.txt

##################################################
# $ Meta/cook -w which will pick up comments given to the topics, such as
# "Will merge to 'next'", etc. (see Meta/cook script to learn what kind of
# phrases are supported).
##################################################

cd $topdir/myproject

git checkout pu &&
git merge --no-edit $ai/pythonreplacebash &&
Meta/cook
cat Meta/whats-cooking.txt

echo
echo

echo >>Meta/whats-cooking.txt
echo Waiting for reponse from josh on this. >>Meta/whats-cooking.txt

Meta/cook -w
