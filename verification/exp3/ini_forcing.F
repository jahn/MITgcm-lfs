C $Header$

#include "CPP_EEOPTIONS.h"

CStartOfInterface
      SUBROUTINE INI_FORCING( myThid )
C     /==========================================================\
C     | SUBROUTINE INI_FORCING                                   |
C     | o Set model initial forcing fields.                      |
C     \==========================================================/

C     === Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "DYNVARS.h"
#include "FFIELDS.h"

C     == Routine arguments ==
C     myThid -  Number of this instance of INI_FORCING
      INTEGER myThid
CEndOfInterface

C     == Local variables ==
C     iG, jG - Global coordinate index
C     bi,bj  - Loop counters
C     I,J,K
C     distY  - Distance accross domain of point j
C     lY     - Width of the basin ( last point is land )
C     tauMax - Peak zonal wind stress ( N/m^2 )
C     tauX   - Local zonal wind stress
      INTEGER iG, jG
      INTEGER bi, bj
      INTEGER  I,  J, K
      _RL distY
      _RL lY
      _RL tauX, tauMax
C     Held Suarez initialisation
      _RL p0, term1, term2
      _RL kA, kS, kT, heightFac, phi, dist1, dist2
      _RL heightAboveGround, levelOfGround, criticalLevel
      _RL tMin, thKAPPA
      _RL DRAND
      EXTERNAL DRAND

C--   Initialise forcing term
C     Held and Suarez radiative equilibrium potential temp profile
C     and relaxation time scale.
      CALL SRAND(123)
      thKAPPA=.28571428571428571428
      DO bj=myByLo(myThid),myByHi(myThid)
       DO K=1,Nr
        DO J=1,sNy
         phi = yC(1,j,1,bj)
         p0  = pGround
         term1 = poleEqThetaDrop*(sin(phi*deg2rad)**2)
         term2 = 
     &    verticalThetaDrop*log(rC(K)/p0)
     &   *(cos(phi*deg2rad)**2)
         thetaEq(j,k,bj)=315-term1-term2
         tMin=200./((rC(K)/p0)**thKAPPA)
         thetaEq(j,k,bj)=MAX(tMin,thetaEq(j,k,bj))
         levelOfGround      = rC(Nr)+delR(Nr)*0.5 _d 0
         heightAboveGround  = rC(K)
         criticalLevel      = bottomDragHeightScale * levelOfGround
         dist1              = heightAboveGround-criticalLevel
         dist2              = levelOfGround    -criticalLevel
         heightFac          = MAX(0.,dist1/dist2)
         kA = 1. _d 0 / tauThetaEquiLong
         kS = 1. _d 0 / tauThetaEquiShort
         kT = kA + (kS-kA)*heightFac*((cos(phi*deg2rad))**4)
         tauThetaEq(J,K,bj) = kT
        ENDDO
       ENDDO
      ENDDO
C     Add randomness to seed instability.
      CALL SRAND(123)
      DO bj=myByLo(myThid),myByHi(myThid)
       DO bi=myBxLo(myThid),myBxHi(myThid)
        DO J=1,sNy
         DO I=1,sNx
          thetaEq(j,k,bj)=thetaEq(j,k,bj) + 0.005*thetaEq(j,k,bj)*(DRAND()-0.5)
          tauThetaRFac(i,j,bi,bj) = 0.005*(DRAND()-0.5)
         ENDDO
        ENDDO
       ENDDO
      ENDDO

      WRITE(0,*) 'MAXVAL(tauThetaEq)',MAXVAL(tauThetaEq)
      WRITE(0,*) 'MINVAL(tauThetaEq)',MINVAL(tauThetaEq)
      WRITE(0,*) 'MAXVAL(tauThetaRFac)',MAXVAL(tauThetaRFac)
      WRITE(0,*) 'MINVAL(tauThetaRFac)',MINVAL(tauThetaRFac)
      WRITE(0,*) 'MAXVAL(thetaEq)',MAXVAL(thetaEq)
      WRITE(0,*) 'MINVAL(thetaEq)',MINVAL(thetaEq)

      _BARRIER

C--   Set initial temp. to radiative equilibrium temp
      DO bj = myByLo(myThid), myByHi(myThid)
       DO bi = myBxLo(myThid), myBxHi(myThid)
        DO K=1,Nr
         DO J=1,sNy
          DO I=1,sNx
           theta(I,J,K,bi,bj) = thetaEq(j,k,bj)
           IF ( hFacC(i,j,k,bi,bj) .EQ. 0. )
     &      theta(I,J,K,bi,bj) = 0.
          ENDDO
         ENDDO
        ENDDO
       ENDDO
      ENDDO

      _EXCH_XYZ_R8(theta , myThid )
      CALL PLOT_FIELD_XYZRL( theta, 'Initial Temperature' , Nr, 1, myThid )


      RETURN
      END
