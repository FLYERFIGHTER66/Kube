/*   PROGRAM-------- APR010CL                                        */
/*   DATE WRITTEN---  4/26/99                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- VENDOR MASTER FILE                              */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&TYPE &VENDOR)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&TYPE  ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&VENDOR) TYPE(*CHAR) LEN(6)

             CHGDTAARA  DTAARA(*LDA) VALUE(' ')

             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('APR010')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('     Vendor +
                          Master File ')

             CALL       PGM(APC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CHGDTAARA  DTAARA(*LDA (172 6)) VALUE(&VENDOR)
             CHGDTAARA  DTAARA(*LDA (178 1)) VALUE(&TYPE)
             CALL       PGM(APR010)

 END:        ENDPGM
