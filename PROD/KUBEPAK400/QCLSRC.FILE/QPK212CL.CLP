/*********************************************************************/
/*   PROGRAM-------- QPK212CL                                        */
/*   DATE WRITTEN--- 09/23/98                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- SOW SHEETS                                      */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&TQRY) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PQRY) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&LAB) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&NSOW) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PATH)    TYPE(*CHAR) LEN(256) VALUE('*NONE')
             DCL        VAR(&DATETIME) TYPE(*CHAR) LEN(20)
             DCL        VAR(&DFTPATH) TYPE(*CHAR) LEN(256) +
                          VALUE('/KUBE PAK/PDF/PRODUCTION_REPORTS/RECAPS/')

             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')

             CALL       PGM(QPK212)

             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             RTVJOBA    DATETIME(&DATETIME)
             CHGVAR     VAR(&PATH) VALUE(&DFTPATH *TCAT &DATETIME)
             CRTDIR     DIR(&PATH)
             CHGVAR     VAR(&DFTPATH) VALUE(&PATH *TCAT '/')

             QSYS/RTVDTAARA DTAARA(*LDA (66 1)) RTNVAR(&TQRY)
             QSYS/RTVDTAARA DTAARA(*LDA (68 1)) RTNVAR(&PQRY)
             QSYS/RTVDTAARA DTAARA(*LDA (67 1)) RTNVAR(&LAB)
             QSYS/RTVDTAARA DTAARA(*LDA (69 1)) RTNVAR(&NSOW)

             CLRPFM     FILE(FLABL)

             OVRPRTF    FILE(PRINT) DEVTYPE(*AFPDS) PAGESIZE(66 132) +
                          LPI(6) CPI(15) TOSTMF(&PATH) WSCST(*PDF) +
                          OVRSCOPE(*JOB)

             OVRPRTF    FILE(LBLCNT) DEVTYPE(*AFPDS) PAGESIZE(66 132) +
                          LPI(6) CPI(15) TOSTMF(&PATH) WSCST(*PDF) +
                          OVRSCOPE(*JOB)

             QSYS/OVRPRTF FILE(LBCNT) TOFILE(XERPRT01) DEV(XERPRT01) +
                          PAGESIZE(66 132) LPI(6) CPI(15) +
                          OUTQ(*DEV) FORMTYPE(*NAR) COPIES(1) +
                          SAVE(*YES)

             CALL       PGM(QPK212A)

             DLTOVR     FILE(PRINT) LVL(*JOB)
             DLTOVR     FILE(LBLCNT) LVL(*JOB)

             IF         COND(&PQRY = 'N') THEN(GOTO CMDLBL(NQRY))
             IF         COND(&TQRY = '1') THEN(GOTO CMDLBL(PROD))
             IF         COND(&TQRY = '2') THEN(GOTO CMDLBL(UPDT))
             IF         COND(&TQRY = '3') THEN(GOTO CMDLBL(RECP))
 PROD:       CALL       PGM(SOWQRYCL) PARM(&DATETIME)
                        GOTO NQRY
 UPDT:       CALL       PGM(UPDQRYCL) PARM(&DATETIME)
                        GOTO NQRY
 RECP:       CALL       PGM(RECQRYCL) PARM(&DATETIME)

 NQRY:       IF         COND(&LAB = 'N') THEN(GOTO CMDLBL(NEWSOW))
             CALL       PGM(SOWLABLCL)

 NEWSOW:     IF         COND(&NSOW = 'N') THEN(GOTO CMDLBL(END))
             CALL       PGM(SOW020ACL)

 END:        CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')
             ENDPGM
