#!/bin/sh

set -e

topdir=`pwd`

ai='tm'

rm -rf p

mkdir -p p &&
    cd p &&
    touch Makefile &&
    touch script.sh &&
    git init &&
    git add -A &&
    git commit -am "Initial commit"

cd $topdir/p

git checkout -B $ai/scpinsteadrsync master &&
    touch copyscript.sh &&
    echo scp host1 host2:/tmp >copyscript.sh &&
    git add copyscript.sh &&
    git commit -am "Use SCP instead of rsync because remote host might not support rsync" &&
    echo >>copyscript.sh &&
    git add copyscript.sh &&
    git commit -am "Add witespace"

cd $topdir/p

git checkout -B $ai/funkyidea master &&
    touch funk.sh &&
    echo ehco my shoes are funky smelling >funk.sh &&
    git add funk.sh &&
    git commit -am "tell the world about my funky shoes" &&
    echo >>funk.sh &&
    git add funk.sh &&
    git commit -am "Add funk"

cd $topdir/p

git checkout -B $ai/pythonreplacebash master &&
    touch funk.py &&
    git add funk.py &&
    git commit -am "python beats bash any day"

cd $topdir/p

git checkout -B $ai/improveperformance master &&
    touch fast-op.sh &&
    git add fast-op.sh &&
    git commit -am "No script is faster than one with no operations in it"

##################################################
# Add meta
##################################################

cd $topdir/p
git clone $topdir/git Meta
cd $topdir/p/Meta
[ -z "$(git show-ref refs/heads/todo)" ] &&
    git checkout origin/todo

# Now we have the p/Meta/cook script in place

# truncate Meta/whats-cooking.txt
cd $topdir/p/Meta
perl -i.bak -ane '$x=qq/-/x50; $count++ if ($x eq pop(@F)); print if ($count<2)' whats-cooking.txt
perl -e 'print qq/-/x50,qq/\n/' >>whats-cooking.txt
cd $topdir/p
cat Meta/whats-cooking.txt

# Now we have the p/Meta/whats-cooking.txt logfile in place

cd $topdir/p

# Fork integration branches from master
git checkout -B maint master
git checkout -B next master
git checkout -B pu master

##################################################
# $ Meta/cook -w which will pick up comments given to the topics, such as
# "Will merge to 'next'", etc. (see Meta/cook script to learn what kind of
# phrases are supported).
##################################################

cd $topdir/p

git checkout pu
git merge --no-edit $ai/improveperformance
Meta/cook
echo >>Meta/whats-cooking.txt
echo Waiting for reponse from tom on this. >>Meta/whats-cooking.txt
Meta/cook -w

##################################################
# Topics not listed in the file but are found in master..pu are added to
# the "New topics" section,
##################################################

cd $topdir/p

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

cd $topdir/p

git checkout master
git merge next

Meta/cook
cat Meta/whats-cooking.txt

##################################################
# topics whose commits changed their states (e.g. used to be only in
# 'pu', now merged to 'next') are updated with change markers "<<" and
# ">>".
##################################################

cd $topdir/p

git checkout next
git merge --no-edit pu

Meta/cook
cat Meta/whats-cooking.txt



Meta/cook -w
