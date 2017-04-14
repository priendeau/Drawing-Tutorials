#!/bin/bash

StrFile=$0 ; 
SCIsDisplayCmd=True   \
SCDpi=300             \
SCHeight=437          \
SCWidth=437           \
SCPotraceAlphaMax=1.0 \
SCBackendName=potrace \
./pnmtosvg.sh ${StrFile//\.sh/} ; 

