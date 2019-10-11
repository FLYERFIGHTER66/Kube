/*********************************************************************/
/*   PROGRAM-------- BIC310CL                                        */
/*   DATE WRITTEN--- 01/17/96                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- PRINT PICK SLIPS                                */
/*   REVISIONS------                                                 */
/*   1/6/03  CHANGED OVERFLOW TO BIR316X &316    C.BUCK              */
/*           AND CHANGED CPI TO 10 FROM 15.                          */
/*  03/18/04 ADDED 4A FIELDS &PS1@ AND &PS2@ TO SPECIFY SAVE *YES/NO */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&NXT) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&SEL) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&PRT2) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&CPY1) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&CPY2) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&PS1) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PS2) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PS1@) TYPE(*CHAR) LEN(4)  /* WJB - 03/18/04 */
             QSYS/DCL   VAR(&PS2@) TYPE(*CHAR) LEN(4)  /* WJB - 03/18/04 */
             QSYS/DCL   VAR(&NBR) TYPE(*CHAR) LEN(6)
             QSYS/DCL   VAR(&FILE) TYPE(*CHAR) LEN(8)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&CARTRQ) TYPE(*CHAR) LEN(1) /* WJB - 04/18/05 */
             QSYS/DCL   VAR(&ORDSEQ) TYPE(*CHAR) LEN(1) /* WJB - 11/22/10 */
             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')

             STRPCO
             MONMSG     MSGID(IWS4010 IWS4032)

 NXT:        CALL       PGM(BIC310)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))
             IF         COND(&EOJ = 'F') THEN(GOTO CMDLBL(FIN))
             QSYS/RTVDTAARA DTAARA(*LDA (134 1)) RTNVAR(&NXT)
             QSYS/RTVDTAARA DTAARA(*LDA (49 1)) RTNVAR(&SEL)
             QSYS/RTVDTAARA DTAARA(*LDA (17 8)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (27 8)) RTNVAR(&PRT2)
             QSYS/RTVDTAARA DTAARA(*LDA (135 2)) RTNVAR(&CPY1)
             QSYS/RTVDTAARA DTAARA(*LDA (137 2)) RTNVAR(&CPY2)
             QSYS/RTVDTAARA DTAARA(*LDA (139 1)) RTNVAR(&PS1)
             QSYS/RTVDTAARA DTAARA(*LDA (140 1)) RTNVAR(&PS2)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
/* WJB */    QSYS/RTVDTAARA DTAARA(*LDA (141 1)) RTNVAR(&CARTRQ)
/* WJB */    QSYS/RTVDTAARA DTAARA(*LDA (142 1)) RTNVAR(&ORDSEQ)
/* WJB */    CHGVAR     VAR(&PS1@) VALUE('*NO')
/* WJB */    CHGVAR     VAR(&PS2@) VALUE('*NO')
/* WJB */    IF         COND(&PS1 *EQ 'Y') THEN(CHGVAR VAR(&PS1@) +
/* WJB */                 VALUE('*YES'))
/* WJB */    IF         COND(&PS2 *EQ 'Y') THEN(CHGVAR VAR(&PS2@) +
/* WJB */                 VALUE('*YES'))
             IF         COND(&SEL = '5') THEN(GOTO CMDLBL(ITEM))
             IF         COND(&SEL = '2') THEN(GOTO CMDLBL(SVIA))
             IF         COND(&SEL = '9') THEN(GOTO CMDLBL(TRUCK))
/* WJB */    QSYS/OVRPRTF FILE(BIR310) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 80) LPI(6) CPI(10) +
                          OVRFLW(55) ALIGN(*NO) FORMTYPE(*NAR) +
                          HOLD(&HOLD) SAVE(&PS1@) COPIES(&CPY1)

             IF         COND(&PRT2 > '       ') THEN(DO)
/* WJB */    QSYS/OVRPRTF FILE(BIR310X) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT2) PAGESIZE(66 80) LPI(6) CPI(10) +
                          OVRFLW(55) ALIGN(*NO) FORMTYPE(*NAR) +
                          HOLD(&HOLD) SAVE(&PS2@) COPIES(&CPY2)
                          ENDDO
             IF         COND(&ORDSEQ = 'Y') THEN(OVRDBF +
                          FILE(FIORDRSS) TOFILE(*LIBL/FIORDRSS2) +
                          MBR(*FIRST))
             CALL       PGM(BIR310)
             IF         COND(&ORDSEQ = 'Y') THEN(DLTOVR FILE(FIORDRSS))
             IF         COND(&NXT = 'N') THEN(GOTO CMDLBL(NXT))
                        GOTO END
 ITEM:       QSYS/OVRPRTF FILE(BIR312) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 80) LPI(6) CPI(10) +
                          ALIGN(*NO) FORMTYPE(*NAR) COPIES(&CPY1) +
                          SAVE(&PS1@)
             RTVJOBA    NBR(&NBR)
             CHGDTAARA  DTAARA(*LDA (200 2)) VALUE('WF')
             CHGDTAARA  DTAARA(*LDA (202 6)) VALUE(&NBR)
             RTVDTAARA  DTAARA(*LDA (200 8)) RTNVAR(&FILE)
             CLRPFM     FILE(&FILE)
             MONMSG     MSGID(CPF3142) EXEC(DO)
             CRTPF      FILE(&FILE) SRCFILE(KUBEPAK400/QDDSSRC) +
                          SRCMBR(WBIR312) OPTION(*NOSRC *NOLIST) +
                          LVLCHK(*NO)
             ENDDO
             OVRDBF     FILE(WBIR312) TOFILE(&FILE)
/* WJB */    CLRPFM     FILE(FMSTCRTS)
             CALL       PGM(BIR312)
             IF         COND(&CARTRQ *EQ 'Y') THEN(DO)
             CALL       PGM(BIR106) PARM(&PRT)
             ENDDO

             QSYS/OVRPRTF FILE(QPK312) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 80) LPI(6) CPI(10) +
                          ALIGN(*NO) FORMTYPE(*NAR)         +
                          SAVE(&PS1@) COPIES(&CPY1)
             OVRDBF     FILE(WBIR312) TOFILE(&FILE)
             CALL       PGM(QPK312)
             DLTF       FILE(&FILE)
                        GOTO END

 SVIA: /*    RUNQRY     QRY(SHIPVIA)     */
             QSYS/OVRPRTF FILE(BIR316) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 80) LPI(6) CPI(10) +
                          OVRFLW(55) ALIGN(*NO) FORMTYPE(*NAR) +
                          SAVE(&PS1@) COPIES(&CPY1)
             IF         COND(&PRT2 > '       ') THEN(DO)
             QSYS/OVRPRTF FILE(BIR316X) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT2) PAGESIZE(66 80) LPI(6) CPI(10) +
                          ALIGN(*NO) FORMTYPE(*NAR) +
                          SAVE(&PS2@) COPIES(&CPY2)
                          ENDDO
             CALL       PGM(BIR316)
                        GOTO END

 TRUCK:
             QSYS/OVRPRTF FILE(BIR317) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 80) LPI(6) CPI(10) +
                          OVRFLW(55) ALIGN(*NO) FORMTYPE(*NAR) +
                          SAVE(&PS1@) COPIES(&CPY1)
             IF         COND(&PRT2 > '       ') THEN(DO)
             QSYS/OVRPRTF FILE(BIR317X) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT2) PAGESIZE(66 80) LPI(6) CPI(10) +
                          ALIGN(*NO) FORMTYPE(*NAR) +
                          SAVE(&PS2@) COPIES(&CPY2)
                          ENDDO
             CALL       PGM(BIR317)
                        GOTO END
 FIN:        CALL       PGM(PCK310)
 END:        ENDPGM
