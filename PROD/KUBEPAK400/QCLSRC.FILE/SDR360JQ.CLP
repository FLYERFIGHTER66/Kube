/*********************************************************************/
/*   PROGRAM-------- SDR360JQ                                        */
/*   DATE WRITTEN--- 08/18/03                                        */
/*   PROGRAMMER----- Richard E. Piasecki                             */
/*   DESCRIPTION---- Cost/Price Report within dates                  */
/*********************************************************************/
             PGM   PARM(&FDAT &TDAT &SORT)
/*           QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)       */
             QSYS/DCL   VAR(&FDAT) TYPE(*CHAR) LEN(8)
             QSYS/DCL   VAR(&TDAT) TYPE(*CHAR) LEN(8)
             QSYS/DCL   VAR(&SORT) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)

/* INSERTED HERE TO                                            */
             CLRPFM     FILE(SDR360WK)
             CALL       PGM(SDC361R) PARM(&FDAT &TDAT)
/*?Determine Sort Sequence                         ?           */

             IF         COND(&SORT = 'S') THEN(DO)
                 GOTO       CMDLBL(SIZE)
             ENDDO
             IF         COND(&SORT = 'P') THEN(DO)
                 GOTO       CMDLBL(PRICECODE)
             ENDDO
             IF         COND(&SORT = 'Q') THEN(DO)
                 GOTO       CMDLBL(QUANTITY)
             ENDDO
             GOTO       CMDLBL(EOJ)

SIZE:       /*  SORTED BY SIZE CODE  */
             OVRDBF     FILE(SDR360WK) SHARE(*YES)
             OPNQRYF    FILE((SDR360WK)) KEYFLD((WKSIZE) (WKFRSZ) +
                          (WKLOOK)) OPNSCOPE(*JOB)
             GOTO       CMDLBL(GETPRT)

PRICECODE:  /*  SORTED BY PRICE CODE  */
             OVRDBF     FILE(SDR360WK) SHARE(*YES)
             OPNQRYF    FILE((SDR360WK)) KEYFLD((WKSIZE) (WKFRSZ) +
                          (WKLIST) (WKLOOK)) OPNSCOPE(*JOB)
             GOTO       CMDLBL(GETPRT)

QUANTITY:   /*  SORTED BY ALLPHA      */
             OVRDBF     FILE(SDR360WK) SHARE(*YES)
             OPNQRYF    FILE((SDR360WK)) KEYFLD((WKSIZE *ASCEND) +
                          (WKFRSZ *ASCEND) (WKQSHP *DESCEND) +
                          (WKLOOK *ASCEND)) OPNSCOPE(*JOB)
             GOTO       CMDLBL(GETPRT)


GETPRT:
             OVRPRTF FILE(SDR362P) OUTQ(&PRT)            +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(15) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)

 PRTOK:
             CALL       PGM(SDR362R)

             CLOF       OPNID(SDR360WK)
             DLTOVR     FILE(*ALL)

 EOJ:        ENDPGM
