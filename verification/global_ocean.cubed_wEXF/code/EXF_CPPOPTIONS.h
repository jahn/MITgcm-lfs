C $Header$
C
#include "CPP_OPTIONS.h"
C 
C CPP flags controlling which code is included in the files that
C will be compiled.
C


 
c       Do a bit more printout for the log file than usual.
#define  EXTERNAL_FORCING_VERBOSE


#define ALLOW_BULKFORMULAE
c       Use bulk formulae to in order to estimate the turbulent
c       fluxes at the ocean's surface.

#define ALLOW_ATM_TEMP
c       If defined use the atmospheric temperature and specific
c       humidity to estimate the sensible and latent heat fluxes.

#undef   ALLOW_ATM_WIND
c       If defined use the atmospheric wind field to estimate the
c       wind stress at the ocean's surface.

c   >>> ALLOW_CLIMTEMP_RELAXATION <<<
c       Allow the relaxation to a monthly climatology of potential
c       temperature, e.g. the Levitus climatology.

c   >>> ALLOW_CLIMSALT_RELAXATION <<<
c       Allow the relaxation to a monthly climatology of salinity,
c       e.g. the Levitus climatology.

#undef ALLOW_CLIMSST_RELAXATION
c       Allow the relaxation to a monthly climatology of sea surface
c       temperature, e.g. the Reynolds climatology.

#undef ALLOW_CLIMSSS_RELAXATION
c       Allow the relaxation to a monthly climatology of sea surface
c       salinity, e.g. the Levitus climatology.


#define ALLOW_EXF_TIMEAVE
C       create time averages
