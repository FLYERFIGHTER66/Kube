             PGM

             DCL        VAR(&PRTR) TYPE(*CHAR) LEN(10) VALUE('P6')
             DCL        VAR(&FORM) TYPE(*CHAR) LEN(10) VALUE('*NAR')
             DCL        VAR(&HOLD) TYPE(*CHAR) LEN(4) VALUE('*NO ')
             DCL        VAR(&SAVE) TYPE(*CHAR) LEN(4) VALUE('*YES')
             DCL        VAR(&COPY) TYPE(*CHAR) LEN(2) VALUE('01')
             DCL        VAR(&UDATE) TYPE(*CHAR) LEN(6)

             DCL        VAR(&CONO) TYPE(*DEC) LEN(2 0) VALUE(1)
             DCL        VAR(&ACTPERB) TYPE(*DEC) LEN(2 0) VALUE(1)
             DCL        VAR(&ACTPERE) TYPE(*DEC) LEN(2 0) VALUE(12)
             DCL        VAR(&BEGDATB) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&BEGDATB@) TYPE(*CHAR) LEN(6)
             DCL        VAR(&ENDDATB) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&ENDDATB@) TYPE(*CHAR) LEN(6)
             DCL        VAR(&BGCYMD ) TYPE(*DEC) LEN(7 0)
             DCL        VAR(&ENCYMD ) TYPE(*DEC) LEN(7 0)
             DCL        VAR(&ERR    ) TYPE(*DEC) LEN(1 0)

             DCL        VAR(&JOBDATE7) TYPE(*CHAR) LEN(7)
             DCL        VAR(&JOBNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ISBATCH) TYPE(*LGL) LEN(1)
             DCL        VAR(&TIMESTAMP) TYPE(*CHAR) LEN(20)
             DCL        VAR(&LINK) TYPE(*CHAR) LEN(85) VALUE('/Kube +
                          Pak/PDF/NIGHTREPORTS/')
             DCL        VAR(&DATALIB) TYPE(*CHAR) LEN(10)

             RTVJOBA    DATE(&UDATE)
             RTVOBJD    OBJ(DATALIB) OBJTYPE(*FILE) RTNLIB(&DATALIB)

             CHGDTAARA  DTAARA(*LDA (001 002)) VALUE('01')
             CHGDTAARA  DTAARA(*LDA (003 002)) VALUE('01')
             CHGDTAARA  DTAARA(*LDA (005 006)) VALUE(&UDATE)
             CHGDTAARA  DTAARA(*LDA (005 004)) VALUE('0101')
             CHGDTAARA  DTAARA(*LDA (011 006)) VALUE(&UDATE)
             CHGDTAARA  DTAARA(*LDA (011 004)) VALUE('1231')
             CHGDTAARA  DTAARA(*LDA (172 002)) VALUE('12')
             CHGDTAARA  DTAARA(*LDA (174 010)) VALUE(&DATALIB)

             CALL       PGM(GETPDAT) PARM(&CONO &ACTPERB &BEGDATB +
                          &ENDDATB &BGCYMD &ENCYMD &ERR)
             CHGVAR     VAR(&BEGDATB@) VALUE(&BEGDATB)
             CHGDTAARA  DTAARA(*LDA (005 006)) VALUE(&BEGDATB@)

             CALL       PGM(GETPDAT) PARM(&CONO &ACTPERE &BEGDATB +
                          &ENDDATB &BGCYMD &ENCYMD &ERR)
             CHGVAR     VAR(&ENDDATB@) VALUE(&ENDDATB)
             CHGDTAARA  DTAARA(*LDA (011 006)) VALUE(&ENDDATB@)

             RTVJOBA    JOB(&JOBNAME) CYMDDATE(&JOBDATE7) +
                          DATETIME(&TIMESTAMP)

             CHGVAR     VAR(&LINK) VALUE(&LINK *TCAT &JOBDATE7)
             CRTDIR     DIR(&LINK)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&LINK) VALUE(&LINK *TCAT '/' *TCAT 'GLR570' +
                          *TCAT '-' *TCAT &TIMESTAMP *TCAT '.pdf')
             OVRPRTF    FILE(GLR570) TOFILE(*LIBL/QSYSPRT) +
                          DEVTYPE(*AFPDS) PAGESIZE(66 120) LPI(6) +
                          CPI(15) ALIGN(*NO) TOSTMF(&LINK) WSCST(*PDF)

             CALL       PGM(GLR570)
 END:        ENDPGM
