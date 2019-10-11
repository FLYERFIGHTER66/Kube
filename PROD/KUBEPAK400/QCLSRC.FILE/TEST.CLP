             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CDAT) TYPE(*CHAR) LEN(13)
             DCL        VAR(&SLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SCDAT) TYPE(*CHAR) LEN(13)
             RTVOBJD    OBJ(EFDGL/GLM090) OBJTYPE(*MENU) +
                          RTNLIB(&LIB) CRTDATE(&CDAT)
             CHGDTAARA  DTAARA(*LDA (1 10)) VALUE(&LIB)
             CHGDTAARA  DTAARA(*LDA (11 13)) VALUE(&CDAT)
             RTVMBRD    FILE(EFDGL/QDDSSRC) MBR(GLM090) +
                          RTNLIB(&SLIB) SRCCHGDATE(&SCDAT)
             CHGDTAARA  DTAARA(*LDA (51 10)) VALUE(&SLIB)
             CHGDTAARA  DTAARA(*LDA (61 13)) VALUE(&SCDAT)
