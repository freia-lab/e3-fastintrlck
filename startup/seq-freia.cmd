epicsEnvSet("AUTOSAVE_SYSM_PV_PREFIX","seq:")
dbLoadRecords("seq-freia-gen.db","P=$(P)")
dbLoadRecords("seq-freia.db","P=$(P)")
#dbLoadRecords("seq-freia.db")

requireSnippet(seq-freia-preSaveRestore.cmd)

iocInit

requireSnippet(seq-freia-postSaveRestore.cmd)

#############################################
## Sequence programs to load               ##
#############################################

## Start any sequence programs
seq copy_PMD "p1=$(P)"
