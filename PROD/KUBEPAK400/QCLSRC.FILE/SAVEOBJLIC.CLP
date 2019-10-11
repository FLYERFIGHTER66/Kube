/* INIT TAPE AND SAVE SOURCE OBJECTS FOR ANY VERSION  OS-400  */
/* THAT OUR CUSTOMERS HAVE.                                   */

             PGM
             INZTAP     DEV(TAP01) NEWVOL(EFD) CHECK(*NO) +
                          DENSITY(*CTGTYPE)

             SAVOBJ     OBJ(QCLSRC QDDSSRC QRPGSRC) LIB(DIST400) +
                          DEV(TAP01) ENDOPT(*LEAVE) TGTRLS(V3R2M0)
             SAVOBJ     OBJ(QCLSRC QDDSSRC QRPGSRC) LIB(EFDAP) +
                          DEV(TAP01) ENDOPT(*LEAVE) TGTRLS(V3R2M0)
             SAVOBJ     OBJ(QCLSRC QDDSSRC QRPGSRC) LIB(EFDAR) +
                          DEV(TAP01) ENDOPT(*LEAVE) TGTRLS(V3R2M0)
/*           SAVOBJ     OBJ(QCLSRC QDDSSRC QRPGSRC) LIB(EFDE.COMM) +*/
/*                        DEV(TAP01) ENDOPT(*LEAVE) TGTRLS(V3R2M0) */
             SAVOBJ     OBJ(QCLSRC QDDSSRC QRPGSRC) LIB(EFDGL) +
                          DEV(TAP01) ENDOPT(*LEAVE) TGTRLS(V3R2M0)
             SAVOBJ     OBJ(QCLSRC QDDSSRC QRPGSRC) LIB(EFDPO) +
                          DEV(TAP01) ENDOPT(*LEAVE) TGTRLS(V3R2M0)
             SAVOBJ     OBJ(QCLSRC QDDSSRC QRPGSRC) LIB(EFDSYS) +
                          DEV(TAP01) TGTRLS(V3R2M0)
             SAVOBJ     OBJ(QCLSRC QDDSSRC QRPGSRC) LIB(TGMS) +
                          DEV(TAP01) ENDOPT(*LEAVE) TGTRLS(V3R2M0)
             SAVOBJ     OBJ(QCLSRC QDDSSRC QRPGSRC QS36PRC QS36SRC) +
                          LIB(EFDCNVNS) DEV(TAP01) ENDOPT(*LEAVE) +
                          TGTRLS(V3R2M0)
             SAVOBJ     OBJ(QCLSRC QDDSSRC QRPGSRC QS36PRC QS36SRC) +
                          LIB(EFDLIB) DEV(TAP01) ENDOPT(*LEAVE) +
                          TGTRLS(V3R2M0)
             SAVOBJ     OBJ(QCLSRC QDDSSRC QRPGSRC QS36PRC QS36SRC) +
                          LIB(GLAPPR) DEV(TAP01) ENDOPT(*LEAVE) +
                          TGTRLS(V3R2M0)
             SAVOBJ     OBJ(QCLSRC QDDSSRC QRPGSRC QS36PRC QS36SRC) +
                          LIB(GROWERS) DEV(TAP01) ENDOPT(*REWIND) +
                          TGTRLS(V3R2M0)

             ENDPGM
