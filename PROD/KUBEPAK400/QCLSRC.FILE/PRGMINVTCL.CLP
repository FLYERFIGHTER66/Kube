/*********************************************************************/
/*   PROGRAM-------- PRGMINVTCL                                      */
/*   DATE WRITTEN---  7/02/96                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- PURGE DELETED RECORDS IN FMINVT                 */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             CALL       PGM(PRGMINVT)

/*   PURGE FMINVT                                                    */
             RGZPFM     FILE(FMINVT)
             MONMSG     MSGID(CPF2981)

/*   PURGE FMITSES                                                   */
             RGZPFM     FILE(FMITSES)
             MONMSG     MSGID(CPF2981)

/*   PURGE FIADD                                                     */
             RGZPFM     FILE(FIADD)
             MONMSG     MSGID(CPF2981)

             ENDPGM
