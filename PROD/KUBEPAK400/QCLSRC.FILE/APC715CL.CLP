/*********************************************************************/
/*   PROGRAM NAME...  APC715                                         */
/*   DATE...........  01/11/99                                       */
/*   PROGRAMMER.....  EFD                                            */
/*   DESCRIPTION....  CREATE A/P YEAR END 1099 FILE                  */
/*   REVISIONS......                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&EOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SAVE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&YEAR) TYPE(*CHAR) LEN(4)

             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')

 NXT:        CALL       PGM(APC715)
             RTVDTAARA  DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND((&EOJ) = 'X') THEN(GOTO CMDLBL(END))

             RTVDTAARA  DTAARA(*LDA (1 1)) RTNVAR(&SAVE)
             IF         COND((&SAVE) = 'N') THEN(GOTO CMDLBL(NOSAVE))
             CALL       PGM(APSAVE)

 NOSAVE:
             DLTF       FILE(TGMSDATA/FV1099)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(TGMSDATA/FV1099) SRCFILE(*LIBL/QDDSSRC) +
                          OPTION(*NOSRC *NOLIST) SIZE(10000 1000 +
                          1500) LVLCHK(*NO)
             RTVDTAARA  DTAARA(*LDA (2 4)) RTNVAR(&YEAR)
             CPYF       FROMFILE(TGMSDATA/FYVEND) +
                          TOFILE(TGMSDATA/FV1099) MBROPT(*REPLACE) +
                          INCREL((*IF YMYEAR *EQ &YEAR)) FMTOPT(*NOCHK)
 END:        ENDPGM
