/*   PROGRAM NAME...  GLLBL                            */
/*   DESCRIPTION....  CREATE LIBRARY LIST FOR G/L      */
/*   DATE...........  01/14/99                         */
/*   PROGRAMMER.....  EFD                              */
             PGM
             ADDLIBLE   LIB(TGMSDATA)
             MONMSG     MSGID(CPF2103)
             MONMSG     MSGID(CPF2110)
             ADDLIBLE   LIB(EFDSYS)
             MONMSG     MSGID(CPF2103)
             MONMSG     MSGID(CPF2110)
             ADDLIBLE   LIB(EFDGL)
             MONMSG     MSGID(CPF2103)
             MONMSG     MSGID(CPF2110)
             CHGCURLIB  CURLIB(EFDGL)
             ENDPGM
