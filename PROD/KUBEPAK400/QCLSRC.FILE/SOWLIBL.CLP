/*   PROGRAM NAME...  SOWLIBL                           */
/*   DESCRIPTION....  CREATE LIBRARY LIST FOR SOW LINES */
/*   DATE...........  11/30/01                          */
/*   PROGRAMMER.....  EFD                               */
             PGM
             ADDLIBLE   LIB(TGMSDATA)
             MONMSG     MSGID(CPF2103)
             MONMSG     MSGID(CPF2110)
             ADDLIBLE   LIB(TGMSSEED)
             MONMSG     MSGID(CPF2103)
             MONMSG     MSGID(CPF2110)
             ADDLIBLE   LIB(EFDSYS)
             MONMSG     MSGID(CPF2103)
             MONMSG     MSGID(CPF2110)
             ADDLIBLE   LIB(TLABARCODE)
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
