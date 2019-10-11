/*********************************************************************/
/*   PROGRAM-------- SPC130CL                                        */
/*   DATE WRITTEN---  2/12/97                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- PRINT WEEKLY AVAIL REPORT                       */
/*   REVISIONS------                                                 */
/*  02/27/98 JJP  ADD FUNCTIONALITY TO OVERRIDE PRINTER FILE.        */
/*                FROM SELECTION PROGRAM SPC13A.                     */
/*               PRINTER ID                                          */
/*               RETRIEVE ABOVE FROM LDA/OFFSET VARIABLES/TO         */
/*               OVRPRTF PARAMETERS                                  */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
 /* JJP */
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
 /* JJP */
             CALL       PGM(SPC13A)
             QSYS/RTVDTAARA DTAARA(*LDA (7 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))
 /* JJP */
             QSYS/RTVDTAARA DTAARA(*LDA (8 10)) RTNVAR(&PRT)
             /**/
/*           QSYS/OVRPRTF FILE(SPC130) TOFILE(*LIBL/QSYSPRT) +
                          DEV(XERPRT01) PAGESIZE(66 85) LPI(6) CPI(10) +
                          FORMTYPE(*NAR)    */
             /**/
             QSYS/OVRPRTF FILE(SPC130) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 85) LPI(6) CPI(10) +
                          FORMTYPE(*NAR)
 /* JJP */
             CALL       PGM(SPC130)
 END:        ENDPGM
