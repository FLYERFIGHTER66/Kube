             PGM        PARM(&TONAME &EM1 &EM2 &EM3 &EM4 &EM5 &EM6 +
                          &EM7 &EM8)

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
                        VALUE('/Kube Pak/PDF/EMAIL/STATEMENTS/Statement.pdf')
             DCL        VAR(&HTML) TYPE(*CHAR) LEN(65) VALUE('/Kube +
                          Pak/Production Applications/iSeries +
                          Email/Statements.html')

             CHGVAR     VAR(&TOEMAIL) VALUE(&EM1 *CAT &EM2 *CAT &EM3 +
                          *CAT &EM4 *CAT &EM5 *CAT &EM6 *CAT &EM7 +
                          *CAT &EM8)
/* TEMP      CHGVAR     VAR(&TOEMAIL) VALUE('WBEHR@KUBEPAK.COM')   */
             CHGVAR     VAR(&SUBJECT) VALUE('Kube-Pak Statement of +
                          Account: ' *CAT &TONAME)

             ADDLIBLE   LIB(MMAIL)
             MONMSG     MSGID(CPF2103)

             EMLHTML2   SUBJECT(&SUBJECT) +
                          FROMNAME('Kube-Pak') +
                          FROMADDR('ar@kubepak.com') +
                          TO(&TOEMAIL/&TONAME/*TO +
                          'bcc@kubepak.net'/'BCC'/*BCC) HTML(&HTML) +
                          STMF(&LINK) RECEIPT(*YES)
             RMVLNK     OBJLNK(&LINK)

             ENDPGM
