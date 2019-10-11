/*  PROGRAM NAME........ EFDONCL                                   */
/*  DESCRIPTION......... VARY ON THE LINE AND CONTROLER AND START  */
/*                       PASS THRU.                                */
/*  PROGRAMMER.......... E.F.D.                                    */
             PGM
             VRYCFG     CFGOBJ(PTLINE) CFGTYPE(*LIN) STATUS(*ON) +
                          RESET(*NO)
             VRYCFG     CFGOBJ(EFD400) CFGTYPE(*CTL) STATUS(*ON) +
                          RESET(*YES)
/*           STRPASTHR  RMTLOCNAME(EFD400)                         */
             ENDPGM
