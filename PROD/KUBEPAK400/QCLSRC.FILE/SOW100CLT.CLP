/*********************************************************************/
/*   PROGRAM-------- SOW010CL                                        */
/*   DATE WRITTEN--- 11/30/01                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- SOW LINE OPERATIONS                             */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM


             ADDLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF2103)



             TLABARCODE/LBLBATCH LBLNAM(NEWSOWP4) QTYFLD('      ') +
                          QTYOVR('0001') OUTQ(P4) FORM(SOWLABEL) +
                          MRGFILE(FSOWLAB1)

 END:
             RMVLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF2104)

             ENDPGM
