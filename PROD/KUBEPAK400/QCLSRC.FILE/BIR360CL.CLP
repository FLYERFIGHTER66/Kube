/*********************************************************************/
/*   PROGRAM-------- BIR360CL                                        */
/*   DATE WRITTEN--- 07/30/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- DOP UPDATE SHIST & MSALES FILES  DOP            */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)

             QSYS/OVRPRTF FILE(BIR365) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(15) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(*YES) SAVE(&SAVE)
             CALL       PGM(BIR365)
/*   OUTPUT CUSTOMER SUMMARY RECORDS FOR SALES HISTORY               */
             CALL BIR510
/* OUTPUT ITEM SUMMARY RECORDS FOR SALES HISTORY                     */
             CALL BIR515
/* UPDATE MINVT,TINVT,SOHST                                          */
/*  OUTPUT RECORDS TO SHIPPED ORDER HISTORY FILE                     */
             QSYS/OVRPRTF FILE(BIR520) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(10) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)
             CALL BIR520
/* OUTPUT SALESMAN SUMMARY RECORDS FOR SALES HISTORY                 */
             CALL BIR530
/* Clears Broker Sales Summary Records in FSHISTS                    */
             CALL SUMCLR
/* Creates Broker Sales Summary Records in FSHISTS                   */
             CALL SUMBROK
 END:        ENDPGM
