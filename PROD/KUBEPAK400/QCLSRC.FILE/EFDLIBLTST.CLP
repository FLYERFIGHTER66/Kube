/*   PROGRAM NAME...  APLBL                            */
/*   DESCRIPTION....  CREATE LIBRARY LIST FOR A/P      */
/*   DATE...........  01/14/99                         */
/*   PROGRAMMER.....  EFD                              */
             PGM
             ADDLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF2103)
             MONMSG     MSGID(CPF2110)
             ADDLIBLE   LIB(TESTDATA)
             MONMSG     MSGID(CPF2103)
             MONMSG     MSGID(CPF2110)
             ADDLIBLE   LIB(TGMSSEED)
             MONMSG     MSGID(CPF2103)
             MONMSG     MSGID(CPF2110)
             ADDLIBLE   LIB(EFDSYS)
             MONMSG     MSGID(CPF2103)
             MONMSG     MSGID(CPF2110)
             ADDLIBLE   LIB(EFDGL)
             MONMSG     MSGID(CPF2103)
             MONMSG     MSGID(CPF2110)
             ADDLIBLE   LIB(EFDAP)
             MONMSG     MSGID(CPF2103)
             MONMSG     MSGID(CPF2110)
             ADDLIBLE   LIB(EFDAR)
             MONMSG     MSGID(CPF2103)
             MONMSG     MSGID(CPF2110)
             ADDLIBLE   LIB(TGMS)
             MONMSG     MSGID(CPF2103)
             MONMSG     MSGID(CPF2110)
             ADDLIBLE   LIB(KUBEPAK400)
             MONMSG     MSGID(CPF2103)
             MONMSG     MSGID(CPF2110)
             CHGCURLIB  CURLIB(KUBEPAK400)
             ENDPGM
