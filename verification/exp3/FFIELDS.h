C $Header$
C
C     /==========================================================\
C     | FFIELDS.h                                                |
C     | o Model forcing fields                                   |
C     |==========================================================|
C     | The arrays here will need changing and customising for a |
C     | particular experiment.                                   |
C     \==========================================================/
C
C--   Terms for a Held Suarez atmosphere 
C     thetaEq    - Held and Suarez radiative equilibrium pot. temp
C     tauThetaEq   and relaxation time scale. Including random factor
C     tauThetaRFac to seed instabilities.
      COMMON /FFIELDS/
     &                 thetaEq, tauThetaEq, tauThetaRFac
      _RL thetaEq   (1:sNy,Nr,nSy)
      _RL tauThetaEq(1:sNy,Nr,nSy)
      _RL tauThetaRFac(1:sNy,1:sNx,nSx,nSy)
