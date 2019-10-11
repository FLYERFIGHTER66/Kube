             PGM

             CHGDTAARA  DTAARA(*LDA (1 2)) VALUE('01')

             QSYS/OVRPRTF FILE(BIR430) TOFILE(*LIBL/QSYSPRT) +
                          DEV(PRT01) PAGESIZE(66 132) LPI(6) +
                          CPI(10) ALIGN(*NO) FORMTYPE(*NAR)

             CALL       PGM(BIR430)






             ENDPGM
