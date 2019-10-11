/*********************************************************************/
/*   PROGRAM-------- SED130CL                                        */
/*   DATE WRITTEN---  9/24/97                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- PRINT WEEKLY SEED REPORT                        */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             CALL       PGM(SED13A)
             QSYS/RTVDTAARA DTAARA(*LDA (1 1)) RTNVAR(&EOJ)
             QSYS/RTVDTAARA DTAARA(*LDA (17 10)) RTNVAR(&PRT)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))
             CLRPFM     FILE(ITEMSUM)
             CALL       PGM(SED212B)
 END:        ENDPGM
