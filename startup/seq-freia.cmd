dbLoadRecords("seq-freia.db","P=$(P)")
iocInit
#############################################
## Sequence programs to load               ##
#############################################

## Start any sequence programs
seq copy_PMD "p1=$(P)"
