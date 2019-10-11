             PGM
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(1 0) VALUE(0)
             DCL        VAR(&PCCMD) TYPE(*CHAR) LEN(150) +
                          VALUE('FORWARDSALES\MASTERTAG_FORWARDSALES_+
                          TEMPLATE.XLSM"')
             DCL        VAR(&PRDAPPDIR) TYPE(*CHAR) LEN(150)
             RTVDTAARA  DTAARA(PRDAPPDIR *ALL) RTNVAR(&PRDAPPDIR)
             CHGVAR     VAR(&PCCMD) VALUE('"' *TCAT &PRDAPPDIR *TCAT &PCCMD)

 ALLOCATE:   ALCOBJ     OBJ((MTFORWARD *FILE *EXCL *FIRST)) WAIT(1)
             MONMSG     MSGID(CPF1002) EXEC(DO)

             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)

             IF         COND(&COUNT > 2) THEN(DO)
             SNDPGMMSG  MSG('Cannot allocate the Master Tag Forward +
                          Sales File (MTFORWARD) this process is +
                          being cancelled.  Determine who has the +
                          file locked and try this request again.') +
                          TOPGMQ(*EXT)
             GOTO       CMDLBL(EOJ)
             ENDDO

             WRKOBJLCK  OBJ(MTFORWARD) OBJTYPE(*FILE) MBR(*ALL)
             DLCOBJ     OBJ((MTFORWARD *FILE *EXCL *FIRST))
             GOTO       CMDLBL(ALLOCATE)
             ENDDO

             DLCOBJ     OBJ((MTFORWARD *FILE *EXCL *FIRST))

             CALL       PGM(MTI030)

             STRPCO
             MONMSG     MSGID(IWS4010)

             STRPCCMD   PCCMD(&PCCMD) PAUSE(*NO)

 EOJ:        ENDPGM
