C $Header$

#include "CPP_OPTIONS.h"
 
CStartOfInterface
      SUBROUTINE LOAD_EXTERNAL_FIELDS( myTime, myIter, myThid )
C     /==========================================================\
C     | SUBROUTINE LOAD_EXTERNAL_FIELDS                          |
C     | o Control reading of fields from external source.        |
C     |==========================================================|
C     | External source field loading routine.                   |
C     | This routine is called every time we want to             |
C     | load a a set of external fields. The routine decides     |
C     | which fields to load and then reads them in.             |
C     | This routine needs to be customised for particular       |
C     | experiments.                                             |
C     | Notes                                                    |
C     | =====                                                    |
C     | Two-dimensional and three-dimensional I/O are handled in |
C     | the following way under MITgcmUV. A master thread        |
C     | performs I/O using system calls. This threads reads data |
C     | into a temporary buffer. At present the buffer is loaded |
C     | with the entire model domain. This is probably OK for now|
C     | Each thread then copies data from the buffer to the      |
C     | region of the proper array it is responsible for.        |
C     \==========================================================/
 
C     === Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "CG2D.h"
 
C     === Routine arguments ===
C     myThid - Thread no. that called this routine.
C     myTime - Simulation time
C     myIter - Simulation timestep number
      INTEGER myThid
      REAL    myTime
      INTEGER myIter
CEndOfInterface
 
C     === Local variables ===

C     Simple example where we do nothing
      RETURN
      END
