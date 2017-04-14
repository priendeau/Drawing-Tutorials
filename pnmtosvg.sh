#!/bin/bash 

function StartConversion()
{
  local ArrayArg=( $* ) ;
  local Arg0=${ArrayArg[0]} ; 
  local StrFileName=${Arg0}.pnm ;
  local StrBackendName=${SCBackendName:=potrace} ; 
  local StrBackendApps=${SCBackend:=/usr/bin/potrace} ; 
  local StrPotraceSvgOpt=${SCPotraceSVG:=--svg} ; 
  local StrAutotraceSvgOpt=${SCAutotraceSVG:=--output-format=svg} ; 
  local StrFmtOutput ; 
  local BoolPotraceBackEnd=True ; 
  local BoolBackendProcessed=True ; 
  local BoolStartConv=False ; 
  local BoolDisplayCmd=${SCIsDisplayCmd:=False} ; 
  local IntHeight=${SCHeight:=437} ; 
  local IntWidth=${SCWidth:=437} ;
  local IntAlphaMax=${SCPotraceAlphaMax:=1.0} ; 
  local IntFillColor=${SCFillColor:=#FFFFFF}
  local IntColor=${SCColorFG:=#000000} 
  local IntDpi=${SCDpi:=300} ;
  local StrFileConvert ; 
  local StrExtraOpt=${SCBackendExtraOpt:=None} ; 
  local StrCmdTpl="__APPS__ __OPT__"
  local StrOptPotrace="__BACKEND__ __FILE_IN__ __SVG_FMT__ --alphamax=__ALPHA_MAX__ --opttolerance=0.5 --scale=0.0033 --resolution=__DPI__ --width=__WIDTH__ --height=__HEIGHT__ --color=${IntColor} --fillcolor=${IntFillColor} --turdsize=4 --longcurve --turnpolicy=majority --unit=200 __EXTRA_OPT__ --output=__FILE_OUT__ " ; 
  local StrOptAutotrace="__BACKEND__ --background-color=FFFFFF --color-count=2 --corner-always-threshold=90 --corner-surround=10 --corner-threshold=85 --despeckle-tightness=2.0 --dpi=__DPI__ --error-threshold=0.01 --line-reversion-threshold=1 --line-threshold=1 --input-format=PNM __SVG_FMT__ __EXTRA_OPT__ --output-file=__FILE_OUT__ __FILE_IN__ " ;  
  local StrOptCmd ;  


  if [ "${StrBackendName:=potrace}" == "potrace" ] ; then  
   BoolPotraceBackEnd=True ; 
   StrOptCmd="${StrOptPotrace}" ; 
   StrFmtOutput="${StrPotraceSvgOpt}" ; 
  elif [ ${StrBackendName:=potrace} == "autotrace" ] ; then 
    local IntLengthAppsSubst=${#StrBackendApps} ; 
    local StrTextBackend=${StrBackendApps//${StrBackendName}/} ; 
    echo -ne "IntLengthAppsSubst:${IntLengthAppsSubst}\nStrBackendApps:${#StrBackendApps}\n" ; 
    if [ ${IntLengthAppsSubst} -eq ${#StrTextBackend} ]  ; then 
      echo -ne "Backend (${StrBackendName}) was specified but Backend-engine for SVG procesing still\nthe application: /usr/bin/potrace.\n\tChange the prefixed-variable SCBackend to ${StrBackendName} location \n( /usr/bin/${StrBackendName} or /usr/loca/bin/${StrBackendName} ). Or compile ${StrBackendName} if your\ndistribution did not own it.\n"
      BoolBackendProcessed=False ; 
    else
     BoolPotraceBackEnd=False ;
     BoolBackendProcessed=True  
     StrFmtOutput="${StrAutotraceSvgOpt}" ; 
     StrOptCmd="${StrOptAutotrace}" ; 
    fi 
  else
   echo -ne "Error Occur, unknow backend.\nPlease choose SCBackendName as prefixed-name to choose either potrace or autotrace as backend.\nDefault is potrace\n\texample:\n\tSCBAckendName=autotrace  ./pnmtosvg.sh BlueFish\n"
  fi 

  if [ "${BoolBackendProcessed:=True}" == "True"  ] ; then 
   if [ -e ${StrFileName} ] ; then 
    BoolStartConv=True
    StrFileConvert="${Arg0}.svg" ;
    echo -ne "Taking File ${StrFileName} to convert into ${StrFileConvert}.\n\tUsing application backend: ${StrBackendName}\n\tpath location:${StrBackendApps}\n" ;
   fi 
  fi  
  
  if [ "${BoolBackendProcessed:=True}" == "True" ] ; then 
   if [ "${BoolStartConv:=False}" == "True" ] ; then 
    StrOptCmd=${StrOptCmd//__FILE_IN__/${Arg0}.pnm} ; 
    StrOptCmd=${StrOptCmd//__FILE_OUT__/${Arg0}.svg} ; 
    StrOptCmd=${StrOptCmd//__BACKEND__/${StrBackendApps}} ; 
    StrOptCmd=${StrOptCmd//__DPI__/${IntDpi}} ; 
    StrOptCmd=${StrOptCmd//__BACKEND__/${StrBackendApps}} ; 
    StrOptCmd=${StrOptCmd//__SVG_FMT__/${StrFmtOutput}} ; 
    StrOptCmd=${StrOptCmd//__WIDTH__/${IntWidth}} ; 
    StrOptCmd=${StrOptCmd//__HEIGHT__/${IntHeight}} ; 
    StrOptCmd=${StrOptCmd//__ALPHA_MAX__/${IntAlphaMax}} ; 

    if [ "${StrExtrOpt:=None}" == "None" ] ; then 
     StrOptCmd=${StrOptCmd//__EXTRA_OPT__/} ;      
    else
     StrOptCmd=${StrOptCmd//__EXTRA_OPT__/${StrExtraOpt}} ;      
    fi
    if [ "${BoolDisplayCmd:=False}" == "True" ] ; then 
     echo -ne "DEBUG-CMD:[${StrOptCmd}]\n" ; 
    fi  
    eval "${StrOptCmd}" ; 
    
   else
    echo -ne "Check if File: ${StrFileName} is existing, the converter take as parameter only the Filename without suffix.\n"
   fi
  fi  
}

### 

SCPotraceAlphaMax=${SCPotraceAlphaMax} \
SCIsDisplayCmd=${SCIsDisplayCmd}       \
SCBackendName=${SCBackendName}         \
SCBackend=${SCBackend}                 \
SCColorFG=${SCColorFG}                 \
SCFillColor=${SCFillColor}             \
SCHeight=${SCHeight}                   \
SCWidth=${SCWidth}                     \
SCDpi=${SCDpi}                         \
SCPotraceSVG=${SCPotraceSVG}           \
SCAutotraceSVG=${SCAutotraceSVG}       \
SCBackendExtraOpt=${SCBackendExtraOpt} \
StartConversion $* ; 

