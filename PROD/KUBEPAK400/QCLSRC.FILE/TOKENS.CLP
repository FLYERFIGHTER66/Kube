             PGM        PARM(&LOOK)
             DCL        VAR(&LOOK) TYPE(*CHAR) LEN(15)
             DCL        VAR(&CUST) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&NAME) TYPE(*CHAR) LEN(30)
             DCL        VAR(&STS) TYPE(*CHAR) LEN(2) VALUE('  ')

             IF         COND(%CHECK(' 0123456789' &LOOK 1) *NE 0) +
                          THEN(DO)
             CALL       PGM(LKCUST) PARM(&LOOK &CUST &NAME)
             IF         COND(&CUST *EQ 0) THEN(GOTO CMDLBL(EOJ))
             GOTO       CMDLBL(TOKENIZE)
             ENDDO
             CHGVAR     VAR(&CUST) VALUE(&LOOK)
 TOKENIZE:   CALL       PGM(WSPCI004) PARM(&CUST &STS)
 EOJ:        ENDPGM
