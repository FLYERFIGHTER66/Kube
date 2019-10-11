/*********************************************************************/
/*   PROGRAM-------- BIR277CL                                        */
/*   DATE WRITTEN---  1/12/00                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- CREDIT MEMO ENTRY                               */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&EOJ) TYPE(*CHAR) LEN(1)
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('BIR275')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('     Credit +
                          Memo Entry      ')

             CALL       PGM(DEF998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CHGDTAARA  DTAARA(*LDA (4 6)) VALUE('000000')
             CHGDTAARA  DTAARA(*LDA (10 6)) VALUE('000000')
             CHGDTAARA  DTAARA(*LDA (16 6)) VALUE('000000')
             CHGDTAARA  DTAARA(*LDA (22 6)) VALUE('000000')
             CHGDTAARA  DTAARA(*LDA (32 6)) VALUE('000000')
             CHGDTAARA  DTAARA(*LDA (38 6)) VALUE('000000')
             CHGDTAARA  DTAARA(*LDA (44 6)) VALUE('000000')
             CHGDTAARA  DTAARA(*LDA (114 2)) VALUE('00')

             CALL       PGM(BIR277)
 END:        CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
             ENDPGM
