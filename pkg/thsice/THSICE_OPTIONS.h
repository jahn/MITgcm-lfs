C $Header$
C $Name$

#ifndef THSICE_OPTIONS_H
#define THSICE_OPTIONS_H
#include "PACKAGES_CONFIG.h"

#ifdef ALLOW_THSICE

#include "CPP_OPTIONS.h"

C- only to check conservation 
C  (change content of ICE_qleft,fresh,salFx-T files)
#undef CHECK_ENERGY_CONSERV

C CPP Macros go here

#endif /* ALLOW_THSICE */
#endif /* THSICE_OPTIONS_H */

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
