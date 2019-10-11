             PGM        PARM(&DATETIME)
             DCL        VAR(&P) TYPE(*CHAR) LEN(10)
             DCL        VAR(&T) TYPE(*CHAR) LEN(30)
             DCL        VAR(&DATETIME) TYPE(*CHAR) LEN(20)
             DCL        VAR(&DFTPATH) TYPE(*CHAR) LEN(256) VALUE('/Kube +
                          Pak/PDF/PRODUCTION_REPORTS/UPDATES/')
             DCL        VAR(&QRY)     TYPE(*CHAR) LEN(10)  VALUE(' ')
             DCL        VAR(&PATH)    TYPE(*CHAR) LEN(256) VALUE('*NONE')
             DCL        VAR(&CPI)     TYPE(*DEC) LEN(4 1)  VALUE(15.0)
             DCL        VAR(&PAGRTT)  TYPE(*DEC) LEN(3 0)  VALUE(0)
             DCL        VAR(&DEVTYPE) TYPE(*CHAR) LEN(10)  VALUE('*SCS')
             DCL        VAR(&WSCST)   TYPE(*CHAR) LEN(10)  VALUE('*NONE')

             RTVJOBA    PRTTXT(&T)
/* 02/11/19  RTVJOBA    DATETIME(&DATETIME)  NOW THIS IS PASSED IN  */
             RTVDTAARA  DTAARA(SOWQRYCL (1 10)) RTNVAR(&P)

             CALLSUBR   SUBR(GROWERS)
             CALLSUBR   SUBR(UPDATE1)
             CALLSUBR   SUBR(UPDATE2)

             CHGVAR     VAR(&PATH) VALUE(&DFTPATH *TCAT &DATETIME)
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
             CHGJOB     PRTTXT('UPDATE - Growers Office Copy')
             CALLSUBR   SUBR(ALL_UPDTS)
             ENDSUBR
/*============================================================================*/
             SUBR       SUBR(UPDATE1)
             CHGJOB     PRTTXT('UPDATE - Production Copy 1')
             CALLSUBR   SUBR(ALL_UPDTS)
             ENDSUBR
/*============================================================================*/
             SUBR       SUBR(UPDATE2)
             CHGJOB     PRTTXT('UPDATE - Production Copy 2')
             CALLSUBR   SUBR(ALL_UPDTS)
             ENDSUBR
/*============================================================================*/
             SUBR       SUBR(OFFICE)
             CHGJOB     PRTTXT('UPDATE - Office Archive Copy')
             CALLSUBR   SUBR(ALL_UPDTS)
             ENDSUBR
/*============================================================================*/
             SUBR       SUBR(ALL_UPDTS)

             CHGVAR     VAR(&QRY) VALUE('PLUSU51B  ')
             CALLSUBR   SUBR(RUNQRY)
             CHGVAR     VAR(&QRY) VALUE('PLUSU51D  ')
             CALLSUBR   SUBR(RUNQRY)
             CHGVAR     VAR(&QRY) VALUE('PLUSU51R  ')
             CALLSUBR   SUBR(RUNQRY)

             CHGVAR     VAR(&QRY) VALUE('PLUSU288B ')
             CALLSUBR   SUBR(RUNQRY)
             CHGVAR     VAR(&QRY) VALUE('PLUSU288D ')
             CALLSUBR   SUBR(RUNQRY)
             CHGVAR     VAR(&QRY) VALUE('PLUSU288R ')
             CALLSUBR   SUBR(RUNQRY)

             CHGVAR     VAR(&QRY) VALUE('PLUSU162  ')
             CALLSUBR   SUBR(RUNQRY)

             CHGVAR     VAR(&QRY) VALUE('PLUSU072  ')
             CALLSUBR   SUBR(RUNQRY)
             CHGVAR     VAR(&QRY) VALUE('PLUSU072A ')
             CALLSUBR   SUBR(RUNQRY)
             CHGVAR     VAR(&QRY) VALUE('PLUSU0050 ')
             CALLSUBR   SUBR(RUNQRY)
             CHGVAR     VAR(&QRY) VALUE('ROOSU072  ')
             CALLSUBR   SUBR(RUNQRY)
             CHGVAR     VAR(&QRY) VALUE('PLUGUSEEDS')
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
             RUNQRY     QRY(&QRY) OUTTYPE(*PRINTER) PRTDEV(&P) COPIES(1)
             DLTOVR     FILE(QPQUPRFIL) LVL(*JOB)
             ENDSUBR
/*============================================================================*/
             ENDPGM
