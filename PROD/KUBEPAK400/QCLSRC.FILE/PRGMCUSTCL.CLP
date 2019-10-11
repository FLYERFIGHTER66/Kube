/*********************************************************************/
/*   PROGRAM-------- PRGMCUSTCL                                      */
/*   DATE WRITTEN---  6/26/96                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- PURGE DELETED RECORDS IN FMCUST                 */
/*   REVISIONS------                                                 */
/* 5/26/00 EFD ADD FNXTCUST FILE FOR KUBEPAK                         */
/*********************************************************************/
             PGM

             DCLF       FILE(PRGMCUSTFM)
             SNDRCVF    RCDFMT(SCRNA)
             IF         COND(&IN03 *EQ '1') THEN(RETURN)

             CALL       PGM(PRGMCUST)

/*   PURGE FMCUST                                                    */
             RGZPFM     FILE(FMCUST)
             MONMSG     MSGID(CPF2981)

/*   PURGE FCMDIR                                                    */
             RGZPFM     FILE(FCMDIR)
             MONMSG     MSGID(CPF2981)

/*   PURGE FARHST                                                    */
             RGZPFM     FILE(FARHST)
             MONMSG     MSGID(CPF2981)

/*   PURGE FCUSTCOM                                                  */
             RGZPFM     FILE(FCUSTCOM)
             MONMSG     MSGID(CPF2981)

             CALL       PGM(GETNXCSTCL)

             ENDPGM
