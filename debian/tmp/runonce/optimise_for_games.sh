#!/bin/bash
# Sources:
# - https://wiki.archlinux.org/title/improving_performance
#   - Transparent Hub Pages are not updated since this could be detrimental to certain games
#
GRUB_FILE=/etc/default/grub
NO_FORMAT="\033[0m"
C_ORANGERED1="\033[38;5;202m"
C_SILVER="\033[38;5;7m"

function checkFile {
  fileToCheck="$1"
  patternToFind="$2"
  fileParam="$3"
  expectedParamCount="$4"

  if [ ! -f "${fileToCheck}" ]; then
    echo -e "    ${C_SILVER}SKIPPED ${fileToCheck}: no file${NO_FORMAT}"
    return 0
  fi

  if [ -n "${patternToFind}" ]; then
    fileParamCount=$(grep ${patternToFind} ${fileToCheck} | grep ${fileParam} | wc -l)
  else
    fileParamCount=$(grep ${fileParam} ${fileToCheck} | wc -l)
  fi

  if [ "${fileParamCount}" -ne "${expectedParamCount}" ]; then
    echo -e "    ${C_ORANGERED1}MISSING ${fileToCheck}: ${fileParam}${NO_FORMAT}"
    return 1
  else
    return 0
  fi
}
function checkGrubCmdLine {
  grubParam="$1"

  checkFile "${GRUB_FILE}" "GRUB_CMDLINE_LINUX_DEFAULT" "$grubParam" 1
  return $?
}

echo "The following are missing:"
checkGrubCmdLine "zswap.enabled=1"
checkGrubCmdLine "tsc=reliable"
checkGrubCmdLine "clocksource=tsc"

checkFile "/proc/sys/vm/compaction_proactiveness" "" "1" 1
checkFile "/proc/sys/vm/min_free_kbytes" "" "1048576" 1
checkFile "/proc/sys/vm/swappiness" "" "10" 1
checkFile "/sys/kernel/mm/lru_gen/enabled" "" "5" 1
checkFile "/proc/sys/vm/zone_reclaim_mode" "" "0" 1
echo "Finished."
