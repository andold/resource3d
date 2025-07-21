#!/bin/bash
#
#
#
PROJECT=resource3d
OPENSCAD_PROJECT=epaper
HOME_DIR=/home/andold
ECLIPSE_WORKSPACE_DIR=$HOME_DIR/src/eclipse-workspace
PROJECT_DIR=$ECLIPSE_WORKSPACE_DIR/$PROJECT
SOURCE_DIR=$PROJECT_DIR/openscad/src/$OPENSCAD_PROJECT
DEPLOY_DIR=/media/owl/data/$PROJECT/stl
OPENSCAD=/usr/bin/openscad
SOURCE_SCAD=$SOURCE_DIR/$OPENSCAD_PROJECT.scad
DEFAULT_OPTION="--export-format asciistl"
#
#
#
#
date
echo $SOURCE_SCAD $DEPLOY_DIR
#
#
#
SOURCE_SCAD=/media/owl/tmp/epaper/part-12.scad
#
#echo "$(date +'%Y%m%H%M')"
$OPENSCAD $DEFAULT_OPTION -D command=1 -o "/media/owl/tmp/epaper/part-12-$(date +'%Y%m').stl" $SOURCE_SCAD
