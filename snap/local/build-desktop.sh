#!/bin/bash

if [ "$SNAPCRAFT_PART_INSTALL" == "" ]; then
  inst=$XDG_DATA_HOME
  inst2=$XDG_CONFIG_HOME/_autostart-dummy
else
  inst=$SNAPCRAFT_PART_INSTALL/usr/share
  inst2=$SNAPCRAFT_PART_INSTALL/etc/xdg/autostart
fi
echo "+++ Install desktop: $inst"

de=`find . -name *.desktop.in`" "`find . -name *.desktop`" "`find . -name lxqt-*.directory.in`" "`find . -name lxqt-*.directory`
for fp in $de ; do
  dn=${fp%/*}
  fn=${fp##*/}

  case $fp  in
    *plugin-*)
      to_d=$inst/lxqt/lxqt-panel
      ;;
    *autostart*)
      to_d=$inst2
      ;;
    *.directory*)
      to_d=$inst/desktop-directories
      ;;
    *)
      to_d=$inst/applications
      ;;
  esac
  mkdir -p $to_d
  case $fn in
    *.in)
      to=$to_d/${fn%.in}
      cp -v $fp $to
      ;;
    *_*.desktop | *_*.directory)
      fn2=${fn/_*./.}
      to=$to_d/$fn2
      echo "cat; $fp"
      cat $fp | grep -E "^Name\[|^Comment\[|^GenericName\[" >> $to
      ;;
    *.desktop | *.directory)
      to=$to_d/$fn
      cp -v $fp $to
      ;;
  esac
done
