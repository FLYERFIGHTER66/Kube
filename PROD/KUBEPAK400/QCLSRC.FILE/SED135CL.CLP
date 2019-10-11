/*********************************************************************/
/*   PROGRAM-------- SED135CL                                        */
/*   DATE WRITTEN---  9/24/97                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- PRINT SEASON SEED REPORT                        */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&EOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DORS) TYPE(*CHAR) LEN(11)

             CALL       PGM(SED13B)

             RTVDTAARA  DTAARA(*LDA (1 1)) RTNVAR(&EOJ)
             RTVDTAARA  DTAARA(*LDA (17 10)) RTNVAR(&PRT)

             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))
             RTVDTAARA  DTAARA(*LDA (40 1)) RTNVAR(&DORS)

             IF         COND(&DORS = 'D') THEN(GOTO CMDLBL(DETL))
 SUMMARY:    OVRPRTF    FILE(SED130) TOFILE(*LIBL/QSYSPRT) +
                          PAGESIZE(88 120) LPI(8) CPI(15) +
                          ALIGN(*NO) OUTQ(XERPRT01) FORMTYPE(*NAR)
             CALL       PGM(SED130)
             GOTO       CMDLBL(END)

 DETL:       CLRPFM     FILE(TGMSDATA/FSLABL)
             CALL       PGM(SED212A)
             RUNQRY     QRY(PLUGXAL)
             RUNQRY     QRY(PLUGXALUR)

 END:        ENDPGM
