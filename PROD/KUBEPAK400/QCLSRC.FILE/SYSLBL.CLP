/*   PROGRAM NAME...  SYSLBL                           */
/*   DESCRIPTION....  CREATE LIBRARY LIST FOR USERS    */
/*   DATE...........   4/21/99                         */
/*   PROGRAMMER.....  EFD                              */
             PGM
             ADDLIBLE   LIB(TGMSDATA)
             MONMSG     MSGID(CPF2103)
             MONMSG     MSGID(CPF2110)
             ADDLIBLE   LIB(EFDSYS)
             MONMSG     MSGID(CPF2103)
             MONMSG     MSGID(CPF2110)
             CHGCURLIB  CURLIB(EFDSYS)
             ENDPGM
