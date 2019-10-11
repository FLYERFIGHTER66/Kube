/*********************************************************************/
/*   PROGRAM-------- SDR600CL                                        */
/*   DATE WRITTEN--- 06/26/01                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- SEED PRICE HISTORY COMPARE                      */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM

 /*          QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)      */
             QSYS/DCL   VAR(&YR2) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&YEAR) TYPE(*DEC) LEN(4 0)
             QSYS/DCL   VAR(&YEARA) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&FIL1) TYPE(*CHAR) LEN(8)
             QSYS/DCL   VAR(&FIL2) TYPE(*CHAR) LEN(8)
             QSYS/DCL   VAR(&FIL3) TYPE(*CHAR) LEN(8)
             QSYS/DCL   VAR(&FIL4) TYPE(*CHAR) LEN(8)
             QSYS/DCL   VAR(&FIL5) TYPE(*CHAR) LEN(8)
             QSYS/DCL   VAR(&FIL6) TYPE(*CHAR) LEN(8)
             QSYS/DCL   VAR(&FIL7) TYPE(*CHAR) LEN(8)
             QSYS/DCL   VAR(&FIL8) TYPE(*CHAR) LEN(8)
             QSYS/DCL   VAR(&FILE) TYPE(*CHAR) LEN(8)
             QSYS/DCL   VAR(&FIL11) TYPE(*CHAR) LEN(8)
             QSYS/DCL   VAR(&FIL12) TYPE(*CHAR) LEN(8)
             QSYS/DCL   VAR(&FIL13) TYPE(*CHAR) LEN(8)
             QSYS/DCL   VAR(&FIL14) TYPE(*CHAR) LEN(8)
             QSYS/DCL   VAR(&FIL15) TYPE(*CHAR) LEN(8)
             QSYS/DCL   VAR(&FIL16) TYPE(*CHAR) LEN(8)
             QSYS/DCL   VAR(&FIL17) TYPE(*CHAR) LEN(8)
             QSYS/DCL   VAR(&FIL18) TYPE(*CHAR) LEN(8)
             QSYS/DCL   VAR(&FILEP) TYPE(*CHAR) LEN(8)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(3 0) VALUE(0)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (20 30)) +
                          VALUE('000000000000000000000000000000')
             CHGDTAARA  DTAARA(*LDA (50 2)) VALUE('00')
             CHGJOB     SWS(00000000)

             RTVSYSVAL  SYSVAL(QYEAR) RTNVAR(&YR2)
             CHGDTAARA  DTAARA(*LDA (1 8)) VALUE('FSER2000')
             CHGDTAARA  DTAARA(*LDA (7 2)) VALUE(&YR2)
             CHGDTAARA  DTAARA(*LDA (9 8)) VALUE('FSPC2000')
             CHGDTAARA  DTAARA(*LDA (15 2)) VALUE(&YR2)
             RTVDTAARA  DTAARA(*LDA (5 4)) RTNVAR(&YEARA)
     /*  FIND HISTORY FILES */
 NXTYR:      RTVDTAARA  DTAARA(*LDA (1 8)) RTNVAR(&FILE)
             RTVDTAARA  DTAARA(*LDA (9 8)) RTNVAR(&FILEP)

             CHKOBJ     OBJ(&FILE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(NOFILE))
             IF         COND(&COUNT *EQ 0) THEN(DO)
             CHGDTAARA  DTAARA(*LDA (20 4)) VALUE(&YEARA)
             CHGVAR     VAR(&FIL1) VALUE(&FILE)
             CHGVAR     VAR(&FIL11) VALUE(&FILEP)
             CHGJOB     SWS(1XXXXXXX)
             ENDDO
             IF         COND(&COUNT *EQ 1) THEN(DO)
             CHGDTAARA  DTAARA(*LDA (24 4)) VALUE(&YEARA)
             CHGVAR     VAR(&FIL2) VALUE(&FILE)
             CHGVAR     VAR(&FIL12) VALUE(&FILEP)
             CHGJOB     SWS(X1XXXXXX)
             ENDDO
             IF         COND(&COUNT *EQ 2) THEN(DO)
             CHGDTAARA  DTAARA(*LDA (28 4)) VALUE(&YEARA)
             CHGVAR     VAR(&FIL3) VALUE(&FILE)
             CHGVAR     VAR(&FIL13) VALUE(&FILEP)
             CHGJOB     SWS(XX1XXXXX)
             ENDDO
             IF         COND(&COUNT *EQ 3) THEN(DO)
             CHGDTAARA  DTAARA(*LDA (32 4)) VALUE(&YEARA)
             CHGVAR     VAR(&FIL4) VALUE(&FILE)
             CHGVAR     VAR(&FIL14) VALUE(&FILEP)
             CHGJOB     SWS(XXX1XXXX)
             ENDDO
             IF         COND(&COUNT *EQ 4) THEN(DO)
             CHGDTAARA  DTAARA(*LDA (36 4)) VALUE(&YEARA)
             CHGVAR     VAR(&FIL5) VALUE(&FILE)
             CHGVAR     VAR(&FIL15) VALUE(&FILEP)
             CHGJOB     SWS(XXXX1XXX)
             ENDDO
             IF         COND(&COUNT *EQ 5) THEN(DO)
             CHGDTAARA  DTAARA(*LDA (40 4)) VALUE(&YEARA)
             CHGVAR     VAR(&FIL6) VALUE(&FILE)
             CHGVAR     VAR(&FIL16) VALUE(&FILEP)
             CHGJOB     SWS(XXXXX1XX)
             ENDDO
             IF         COND(&COUNT *EQ 6) THEN(DO)
             CHGDTAARA  DTAARA(*LDA (44 4)) VALUE(&YEARA)
             CHGVAR     VAR(&FIL7) VALUE(&FILE)
             CHGVAR     VAR(&FIL17) VALUE(&FILEP)
             CHGJOB     SWS(XXXXXX1X)
             ENDDO
             IF         COND(&COUNT *EQ 7) THEN(DO)
             CHGDTAARA  DTAARA(*LDA (48 4)) VALUE(&YEARA)
             CHGVAR     VAR(&FIL8) VALUE(&FILE)
             CHGVAR     VAR(&FIL18) VALUE(&FILEP)
             CHGJOB     SWS(XXXXXXX1)
             ENDDO
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)
 NOFILE:     CHGVAR     VAR(&YEAR) VALUE(&YEARA)
             CHGVAR     VAR(&YEAR) VALUE(&YEAR - 001)
             CHGVAR     VAR(&YEARA) VALUE(&YEAR)
             CHGDTAARA  DTAARA(*LDA (5 4)) VALUE(&YEARA)
             CHGDTAARA  DTAARA(*LDA (13 4)) VALUE(&YEARA)
             IF         COND(&YEAR *GE 1999) THEN(GOTO CMDLBL(NXTYR))

      /* GET FILE OVERRIDES */
             IF         COND(&FIL1 *GT '        ') THEN(DO)
                OVRDBF    FILE(FILE1) TOFILE(&FIL1)
                OVRDBF    FILE(FILE11) TOFILE(&FIL11)
             ENDDO
             IF         COND(&FIL2 *GT '        ') THEN(DO)
                OVRDBF    FILE(FILE2) TOFILE(&FIL2)
                OVRDBF    FILE(FILE12) TOFILE(&FIL12)
             ENDDO
             IF         COND(&FIL3 *GT '        ') THEN(DO)
                OVRDBF    FILE(FILE3) TOFILE(&FIL3)
                OVRDBF    FILE(FILE13) TOFILE(&FIL13)
             ENDDO
             IF         COND(&FIL4 *GT '        ') THEN(DO)
                OVRDBF    FILE(FILE4) TOFILE(&FIL4)
                OVRDBF    FILE(FILE14) TOFILE(&FIL14)
             ENDDO
             IF         COND(&FIL5 *GT '        ') THEN(DO)
                OVRDBF    FILE(FILE5) TOFILE(&FIL5)
                OVRDBF    FILE(FILE15) TOFILE(&FIL15)
             ENDDO
             IF         COND(&FIL6 *GT '        ') THEN(DO)
                OVRDBF    FILE(FILE6) TOFILE(&FIL6)
                OVRDBF    FILE(FILE16) TOFILE(&FIL16)
             ENDDO
             IF         COND(&FIL7 *GT '        ') THEN(DO)
                OVRDBF    FILE(FILE7) TOFILE(&FIL7)
                OVRDBF    FILE(FILE17) TOFILE(&FIL17)
             ENDDO
             IF         COND(&FIL8 *GT '        ') THEN(DO)
                OVRDBF    FILE(FILE8) TOFILE(&FIL8)
                OVRDBF    FILE(FILE18) TOFILE(&FIL18)
             ENDDO
       /* RUN INQUIRY */
             CALL       PGM(SDR600)

 END:  /*    CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')  */
             ENDPGM
