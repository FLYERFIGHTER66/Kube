/*********************************************************************/
/*   PROGRAM-------- CLRMOV1C                                        */
/*   DATE WRITTEN--- 04/07/04                                        */
/*   DESCRIPTION---- Clear MOVE1 Report Files                        */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCLF       FILE(CLRMOV1FM)

 LOOP1:      SNDRCVF    RCDFMT(SCRN01)
             IF         COND(&IN03 *EQ '1') THEN(GOTO CMDLBL(EOJ))
             CHGVAR     VAR(&MSG) VALUE('You must use F13 (Shift-F1 +
                          for those without an F13 Key) to clear +
                          the Files')
             IF         COND(&IN13 *NE '1') THEN(GOTO CMDLBL(LOOP1))

             CLRPFM     FILE(FMOVCNT1)
             CLRPFM     FILE(FMOVJB1)


 EOJ:        ENDPGM
