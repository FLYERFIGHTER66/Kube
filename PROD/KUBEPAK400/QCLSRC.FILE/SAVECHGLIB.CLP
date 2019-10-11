/* INITALIZE TAPE AND SAVE CHANGE LIBRARIES    */

             INZTAP     DEV(TAP01) NEWVOL(EFD) CHECK(*NO) +
                          DENSITY(*CTGTYPE)

             SAVLIB     LIB(TGMSCHG DISTCHG) DEV(TAP01) +
                          TGTRLS(V3R2M0) UPDHST(*NO)
