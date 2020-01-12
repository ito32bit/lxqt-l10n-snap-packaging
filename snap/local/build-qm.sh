#!/bin/bash

export QT_SELECT=5

if [ "$SNAPCRAFT_PART_INSTALL" == "" ]; then
  inst=$XDG_DATA_HOME
else
  inst=$SNAPCRAFT_PART_INSTALL/usr/share
fi
echo "+++ Install qm: $inst"

ts=`find . -name *.ts`
for fp in $ts ; do
  dn=${fp%/*}
  fn=${fp##*/}

  to_d=${fn%%_*}
  to_n=${fn%.ts}.qm
  if [ $fn == $to_d ]; then
    continue
  fi
  case $fp in
    *plugin-*)
      to_d=$inst/lxqt/translations/lxqt-panel/$to_d
      ;;
    *libfm* | *pcmanfm*)
      to_d=$inst/$to_d/translations
      ;;
    *)
      to_d=$inst/lxqt/translations/$to_d
      ;;
  esac
  mkdir -p $to_d
  to="$to_d/$to_n"
  lrelease $fp -qm $to
done

echo "+++ done qm"
