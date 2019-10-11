/*   PROGRAM NAME...  KUBEALLLBL                       */
/*   DESCRIPTION....  CREATE LIBRARY LIST FOR K-P      */

             PGM

             MONMSG     MSGID(CPF2103)
             MONMSG     MSGID(CPF2110)

             CHGLIBL    LIBL(*NONE) CURLIB(*CRTDFT)

             ADDLIBLE   LIB(QTEMP)
             ADDLIBLE   LIB(QGPL)
             ADDLIBLE   LIB(TGMSDATA)
/*           ADDLIBLE   LIB(TLABARCODE)    */
             ADDLIBLE   LIB(KUBEPAK400)
             ADDLIBLE   LIB(LIBHTTP) POSITION(*LAST)
             ADDLIBLE   LIB(MMAIL) POSITION(*LAST)
             ADDLIBLE   LIB(QUSRSYS) POSITION(*LAST)

             CHGCURLIB  CURLIB(KUBEPAK400)

             ENDPGM
