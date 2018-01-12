EXCLUDE_ARCHS += eldk
EXCLUDE_VERSIONS = 3.14

include $(EPICS_ENV_PATH)/module.Makefile

PROJECT=ioc_seq_freia

# USR_DEPENDENCIES = 
MISCS = $(AUTOMISCS)

OPIS = opi
#MISCS += misc/ioc-superv-freia.req
