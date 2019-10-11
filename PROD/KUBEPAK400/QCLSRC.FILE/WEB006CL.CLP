             PGM        PARM(&OPEN &INPUT &OUTPUT)
             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OPEN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&INPUT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&INPUTC) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTPUT) TYPE(*CHAR) LEN(10)

             RTVOBJD    OBJ(WEB006CL) OBJTYPE(*PGM) RTNLIB(&LIBR)
             CHGVAR     VAR(&INPUTC) VALUE(&INPUT *TCAT 'C')
/*? SETUP FOR FTP ?*/
CLOSED:      OVRDBF     FILE(INPUT) TOFILE(&LIBR/QFTPSRC) +
                          MBR(&INPUTC)
OPEN:        IF (&OPEN = '1') THEN(                     +
             OVRDBF     FILE(INPUT) TOFILE(&LIBR/QFTPSRC) +
                          MBR(&INPUT)  )
             OVRDBF     FILE(OUTPUT) TOFILE(&LIBR/QFTPSRC) +
                          MBR(&OUTPUT)
/*? SEND TO KUBEPAK.COM ?*/
             CLRPFM     FILE(&LIBR/QFTPSRC) MBR(&OUTPUT)
             FTP        RMTSYS(FTP.KUBEPAK.COM)

 EOJ:        ENDPGM
