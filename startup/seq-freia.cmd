epicsEnvSet("AUTOSAVE_SYSM_PV_PREFIX","seq:")
dbLoadRecords("seq-freia-gen.db","P=$(P)")
dbLoadRecords("seq-freia.db","P=$(P)")
dbLoadRecords("seq-freia-cRIO-ADC.db","P=$(P), INDX=2, NAME=Cav1-Coupl:MultipactDet:I, EGU=mA, LINR=LINEAR, LOPR=0.0, HOPR=10.0, EOFF=0.0, ESLO=0.001")
dbLoadRecords("seq-freia-cRIO-ADC.db","P=$(P), INDX=3, NAME=Cav2-Coupl:MultipactDet:I, EGU=mA, LINR=LINEAR, LOPR=0.0, HOPR=10.0, EOFF=0.0, ESLO=0.001")


requireSnippet(seq-freia-preSaveRestore.cmd)

iocInit

requireSnippet(seq-freia-postSaveRestore.cmd)

#############################################
## Sequence programs to load               ##
#############################################

## Start any sequence programs
seq copy_PMD "p1=$(P)"
