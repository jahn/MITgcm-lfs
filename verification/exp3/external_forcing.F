C $Header$

#include "CPP_OPTIONS.h"

CStartOfInterface
      SUBROUTINE EXTERNAL_FORCING_U(
     I           iMin, iMax, jMin, jMax,bi,bj,kLev,
     I           myCurrentTime,myThid)
C     /==========================================================\
C     | S/R EXTERNAL_FORCING_U                                   |
C     | o Contains problem specific forcing for zonal velocity.  |
C     |==========================================================|
C     | Adds terms to gU for forcing by external sources         |
C     | e.g. wind stress, bottom friction etc..................  |
C     \==========================================================/

C     == Global data ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "DYNVARS.h"

C     == Routine arguments ==
C     iMin - Working range of tile for applying forcing.
C     iMax
C     jMin
C     jMax
C     kLev
      INTEGER iMin, iMax, jMin, jMax, kLev, bi, bj
      INTEGER myCurrentTime, myThid
CEndOfInterface
C     == Local variables ==
C     uKf              - Inverse time-scale for synoptic system spindown.
C     levelOfGround    - Height of lower boundary
C     criticalLevel    - Dimensional height of upper limit to
C                        drag layer.
C     heightAboveGround
C     dist1            - Distance above ground of this level
C     dist2            - Distance above ground of critical level
C     decayFac         - Height scaling factor
C     velDragHeightFac - Height scaled velocity drag coefficient
C     I,J              - Loop counters
      _RL uKf
      _RL levelOfGround
      _RL criticalLevel
      _RL heightAboveGround
      _RL dist1
      _RL dist2
      _RL decayFac
      _RL velDragHeightFac
      INTEGER I, J

C     Held and Suarez drag formulation
C     Drag is the inverse of a spin-down time-scale
C     ( typically 1 - 10 days ).
C     Drag decays linearly with height up to some
C     critical level above the ground, then drag stays at zero.
C     At ground drag is inversely proportional to an
C     approximate synoptic system "spin-down" timescale.
      uKf                   = 1. _d 0/tauSynopSpinDown
      levelOfGround         = rC(Nr)+delR(Nr)*0.5 _d 0
      heightAboveGround     = rC(kLev)
      criticalLevel         = bottomDragHeightScale * levelOfGround
      dist1                 = heightAboveGround-criticalLevel
      dist2                 = levelOfGround    -criticalLevel
      decayFac              = MAX(0.,dist1/dist2)
      velDragHeightFac      = decayFac*uKf
      DO J=jMin,jMax
       DO I=iMin,iMax
        gU(i,j,kLev,bi,bj) =
     &  gU(i,j,kLev,bi,bj) - velDragHeightFac*uVel(i,j,kLev,bi,bj)
       ENDDO
      ENDDO

      RETURN
      END
CStartOfInterface
      SUBROUTINE EXTERNAL_FORCING_V(
     I           iMin, iMax, jMin, jMax,bi,bj,kLev,
     I           myCurrentTime,myThid)
C     /==========================================================\
C     | S/R EXTERNAL_FORCING_V                                   |
C     | o Contains problem specific forcing for merid velocity.  |
C     |==========================================================|
C     | Adds terms to gV for forcing by external sources         |
C     | e.g. wind stress, bottom friction etc..................  |
C     \==========================================================/

C     == Global data ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "DYNVARS.h"

C     == Routine arguments ==
C     iMin - Working range of tile for applying forcing.
C     iMax
C     jMin
C     jMax
C     kLev
      INTEGER iMin, iMax, jMin, jMax, kLev, bi, bj
      INTEGER myCurrentTime, myThid
CEndOfInterface
C     == Local variables ==
C     uKf              - Inverse time-scale for synoptic system spindown.
C     levelOfGround    - Height of lower boundary
C     criticalLevel    - Dimensional height of upper limit to
C                        drag layer.
C     heightAboveGround
C     dist1            - Distance above ground of this level
C     dist2            - Distance above ground of critical level
C     decayFac         - Height scaling factor
C     velDragHeightFac - Height scaled velocity drag coefficient
C     I,J              - Loop counters
      _RL uKf
      _RL levelOfGround
      _RL criticalLevel
      _RL heightAboveGround
      _RL dist1
      _RL dist2
      _RL decayFac
      _RL velDragHeightFac
      INTEGER I, J

C     Held and Suarez drag formulation
C     Drag is the inverse of a spin-down time-scale
C     ( typically 1 - 10 days ).
C     Drag decays linearly with height up to some
C     critical level above the ground, then drag stays at zero.
C     At ground drag is inversely proportional to an
C     approximate synoptic system "spin-down" timescale.
      uKf                   = 1. _d 0/tauSynopSpinDown
      levelOfGround         = rC(Nr)+delR(Nr)*0.5 _d 0
      heightAboveGround     = rC(kLev)
      criticalLevel         = bottomDragHeightScale * levelOfGround
      dist1                 = heightAboveGround-criticalLevel
      dist2                 = levelOfGround    -criticalLevel
      decayFac              = MAX(0.,dist1/dist2)
      velDragHeightFac      = decayFac*uKf
      DO J=jMin,jMax
       DO I=iMin,iMax
        gV(i,j,kLev,bi,bj) =
     &  gV(i,j,kLev,bi,bj) - velDragHeightFac*vVel(i,j,kLev,bi,bj)
       ENDDO
      ENDDO

      RETURN
      END
CStartOfInterface
      SUBROUTINE EXTERNAL_FORCING_T(
     I           iMin, iMax, jMin, jMax,bi,bj,kLev,
     I           myCurrentTime,myThid)
C     /==========================================================\
C     | S/R EXTERNAL_FORCING_T                                   |
C     | o Contains problem specific forcing for temperature.     |
C     |==========================================================|
C     | Adds terms to gT for forcing by external sources         |
C     | e.g. heat flux, climatalogical relaxation..............  |
C     \==========================================================/

C     == Global data ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "DYNVARS.h"
#include "FFIELDS.h"

C     == Routine arguments ==
C     iMin - Working range of tile for applying forcing.
C     iMax
C     jMin
C     jMax
C     kLev
      INTEGER iMin, iMax, jMin, jMax, kLev, bi, bj
      INTEGER myCurrentTime, myThid
CEndOfInterface
C     == Local variables ==
C     I, J - Loop counters
      INTEGER I, J

      DO J=1,sNy
       DO I=1,sNx
        gT(i,j,kLev,bi,bj) =
     &  gT(i,j,kLev,bi,bj)
     &  -(tauThetaEq(j,kLev,bj)*(1+tauThetaRFac(i,j,bi,bj)) )
     &  *_hFacC(i,j,kLev,bi,bj)*_recip_hFacC(i,j,kLev,bi,bj)
     &  *( theta(i,j,kLev,bi,bj)-thetaEq(j,kLev,bj) )
       ENDDO
      ENDDO

      RETURN
      END
CStartOfInterface
      SUBROUTINE EXTERNAL_FORCING_S(
     I           iMin, iMax, jMin, jMax,bi,bj,kLev,
     I           myCurrentTime,myThid)
C     /==========================================================\
C     | S/R EXTERNAL_FORCING_S                                   |
C     | o Contains problem specific forcing for merid velocity.  |
C     |==========================================================|
C     | Adds terms to gS for forcing by external sources         |
C     | e.g. fresh-water flux, climatalogical relaxation.......  |
C     \==========================================================/

C     == Global data ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "DYNVARS.h"

C     == Routine arguments ==
C     iMin - Working range of tile for applying forcing.
C     iMax
C     jMin
C     jMax
C     kLev
      INTEGER iMin, iMax, jMin, jMax, kLev, bi, bj
      INTEGER myCurrentTime, myThid
CEndOfInterface

      RETURN
      END
