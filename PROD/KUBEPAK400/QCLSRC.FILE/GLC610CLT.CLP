/*********************************************************************/
/*   PROGRAM-------- GLC610CLT                                       */
/*   DATE WRITTEN--- 08/03/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- YEAR END PRELIMINARY CLOSE                      */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(9) /* LIBR NAME */

             CHGDTAARA  DTAARA(*LDA (88 9)) VALUE('LSTYR9901')

             RTVDTAARA  DTAARA(*LDA (88 9)) RTNVAR(&LIBR)

             CRTLF      FILE(&LIBR/FGLALOIN) MBR(RGLALO) +
                          DTAMBRS((&LIBR/FGLALO (RGLALO))) +
                          OPTION(*NOSRC *NOLIST) LVLCHK(*NO)

             CRTLF      FILE(&LIBR/FGLALOTO) MBR(RGLALO) +
                          DTAMBRS((&LIBR/FGLALO (RGLALO))) +
                          OPTION(*NOSRC *NOLIST) LVLCHK(*NO)

             CRTLF      FILE(&LIBR/FMGLCHAL) MBR(RMGLCH) +
                          DTAMBRS((&LIBR/FMGLCH (RMGLCH))) +
                          OPTION(*NOSRC *NOLIST) LVLCHK(*NO)

             CRTLF      FILE(&LIBR/FGLDCOAC) MBR(RGLDCON) +
                          DTAMBRS((&LIBR/FGLDCON (RGLDCON))) +
                          OPTION(*NOSRC *NOLIST) LVLCHK(*NO)

             CRTLF      FILE(&LIBR/FGLDACCT) MBR(RGLDET) +
                          DTAMBRS((&LIBR/FGLDET (RGLDET)) +
                          (&LIBR/FGLDCON (RGLDCON))) OPTION(*NOSRC +
                          *NOLIST) LVLCHK(*NO)

             CRTLF      FILE(&LIBR/FGLDVEND) MBR(RGLDCON) +
                          DTAMBRS((&LIBR/FGLDET (RGLDET)) +
                          (&LIBR/FGLDCON (RGLDCON))) OPTION(*NOSRC +
                           *NOLIST) LVLCHK(*NO)

             CRTLF      FILE(&LIBR/FGLDETAA) MBR(RGLDET) +
                          DTAMBRS((&LIBR/FGLDET (RGLDET))) +
                          OPTION(*NOSRC *NOLIST) LVLCHK(*NO)

             CRTLF      FILE(&LIBR/FGLDETAC) MBR(RGLDET) +
                          DTAMBRS((&LIBR/FGLDET (RGLDET))) +
                          OPTION(*NOSRC *NOLIST) LVLCHK(*NO)

             CRTLF      FILE(&LIBR/FGLDETDT) MBR(RGLDET) +
                          DTAMBRS((&LIBR/FGLDET (RGLDET))) +
                          OPTION(*NOSRC *NOLIST) LVLCHK(*NO)

             CRTLF      FILE(&LIBR/FGLDETJD) MBR(RGLDET) +
                          DTAMBRS((&LIBR/FGLDET (RGLDET))) +
                          OPTION(*NOSRC *NOLIST) LVLCHK(*NO)

             CRTLF      FILE(&LIBR/FGLDETJS) MBR(RGLDET) +
                          DTAMBRS((&LIBR/FGLDET (RGLDET))) +
                          OPTION(*NOSRC *NOLIST) LVLCHK(*NO)

 END:        ENDPGM
