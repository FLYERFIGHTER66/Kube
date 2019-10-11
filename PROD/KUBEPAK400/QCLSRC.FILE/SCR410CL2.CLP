/*********************************************************************/
/*   PROGRAM-------- SCR410PCL                                       */
/*   DATE WRITTEN---  4/04/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- PRINT PUT DOWN WORK SHEETS     CALLED           */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SHCYM &MASTER &ITEM &SIZE)
             DCL        VAR(&SHCYM) TYPE(*DEC) LEN(7 0)
             DCL        VAR(&MASTER) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&ITEM) TYPE(*CHAR) LEN(12)
             QSYS/DCL   VAR(&SIZE) TYPE(*CHAR) LEN(3)

             DCL        VAR(&PRTR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FORM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COPY@) TYPE(*CHAR) LEN(2)
             DCL        VAR(&COPY) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&HOLD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SAVE) TYPE(*CHAR) LEN(4)

             RTVDTAARA  DTAARA(*LDA (100 10)) RTNVAR(&PRTR)
             RTVDTAARA  DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             RTVDTAARA  DTAARA(*LDA (120 02)) RTNVAR(&COPY@)
             RTVDTAARA  DTAARA(*LDA (123 04)) RTNVAR(&HOLD)
             RTVDTAARA  DTAARA(*LDA (127 04)) RTNVAR(&SAVE)

             CHGVAR     VAR(&COPY) VALUE(&COPY@)

             QSYS/OVRPRTF FILE(SCR410) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRTR) PAGESIZE(66 96) LPI(6) CPI(12) +
                          ALIGN(*NO) SPOOL(*YES) FORMTYPE(&FORM) +
                          COPIES(&COPY) HOLD(&HOLD) SAVE(&SAVE)

             CALL       PGM(SCR410P) PARM(&SHCYM &MASTER &ITEM &SIZE)

 END:        ENDPGM
