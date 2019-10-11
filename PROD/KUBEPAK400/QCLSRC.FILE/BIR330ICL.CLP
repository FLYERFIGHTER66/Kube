/*********************************************************************/
/*   PROGRAM-------- BIR330CL                                        */
/*   DATE WRITTEN--- 10/20/98                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- PRINT INVOICES FROM BIR235                      */
/*   REVISIONS------                                                 */
/*  5/07/97 EFD NEW LDA                                              */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/RTVDTAARA DTAARA(*LDA (31 10)) RTNVAR(&PRT)
             QSYS/OVRPRTF FILE(BIR330A) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(10) +
                          ALIGN(*NO) FORMTYPE(*INV)
             CALL       PGM(BIR330I)
 END:        ENDPGM
