             PGM
             DCL        VAR(&DAT7) TYPE(*CHAR) LEN(07)
             DCL        VAR(&MSTR) TYPE(*CHAR) LEN(02)
             DCL        VAR(&TRUK) TYPE(*CHAR) LEN(01)
             DCL        VAR(&SVIA) TYPE(*CHAR) LEN(01)
             DCL        VAR(&PRT1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPY1) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CPY2) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PS1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PS2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PS1@) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PS2@) TYPE(*CHAR) LEN(4)
             DCL        VAR(&CHGO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CANCEL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MULTPRT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FEDEXONLY) TYPE(*CHAR) LEN(1)
             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')

             STRPCO
             MONMSG     MSGID(IWS4010 IWS4032)

 NXT:        CALL       PGM(MMR040) PARM(&CANCEL &DAT7 &MSTR &TRUK &SVIA &PRT1 &PRT2 &CPY1 +
                          &CPY2 &PS1 &PS2 &CHGO &FEDEXONLY)
             IF         COND(&CANCEL = 'X') THEN(GOTO CMDLBL(END))

             CHGVAR     VAR(&PS1@) VALUE('*NO')
             CHGVAR     VAR(&PS2@) VALUE('*NO')
             IF         COND(&PS1 *EQ 'Y') THEN(CHGVAR VAR(&PS1@) VALUE('*YES'))
             IF         COND(&PS2 *EQ 'Y') THEN(CHGVAR VAR(&PS2@) VALUE('*YES'))

             QSYS/OVRPRTF FILE(MMR050) TOFILE(*LIBL/QSYSPRT) DEV(&PRT1) PAGESIZE(66 80) LPI(6) +
                          CPI(10) OVRFLW(55) ALIGN(*NO) FORMTYPE(*NAR) SAVE(&PS1@) +
                          COPIES(&CPY1)

             QSYS/OVRPRTF FILE(MMR060) TOFILE(*LIBL/QSYSPRT) DEV(&PRT1) PAGESIZE(66 80) LPI(6) +
                          CPI(10) OVRFLW(55) ALIGN(*NO) FORMTYPE(*NAR) SAVE(&PS1@) +
                          COPIES(&CPY1)

             CHGVAR     VAR(&MULTPRT) VALUE('N')

             IF         COND(&PRT2 > '       ') THEN(DO)

                CHGVAR     VAR(&MULTPRT) VALUE('Y')

                QSYS/OVRPRTF FILE(MMR050X) TOFILE(*LIBL/QSYSPRT) DEV(&PRT2) PAGESIZE(66 80) +
                             LPI(6) CPI(10) ALIGN(*NO) FORMTYPE(*NAR) SAVE(&PS2@) COPIES(&CPY2)
                QSYS/OVRPRTF FILE(MMR060X) TOFILE(*LIBL/QSYSPRT) DEV(&PRT2) PAGESIZE(66 80) +
                             LPI(6) CPI(10) ALIGN(*NO) FORMTYPE(*NAR) SAVE(&PS2@) COPIES(&CPY2)

             ENDDO

             SELECT
                WHEN       COND(&FEDEXONLY *NE 'N') THEN(DO)
                   CALL       PGM(MMR060FEDX) PARM(&FEDEXONLY &DAT7 &MSTR &CHGO &MULTPRT)
                ENDDO
                OTHERWISE  CMD(DO)
                   IF         COND(&TRUK = 'Y') THEN(CALL PGM(MMR050) PARM(&DAT7 &MSTR &CHGO +
                                &MULTPRT))
                   IF         COND(&SVIA = 'Y') THEN(CALL PGM(MMR060) PARM(&DAT7 &MSTR &CHGO +
                                &MULTPRT))
                ENDDO
             ENDSELECT

             GOTO       CMDLBL(NXT)

 END:        ENDPGM

