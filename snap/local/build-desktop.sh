#!/bin/bash

if [ "$SNAPCRAFT_PART_INSTALL" == "" ]; then
  inst=$XDG_DATA_HOME
  inst2=$XDG_CONFIG_HOME/_autostart-dummy
else
  inst=$SNAPCRAFT_PART_INSTALL/usr/share
  inst2=$SNAPCRAFT_PART_INSTALL/etc/xdg/autostart
fi
echo "+++ Install desktop: $inst"

de="
    `find . -name *.desktop.in`
    `find . -name *.desktop.yaml`
    `find . -name lxqt-*.directory.in`
    `find . -name lxqt-*.directory.yaml`
"
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
    *xsession*)
      to_d=$inst/xsessions
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
    *.desktop.yaml | *.directory.yaml)
      fn2=${fn%.yaml}
      fn2=${fn2/_*./.}
      to=$to_d/$fn2
      lang=""
      if [[ $fn =~ [^_]*_([^\.]*)\..* ]] ; then
        lang=[${BASH_REMATCH[1]}]
      fi
      echo "cat; $fp"
      pat='^Desktop Entry/\(.*\): "\(.*\)"'
      cat $fp | sed -e "s!$pat!\1$lang=\2!" >> $to
      ;;
  esac
done

echo "+++ done desktop"
