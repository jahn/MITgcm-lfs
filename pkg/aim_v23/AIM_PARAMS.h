C $Header$
C $Name$

#ifdef ALLOW_AIM
C     *==========================================================*
C     | AIM_PARAMS.h  
C     | o Header file for AIM package parameters 
C     |   e.g.: output/input file & parameters;
C     |         forcing & interface parameters;
C     *==========================================================*

C--   COMMON /AIM_PARM_L/ Logical valued parameters for AIM
C     aim_useFMsurfBC :: select surface B.C. from Franco Molteni
C     aim_useMMsurfFc :: select Monthly Mean surface forcing (e.g., NCEP)
C     aim_surfPotTemp :: surf.Temp input file is in Pot.Temp (aim_useMMsurfFc)
      COMMON /AIM_PARM_L/ 
     &  aim_useFMsurfBC, aim_useMMsurfFc, aim_surfPotTemp
      LOGICAL aim_useFMsurfBC
      LOGICAL aim_useMMsurfFc
      LOGICAL aim_surfPotTemp

C--   COMMON /AIM_PARM_C/ Character valued parameters for AIM
C     aim_MMsufx   :: sufix for all Monthly Mean surface forcing files
C     aim_LandFile :: file name for Land fraction       (F.M. surfBC)
C     aim_albFile  :: file name for Albedo input file   (F.M. surfBC)
C     aim_vegFile  :: file name for vegetation fraction (F.M. surfBC)
C     aim_sstFile  :: file name for  Sea.Surf.Temp      (F.M. surfBC)
C     aim_lstFile  :: file name for Land.Surf.Temp      (F.M. surfBC)
C     aim_oiceFile :: file name for Sea Ice fraction    (F.M. surfBC)
C     aim_snowFile :: file name for Snow depth          (F.M. surfBC)
C     aim_swcFile  :: file name for Soil Water content  (F.M. surfBC)
      COMMON /AIM_PARM_C/
     &  aim_MMsufx,
     &  aim_LandFile, aim_albFile, aim_vegFile, 
     &  aim_sstFile, aim_lstFile, aim_oiceFile, aim_snowFile,
     &  aim_swcFile
      CHARACTER*(MAX_LEN_FNAM) aim_MMsufx
      CHARACTER*(MAX_LEN_FNAM) aim_LandFile
      CHARACTER*(MAX_LEN_FNAM) aim_albFile
      CHARACTER*(MAX_LEN_FNAM) aim_vegFile
      CHARACTER*(MAX_LEN_FNAM) aim_sstFile
      CHARACTER*(MAX_LEN_FNAM) aim_lstFile
      CHARACTER*(MAX_LEN_FNAM) aim_oiceFile
      CHARACTER*(MAX_LEN_FNAM) aim_snowFile
      CHARACTER*(MAX_LEN_FNAM) aim_swcFile

C--   COMMON /AIM_PARM_I/ Integer valued parameters for AIM
C     aim_MMsufxLength :: Length of sufix (Monthly Mean surf. forcing files)
      COMMON /AIM_PARM_I/
     &  aim_MMsufxLength
      INTEGER aim_MMsufxLength

C--   COMMON /AIM_PARM_R/ "Real" valued parameters for AIM
C     aim_dragStrato :: stratospheric-drag damping time scale (s)
C     aim_taveFreq :: Frequency^-1 for time-average output (s)
C     aim_diagFreq :: Frequency^-1 for diagnostic output (s)
C     aim_tendFreq :: Frequency^-1 for tendencies output (s)
      COMMON /AIM_PARM_R/ 
     &  aim_dragStrato,
     &  aim_taveFreq, aim_diagFreq, aim_tendFreq
      _RL aim_dragStrato
      _RL aim_taveFreq
      _RL aim_diagFreq
      _RL aim_tendFreq

#endif /* ALLOW_AIM */ 
