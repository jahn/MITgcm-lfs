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

      _BARRIER

      DO bj = myByLo(myThid), myByHi(myThid)
       DO bi = myBxLo(myThid), myBxHi(myThid)
        DO j=1-OLy,sNy+OLy
         DO i=1-OLx,sNx+OLx
          fu(i,j,bi,bj) = 0. _d 0
          fv(i,j,bi,bj) = 0. _d 0
         ENDDO
        ENDDO
       ENDDO
      ENDDO

C--   Initialise surface bc arrays
      IF ( zonalWindFile .EQ. ' ' ) THEN
C      In cartesian yc, delY and ly are meters.
C      In spherical polar yc, delY and ly are degrees
       tauMax = 0.1 _d 0
       lY = 0. _d 0
       DO j=1,nY-3
        lY = lY + delY(j)
       ENDDO
       DO bj = myByLo(myThid), myByHi(myThid)
        DO bi = myBxLo(myThid), myBxHi(myThid)
         DO j=1,sNy
          DO i=1,sNx
           distY = (yC(i,j,bi,bj)-yC0)/lY
C          tauX  = -tauMax*cos(2. _d 0*PI*distY)
           tauX  = tauMax*sin(PI*distY)
           fu(i,j,bi,bj) = tauX/(delZ(1)*rhonil)
          ENDDO
         ENDDO
        ENDDO
       ENDDO
C      fu(4,4,1,1) = fu(4,4,1,1)*0.917d0
      ENDIF
C
      _BARRIER

      IF ( meridWindFile .EQ. ' ' ) THEN
       DO bj = myByLo(myThid), myByHi(myThid)
        DO bi = myBxLo(myThid), myBxHi(myThid)
         DO j=1-OLy,sNy+OLy
          DO i=1-OLx,sNx+OLx
           fv(i,j,bi,bj) = 0./(delZ(1)*rhonil)
          ENDDO
         ENDDO
        ENDDO
       ENDDO
      ENDIF
C
      _EXCH_XY_R4(fu  , myThid )
      _EXCH_XY_R4(fv  , myThid )

      CALL PLOT_FIELD_XYRS( fu, 'S/R INI_FORCING FU',1,myThid)
      CALL PLOT_FIELD_XYRS( fv, 'S/R INI_FORCING FV',1,myThid)

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
c        thetaEq(j,k,bj)=thetaEq(j,k,bj) + 0.005*thetaEq(j,k,bj)*(DRAND()-0.5)
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

      DO bj=myByLo(myThid),myByHi(myThid)
       DO bi=myBxLo(myThid),myBxHi(myThid)
        DO J=1,sNy
         DO I=1,sNx
c         tauThetaRFac(i,j,bi,bj) = 0.005*(DRAND()-0.5)
          tauThetaRFac(i,j,bi,bj) = 0.
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
