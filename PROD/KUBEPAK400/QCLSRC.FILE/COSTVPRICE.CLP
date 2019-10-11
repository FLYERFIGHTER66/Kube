             PGM
             DCL        VAR(&THISWS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PCCMD) TYPE(*CHAR) LEN(150) VALUE('Cost +
                          vs Price\Cost vs Price Report.xls"')
             DCL        VAR(&PRDAPPDIR) TYPE(*CHAR) LEN(150)
             RTVDTAARA  DTAARA(PRDAPPDIR *ALL) RTNVAR(&PRDAPPDIR)
             CHGVAR     VAR(&PCCMD) VALUE('"' *TCAT &PRDAPPDIR *TCAT &PCCMD)

             RTVJOBA    JOB(&THISWS)
             SNDBRKMSG  MSG('Before you can use the spreadsheet, you +
                          must first generate appropriate data to +
                          be presented.  Use the following report +
                          to clear and then build the data.') +
                          TOMSGQ(&THISWS)

             CALL       PGM(SDR360CL)

             STRPCO
             MONMSG     MSGID(IWS4010)
             STRPCCMD   PCCMD(&PCCMD) PAUSE(*NO)

             ENDPGM
