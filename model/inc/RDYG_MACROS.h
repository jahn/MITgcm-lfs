C $Header$
C
C     /==========================================================\
C     | RDYG_MACROS.h                                             |
C     |==========================================================|
C     | These macros are used to reduce memory requirement and/or|
C     | memory references when variables are fixed along a given |
C     | axis or axes.                                            |
C     \==========================================================/

#ifdef RDYG_CONST
#define  _rdyG(i,j,bi,bj) rdyG(1,1,1,1)
#endif

#ifdef RDYG_FX
#define  _rdyG(i,j,bi,bj) rdyG(i,1,bi,1)
#endif

#ifdef RDYG_FY
#define  _rdyG(i,j,bi,bj) rdyG(1,j,1,bj)
#endif

#ifndef _rdyG
#define  _rdyG(i,j,bi,bj) rdyG(i,j,bi,bj)
#endif
