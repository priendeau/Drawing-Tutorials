#!/bin/bash

StrFile=$0 ; 
SCIsDisplayCmd=True SCBackendName=potrace  ./pnmtosvg.sh ${StrFile//\.sh/} ; 

