# AX_CHECK_GLU
#
# Check for GLU.  If GLU is found, the required preprocessor and linker flags
# are included in the output variables "GLU_CFLAGS" and "GLU_LIBS",
# respectively.  If no GLU implementation is found, "no_glu" is set to "yes".
#
# If the header "GL/glu.h" is found, "HAVE_GL_GLU_H" is defined. 
#
# --
#
# Copyright (c) 2009 Braden McDaniel <braden@endoframe.com>
# Copyright (c) 2014 Vincent Launchbury <vincent@doublecreations.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301, USA.
#
# As a special exception, the you may copy, distribute and modify the
# configure scripts that are the output of Autoconf when processing
# the Macro.  You need not follow the terms of the GNU General Public
# License when using or distributing such scripts.

AC_DEFUN([AX_CHECK_GLU],
[AC_REQUIRE([AX_CHECK_GL])
GLU_CFLAGS=$GL_CFLAGS

ax_save_CPPFLAGS=$CPPFLAGS
CPPFLAGS="$GL_CFLAGS $CPPFLAGS"
AC_CHECK_HEADERS([GL/glu.h])
CPPFLAGS=$ax_save_CPPFLAGS

m4_define([AX_CHECK_GLU_PROGRAM],
          [AC_LANG_PROGRAM([[
# ifdef HAVE_GL_GLU_H
#   include <GL/glu.h>
# else
#   error no glu.h
# endif]],
          [[gluBeginCurve(0)]])])

AC_CACHE_CHECK([for OpenGL Utility library], [ax_cv_check_glu_libglu],
[ax_cv_check_glu_libglu=no
ax_save_CPPFLAGS=$CPPFLAGS
CPPFLAGS="$GL_CFLAGS $CPPFLAGS"
ax_save_LIBS=$LIBS

#
# First, check for the possibility that everything we need is already in
# GL_LIBS.
#
LIBS="$GL_LIBS $ax_save_LIBS"

AC_LANG_PUSH([C])
AC_LINK_IFELSE([AX_CHECK_GLU_PROGRAM],
               [ax_cv_check_glu_libglu=yes],
               [LIBS=""
               ax_check_libs="-lglu32 -lGLU"
               for ax_lib in ${ax_check_libs}; do
                 LIBS="$ax_lib $GL_LIBS $ax_save_LIBS"
                 AC_LINK_IFELSE([AX_CHECK_GLU_PROGRAM],
                                [ax_cv_check_glu_libglu=$ax_lib; break])
               done])
AC_LANG_POP([C])

LIBS=$ax_save_LIBS
CPPFLAGS=$ax_save_CPPFLAGS])
AS_IF([test "X$ax_cv_check_glu_libglu" = Xno],
      [no_glu=yes; GLU_CFLAGS=""; GLU_LIBS=""],
      [AS_IF([test "X$ax_cv_check_glu_libglu" = Xyes],
             [GLU_LIBS=$GL_LIBS],
             [GLU_LIBS="$ax_cv_check_glu_libglu $GL_LIBS"])])
AC_SUBST([GLU_CFLAGS])
AC_SUBST([GLU_LIBS])
])dnl
