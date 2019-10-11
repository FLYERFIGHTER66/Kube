/*********************************************************************/
/*   PROGRAM-------- PRODCLCLJ                                       */
/*   DATE WRITTEN--- 12/14/98                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- SPACE ALLOCATION REPORT   JOBQ                  */
/*   REVISIONS------                                                 */
/*                                                                   */
/*   1/08/03  CAB  CHANGED THE OUTPUT TO 88/120 AND OUTQ P1          */
/*                 AND CPI TO 15. ETC.                               */
/*********************************************************************/
             PGM

             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)

             RUNQRY     QRY(PRODCLQRY) QRYFILE((*SAME))

             RTVDTAARA  DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             IF         COND(&PRT = ' ') THEN(CHGVAR &PRT 'P1')
      /*     QSYS/OVRPRTF FILE(REPORT) TOFILE(*LIBL/QSYSPRT) DEV(Q1) +  */
     /*                   PAGESIZE(66 132) LPI(6) CPI(10) +             */
     /*                   ALIGN(*NO) FORMTYPE(*STD)                     */
  /*CAB*/    QSYS/OVRPRTF FILE(REPORT) TOFILE(*LIBL/QSYSPRT) +
  /*CAB*/                      PAGESIZE(88 120) LPI(8) CPI(15) +
  /*CAB*/                 ALIGN(*NO) OUTQ(&PRT) FORMTYPE(*NAR)
             CALL       PGM(PRODCLR)

 END:        ENDPGM
