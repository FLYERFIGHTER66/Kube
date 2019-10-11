/*********************************************************************/
/*   PROGRAM-------- PRGMVENDCL                                      */
/*   DATE WRITTEN--- 07/18/00                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- PURGE DELETED RECORDS IN FMVEND                 */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('PRGVEND')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('    Remove +
                          Deleted Vendors ')

             CALL       PGM(DEF998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(PRGCCK)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(PRGMVEND)

/*   PURGE FMVEND                                                    */
             RGZPFM     FILE(FMVEND)
             MONMSG     MSGID(CPF2981)

/*   PURGE FVENDCM                                                   */
             RGZPFM     FILE(FVENDCM)
             MONMSG     MSGID(CPF2981)

     END:    CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             ENDPGM
