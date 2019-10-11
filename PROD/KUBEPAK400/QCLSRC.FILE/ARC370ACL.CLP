/*********************************************************************/
/*   PROGRAM-------- ARC370ACL                                       */
/*   DATE WRITTEN--- 04/01/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- A/R EXCEEDED CREDIT LIMIT REPORT                */
/*   REVISIONS------                                                 */
/*  5/16/01 EFD MAKE AUTO RUN AS PART OF BIC330                      */
/* 12/23/14 WJB CHANGE TO EMAILED                                    */
/*********************************************************************/
             PGM

             CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (1 2)) VALUE('01')
             CHGDTAARA  DTAARA(*LDA (3 1)) VALUE('1')
             CHGDTAARA  DTAARA(*LDA (4 1)) VALUE('2')

             QSYS/OVRPRTF FILE(ARR370) TOFILE(*LIBL/QSYSPRT) +
                          DEV(P9) PAGESIZE(66 85) LPI(6) CPI(10) +
                          ALIGN(*NO) FORMTYPE(*NAR) COPIES(1) +
                          HOLD(*YES) SAVE(*NO)

             CALL       PGM(ARR370)

             ADDLIBLE   LIB(MMAIL)
             MONMSG     MSGID(CPF2103)

             EMLSPL     SUBJECT('Exceeded Credit Limit Report') +
                          FROMNAME('QSYSOPR') +
                          FROMADDR('webmaster@kubepak.com') +
                          TO('wswanekamp@kubepak.com'/'Bill'/*TO +
                          'bcc@kubepak.net'/'BCC'/*BCC) +
                          SPLF(*YES/*LAST/*N/*N/*CURRENT/ARR370) +
                          MSGM(QMAILSRC/ARR370)

             DLTSPLF    FILE(ARR370) SPLNBR(*LAST)

 END:        CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
             ENDPGM
