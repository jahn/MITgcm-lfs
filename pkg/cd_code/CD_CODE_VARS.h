C $Header$
C $Name$

C     uVelD  - D grid zonal velocity
C     vVelD  - D grid meridional velocity

#ifdef ALLOW_CD_CODE
      COMMON /DYNVARS_CD/ 
     &                   uVelD, vVelD,
     &                   etaNm1,
     &                   uNM1,  vNM1
      _RL  uVeld (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      _RL  vVeld (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      _RL  etaNm1(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL  uNm1  (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      _RL  vNm1  (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
#endif /*  ALLOW_CD_CODE  */

