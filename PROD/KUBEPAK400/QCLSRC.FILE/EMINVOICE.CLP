             PGM        PARM(&PCUST &JOBNAME &JOBUSER &JOBNUMB)

             DCL        VAR(&PCUST) TYPE(*DEC)
             DCL        VAR(&JOBNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNUMB) TYPE(*CHAR) LEN(6)

             DCL        VAR(&SELCUST) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&TONAME) TYPE(*CHAR) LEN(30)
             DCL        VAR(&TOEMAIL) TYPE(*CHAR) LEN(256)
             DCL        VAR(&EM1) TYPE(*CHAR) LEN(32)
             DCL        VAR(&EM2) TYPE(*CHAR) LEN(32)
             DCL        VAR(&EM3) TYPE(*CHAR) LEN(32)
             DCL        VAR(&EM4) TYPE(*CHAR) LEN(32)
             DCL        VAR(&EM5) TYPE(*CHAR) LEN(32)
             DCL        VAR(&EM6) TYPE(*CHAR) LEN(32)
             DCL        VAR(&EM7) TYPE(*CHAR) LEN(32)
             DCL        VAR(&EM8) TYPE(*CHAR) LEN(32)
             DCL        VAR(&SUBJECT) TYPE(*CHAR) LEN(70)
             DCL        VAR(&LINK) TYPE(*CHAR) LEN(60)              +
                        VALUE('/Kube Pak/PDF/EMAIL/INVOICES/')
             DCL        VAR(&HTML) TYPE(*CHAR) LEN(65) VALUE('/Kube +
                          Pak/Production Applications/iSeries +
                          Email/Invoices.html')

             DLYJOB     DLY(5)

             ADDLIBLE   LIB(MMAIL)
             MONMSG     MSGID(CPF2103)

             CALL       PGM(EMADDRESS) PARM('INV' &SELCUST &TONAME +
                          &EM1 &EM2 &EM3 &EM4 &EM5 &EM6 &EM7 &EM8)

             CHGVAR     VAR(&TOEMAIL) VALUE(&EM1 *CAT &EM2 *CAT &EM3 +
                          *CAT &EM4 *CAT &EM5 *CAT &EM6 *CAT &EM7 +
                          *CAT &EM8)
             CHGVAR     VAR(&SUBJECT) VALUE('IMPORTANT!  Kube-Pak +
                          Invoices')

             EMLHTML2   SUBJECT(&SUBJECT) FROMNAME('Kube-Pak') +
                          FROMADDR('ar@kubepak.com') +
                          TO(&TOEMAIL/&TONAME/*TO +
                          'bcc@kubepak.net'/'BCC'/*BCC) HTML(&HTML) +
                          STMF(&LINK) RECEIPT(*YES)
             RMVLNK     OBJLNK(&LINK)

 EOJ:        ENDPGM
