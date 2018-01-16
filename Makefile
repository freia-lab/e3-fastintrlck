EXCLUDE_ARCHS += eldk
EXCLUDE_VERSIONS = 3.14

include $(EPICS_ENV_PATH)/module.Makefile

PROJECT=ioc_seq_freia

# USR_DEPENDENCIES = 
USR_DEPENDENCIES += autosave,5.7+

#MISCS = $(AUTOMISCS)
MISCS += misc/ioc-seq-freia.req
OPIS = opi
