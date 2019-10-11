             PGM        PARM(&DATETIME)
             DCL        VAR(&P) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P_BS) TYPE(*CHAR) LEN(10) +
                          VALUE('P9        ')
             DCL        VAR(&T) TYPE(*CHAR) LEN(30)
             DCL        VAR(&DATETIME) TYPE(*CHAR) LEN(20)
             DCL        VAR(&DFTPATH) TYPE(*CHAR) LEN(256) VALUE('/Kube +
                          Pak/PDF/PRODUCTION_REPORTS/RECAPS/')
             DCL        VAR(&QRY)     TYPE(*CHAR) LEN(10)  VALUE(' ')
             DCL        VAR(&PATH)    TYPE(*CHAR) LEN(256) VALUE('*NONE')
             DCL        VAR(&CPI)     TYPE(*DEC) LEN(4 1)  VALUE(15.0)
             DCL        VAR(&PAGRTT)  TYPE(*DEC) LEN(3 0)  VALUE(0)
             DCL        VAR(&DEVTYPE) TYPE(*CHAR) LEN(10)  VALUE('*SCS')
             DCL        VAR(&WSCST)   TYPE(*CHAR) LEN(10)  VALUE('*NONE')

             RTVJOBA    PRTTXT(&T)
/* 02/11/19  RTVJOBA    DATETIME(&DATETIME)  NOW THIS IS PASSED IN  */
             RTVDTAARA  DTAARA(SOWQRYCL (1 10)) RTNVAR(&P)
             CHGVAR     VAR(&PRT) VALUE(&P)

             CALLSUBR   SUBR(GROWERS)
             CALLSUBR   SUBR(PRODUCTION)
             CALLSUBR   SUBR(ADDL_REPTS)

             CHGVAR     VAR(&PRT) VALUE(&P_BS)
             CALLSUBR   SUBR(BILL_REPTS)
             CHGVAR     VAR(&PRT) VALUE(&P)

             CHGVAR     VAR(&PATH)    VALUE(&DFTPATH *TCAT &DATETIME)
             CHGVAR     VAR(&DEVTYPE) VALUE('*AFPDS')
             CHGVAR     VAR(&WSCST  ) VALUE('*PDF')

             CRTDIR     DIR(&PATH)
             CHGVAR     VAR(&DFTPATH) VALUE(&PATH *TCAT '/')
             CALLSUBR   SUBR(OFFICE)

             CHGJOB     PRTTXT(&T)

/*============================================================================*/
/*           S U B R O U T I N E S                                            */
/*============================================================================*/
             SUBR       SUBR(GROWERS)
             CHGJOB     PRTTXT('RECAP - Growers Office Copy')
             CALLSUBR   SUBR(ALL_RECAP)
             ENDSUBR
/*============================================================================*/
             SUBR       SUBR(PRODUCTION)
             CHGJOB     PRTTXT('RECAP - Production Reports')
             CALLSUBR   SUBR(ALL_RECAP)
             ENDSUBR
/*============================================================================*/
             SUBR       SUBR(OFFICE)
             CHGJOB     PRTTXT('RECAP - Office Archive Copy')
             CALLSUBR   SUBR(ALL_RECAP)
             ENDSUBR
/*============================================================================*/
             SUBR       SUBR(ADDL_REPTS)
             CHGJOB     PRTTXT('RECAP - Add''l Recap Reports')
             CHGVAR     VAR(&QRY) VALUE('TRANR072')
             CALLSUBR   SUBR(RUNQRY)
             CHGVAR     VAR(&QRY) VALUE('ROOTR072')
             CALLSUBR   SUBR(RUNQRY)
             ENDSUBR
/*============================================================================*/
             SUBR       SUBR(BILL_REPTS)
             CHGJOB     PRTTXT('RECAP - Bill Swanekamp''s Copy')
             CHGVAR     VAR(&QRY) VALUE('TRANR072')
             CALLSUBR   SUBR(RUNQRY)
             CHGVAR     VAR(&QRY) VALUE('ROOTR072')
             CALLSUBR   SUBR(RUNQRY)
             ENDSUBR
/*============================================================================*/
             SUBR       SUBR(ALL_RECAP)
             CHGVAR     VAR(&QRY) VALUE(PLUGR48)
             CALLSUBR   SUBR(RUNQRY)
             CHGVAR     VAR(&QRY) VALUE('PLUGR51D')
             CALLSUBR   SUBR(RUNQRY)
             CHGVAR     VAR(&QRY) VALUE('PLUGR51R')
             CALLSUBR   SUBR(RUNQRY)
             CHGVAR     VAR(&QRY) VALUE('PLUGR288D')
             CALLSUBR   SUBR(RUNQRY)
             CHGVAR     VAR(&QRY) VALUE('PLUGR288R')
             CALLSUBR   SUBR(RUNQRY)
             CHGVAR     VAR(&QRY) VALUE('PLUGR162')
             CALLSUBR   SUBR(RUNQRY)
             CHGVAR     VAR(&QRY) VALUE('PLUGR072')
             CALLSUBR   SUBR(RUNQRY)
             CHGVAR     VAR(&QRY) VALUE('PLUGRTOT')
             CALLSUBR   SUBR(RUNQRY)
             CHGVAR     VAR(&QRY) VALUE('TRANR072')
             CALLSUBR   SUBR(RUNQRY)
             CHGVAR     VAR(&QRY) VALUE('ROOTR072')
             CALLSUBR   SUBR(RUNQRY)
             ENDSUBR
/*============================================================================*/
             SUBR       SUBR(RUNQRY)
             IF         COND(&PATH *NE '*NONE') THEN(CHGVAR +
                          VAR(&PATH) VALUE(&DFTPATH *TCAT &QRY +
                          *TCAT '.pdf'))
             OVRPRTF    FILE(QPQUPRFIL) DEVTYPE(&DEVTYPE) CPI(&CPI) +
                          PAGRTT(&PAGRTT) USRDTA(&QRY) +
                          TOSTMF(&PATH) WSCST(&WSCST) OVRSCOPE(*JOB)
             RUNQRY     QRY(&QRY) OUTTYPE(*PRINTER) PRTDEV(&PRT) COPIES(1)
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             ENDSUBR
/*============================================================================*/
             ENDPGM
