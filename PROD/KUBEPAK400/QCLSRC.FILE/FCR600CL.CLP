/*********************************************************************/
/*   PROGRAM-------- FCR200CL                                        */
/*   DATE WRITTEN---  8/09/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- GROWTH RETARDANT WEEKLY REVIEW                  */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SEC &BAY &NOS &EOW &PRT)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SEC) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&BAY) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&NOS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&EOW) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)

      /*     DLTF       FILE(QTEMP/FFINLOCTAG)       +
             MONMSG     MSGID(CPF2105)              */

             RTVOBJD    OBJ(FFINLOCTAG) OBJTYPE(*FILE) RTNLIB(&LIB)
             CALL       PGM(FCR600) PARM(&LIB &SEC &BAY &NOS &EOW &PRT)

 END:
             ENDPGM
