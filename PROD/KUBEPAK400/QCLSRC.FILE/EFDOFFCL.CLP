/*  PROGRAM NAME........ EFDOFFCL                                  */
/*  DESCRIPTION......... VARY OFF THE LINE AND CONTROLER           */
/*  DATE................ 11/18/95                                  */
/*  PROGRAMMER.......... E.F.D.                                    */
             PGM
             VRYCFG     CFGOBJ(PTLINE) CFGTYPE(*LIN) STATUS(*OFF)
             MONMSG     MSGID(CPA2610)
             MONMSG     MSGID(CPF2659)
             VRYCFG     CFGOBJ(EFD400) CFGTYPE(*CTL) STATUS(*OFF)
             MONMSG     MSGID(CPA2610)
             MONMSG     MSGID(CPF2659)
             ENDPGM
