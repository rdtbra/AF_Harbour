#!/bin/sh
#
# $Id: mpkg_rpm.sh 15264 2010-08-02 10:13:23Z druzus $
#

# ---------------------------------------------------------------
# Copyright 2003 Przemyslaw Czerpak <druzus@polbox.com>
# simple script to build RPMs from Harbour sources
#
# See COPYING for licensing terms.
# ---------------------------------------------------------------

test_reqrpm()
{
   rpm -q --whatprovides "$1" >/dev/null 2>&1
}

get_rpmmacro()
{
   local R X Y

   R=`rpm --showrc|sed -e "/^-14:.${1}[^a-z0-9A-Z_]/ !d" -e "s/^-14: ${1}.//"`
   X=`echo "${R}"|sed -e "s/.*\(%{\([^}]*\)}\).*/\2/"`
   while [ "${X}" != "${R}" ]
   do
      Y=`get_rpmmacro "$X"`
      if [ -n "${Y}" ]
      then
         R=`echo "${R}"|sed -e "s!%{${X}}!${Y}!g"`
         X=`echo "${R}"|sed -e "s/.*\(%{\([^}]*\)}\).*/\2/"`
      else
         X="${R}"
      fi
   done
   echo -n "${R}"
}

NEED_RPM="make gcc binutils bash"

FORCE=""

LAST=""
while [ $# -gt 0 ]
do
   if [ "$1" = "--force" ]
   then
      FORCE="yes"
   else
      INST_PARAM="${INST_PARAM} $1"
      if [ "${LAST}" = "--with" ]
      then
         [ "$1" = "mysql" ] && NEED_RPM="${NEED_RPM} mysql-devel"
         [ "$1" = "odbc" ] && NEED_RPM="${NEED_RPM} unixODBC-devel"
         [ "$1" = "pgsql" ] && NEED_RPM="${NEED_RPM} postgresql-devel"
         [ "$1" = "firebird" ] && NEED_RPM="${NEED_RPM} firebird-devel"
         [ "$1" = "freeimage" ] && NEED_RPM="${NEED_RPM} freeimage-devel"
         [ "$1" = "allegro" ] && NEED_RPM="${NEED_RPM} allegro-devel"
         [ "$1" = "qt" ] && NEED_RPM="${NEED_RPM} libqt4-devel"
      fi
   fi
   LAST="$1"
   shift
done

if [ -f /usr/local/ads/acesdk/ace.h ] || [ -f ${HOME}/ads/acesdk/ace.h ]
then
   INST_PARAM="${INST_PARAM} --with ads"
fi
if test_reqrpm "allegro-devel"
then
   INST_PARAM="${INST_PARAM} --with allegro"
fi
if test_reqrpm "cairo-devel"
then
   INST_PARAM="${INST_PARAM} --with cairo"
fi
if test_reqrpm "libcups2-devel"
then
   INST_PARAM="${INST_PARAM} --with cups"
fi
if test_reqrpm "curl-devel"
then
   INST_PARAM="${INST_PARAM} --with curl"
fi
if test_reqrpm "firebird-devel"
then
   INST_PARAM="${INST_PARAM} --with firebird"
fi
if test_reqrpm "freeimage-devel"
then
   INST_PARAM="${INST_PARAM} --with freeimage"
fi
if test_reqrpm "gd-devel"
then
   v=`rpm -q --whatprovides gd-devel --qf "%{VERSION}"|sed -e "s/[^0-9]*\([0-9]*\).*/\1/g"`
   [ "$v" -ge 2 ] && INST_PARAM="${INST_PARAM} --with gd"
fi
if test_reqrpm "MySQL-devel" || test_reqrpm "mysql-devel"
then
   INST_PARAM="${INST_PARAM} --with mysql"
fi
if test_reqrpm "unixodbc-devel" || test_reqrpm "unixODBC-devel"
then
   INST_PARAM="${INST_PARAM} --with odbc"
fi
if test_reqrpm "postgresql-devel"
then
   INST_PARAM="${INST_PARAM} --with pgsql"
fi
if test_reqrpm "libqt4-devel"
then
   v=` rpm -q --whatprovides libqt4-devel --qf "%{VERSION}"|sed -e "s/[^0-9]*[0-9]*.\([0-9]*\).*/\1/g"`
   [ "$v" -ge 5 ] && INST_PARAM="${INST_PARAM} --with qt"
fi

if [ "${HB_BUILD_NOGPLLIB}" = "yes" ]
then
   INST_PARAM="${INST_PARAM} --without gpllib"
fi
if [ "${HB_BUILD_NOGPLLIB}" = "yes" ] || ! test_reqrpm "gpm-devel"
then
   INST_PARAM="${INST_PARAM} --without gpm"
fi
if ! test_reqrpm "XFree86-devel"
then
   INST_PARAM="${INST_PARAM} --without X11"
fi
if ! test_reqrpm ncurses || ! test_reqrpm ncurses-devel
then
   INST_PARAM="${INST_PARAM} --without curses"
fi
if ! test_reqrpm slang || ! test_reqrpm slang-devel
then
   INST_PARAM="${INST_PARAM} --without slang"
fi
if [ ! -f /usr/include/zlib.h ] && [ ! -f /usr/local/include/zlib.h ]
then
   INST_PARAM="${INST_PARAM} --with localzlib"
fi
if [ ! -f /usr/include/pcre.h ] && [ ! -f /usr/local/include/pcre.h ]
then
   INST_PARAM="${INST_PARAM} --with localpcre"
fi

TOINST_LST=""
for i in ${NEED_RPM}
do
   test_reqrpm "$i" || TOINST_LST="${TOINST_LST} $i"
done

if [ -z "${TOINST_LST}" ] || [ "${FORCE}" = "yes" ]
then
   cd `dirname $0`
   . ./mpkg_src.sh
   stat="$?"
   if [ -z "${hb_filename}" ]
   then
      echo "The script ./mpkg_src.sh doesn't set archive name to \${hb_filename}"
      exit 1
   elif [ "${stat}" != 0 ]
   then
      echo "Error during packing the sources in ./mpkg_src.sh"
      exit 1
   elif [ -f ${hb_filename} ]
   then
      if [ `id -u` != 0 ] && [ ! -f ${HOME}/.rpmmacros ]
      then
         RPMDIR="${HOME}/RPM"
         mkdir -p ${RPMDIR}/SOURCES ${RPMDIR}/RPMS ${RPMDIR}/SRPMS \
                  ${RPMDIR}/BUILD ${RPMDIR}/SPECS
         echo "%_topdir ${RPMDIR}" > ${HOME}/.rpmmacros
      else
         RPMDIR=`get_rpmmacro "_topdir"`
      fi

      mv -f ${hb_filename} ${RPMDIR}/SOURCES/
      cp harbour.spec ${RPMDIR}/SPECS/

      if which rpmbuild >/dev/null 2>&1
      then
         RPMBLD="rpmbuild"
      else
         RPMBLD="rpm"
      fi
      cd ${RPMDIR}/SPECS
      ${RPMBLD} -ba harbour.spec ${INST_PARAM}
   else
      echo "Cannot find archive file: ${hb_filename}"
      exit 1
   fi
else
   echo "If you want to build Harbour compiler"
   echo "you have to install the folowing RPM files:"
   echo "${TOINST_LST}"
   exit 1
fi
