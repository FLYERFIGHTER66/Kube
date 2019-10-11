/*********************************************************************/
/*   PROGRAM-------- GRS212CL                                        */
/*   DATE WRITTEN--- 12/21/98                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- PRINT SEASON SOW/SHIP REPORT                    */
/*   REVISIONS------                                                 */
/*                                                                   */
/*   01/01/03   CHANGED REPORT TO PRINT ON PRINTER P9 INSTEAD        */
/*              OF Q1 (GREENBAR)    C.BUCK                           */
/*   04/27/04   CHANGED REPORT TO PRINT WHERE USER REQUESTED         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PRT)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             ALCOBJ     OBJ((FOLABL *FILE *EXCL *FIRST))
             CLRPFM     FILE(TGMSDATA/FOLABL)
             OVRPRTF    FILE(QSYSPRT) TOFILE(QSYSPRT) PAGESIZE(66 +
                          80) LPI(6) CPI(10) ALIGN(*NO) OUTQ(&PRT) +
                          FORMTYPE(*NAR) SAVE(*YES)
             OVRDBF     FILE(FIORDRSP) SHARE(*YES)
             OPNQRYF    FILE((FIORDRSP)) OPTION(*INP) QRYSLT('OISTAT +
                          *eq "A" *and OIITYP *eq " " *and OISTA +
                          *ne "D"')
             CALL       PGM(GRS212A)
             CLOF       OPNID(FIORDRSP)
             DLTOVR     FILE(FIORDRSP)
             CALL       PGM(GRS212SW)
             DLCOBJ     OBJ((FOLABL *FILE *EXCL *FIRST))

 END:        ENDPGM
