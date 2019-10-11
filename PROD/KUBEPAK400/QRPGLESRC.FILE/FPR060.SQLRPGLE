     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
      //? :````````````````````````````````````````````````````````````:?
      //? :   Title:  Upload Finished Production Schedule Info         :?
      //? :............................................................:?
      //? :````````````````````````````````````````````````````````````:
      //? : Created:  January 2016         ? Kube-Pak Corporation ?    :
      //? :      by:  William J. Behr                                  :
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :   Program Description                                     ?:
      //? : ```````````````````````                                   ?:
      //? :                                                           ?:
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :?  Edit Log                                                ?:
      //? :                                                           ?:
      //? :  WJB    -? 1/22/16 - Initial Programming                  ?:
      //? :         -?  /  /   - _____________________________________?:
      //? :............................................................:

      //? Main procedure prototype & interface
     D FPR060          PR                  ExtPgm('FPR060')
     D FPR060          PI

      *? Function Prototypes
    ?D/COPY QFunctDefn,QCMDEXC
    ?D/COPY QFunctDefn,$DftPrt
    ?D/COPY QFunctDefn,$ChgPrt
    ?D/COPY QFunctDefn,$User
     D PrintBatch      PR                  ExtPgm('FPR066')
     D  #Batch                        6P 0 const
     D  #Printer                     10A   const

      *? Fields
     D  Command        S            256A   inz(*Blanks)
     D  Batch#         S              6S 0 inz(2)
     D  Printer        S             10A   inz(*Blanks)

      /Free

         Exec SQL
           DROP TABLE   QTEMP/FFINPPDUP2;
         Exec SQL
           DROP TABLE   QTEMP/FFINPPDTAG;
         Exec SQL
           DROP TABLE   QTEMP/FFINPPDPRT;


         Command = 'XLPARSE2/XLSTABLE ' +
                   'XLS(''/KUBE PAK/XLSIMPORT/FINPRDMRG.XLSX'') ' +
                   'FILE(QTEMP/FFINPPDUP2) ' +
                   'CRTFILE(*YES) '+
                   'SRCFILE(TGMSDATA/QDDSSRC) ' +
                   'HLINES(1) ' +
                   'DATECOL(1 2)'   ;
         QCmdExc(Command:%Len(%Trim(Command)));

         Exec SQL
           DELETE FROM FFINPPDUPL;

         Exec SQL
           insert into ffinppdupl (
             SELECT CASE when FLD1 = ' ' then date('01/01/2000')
                                         else date(FLD1)           end case
                  , CASE when FLD2 = ' ' then date('01/01/2000')
                                         else date(FLD2)           end case
                  , int(FLD3)
                  , int(FLD4)
                  , char(FLD5)
                  , char(int(FLD6))
                  , char(int(FLD7))
                  , int(FLD8)
             FROM qtemp/ffinppdup2
           );

         Exec SQL
           Select  Max(FPBAT#)
           INTO   :Batch#
           From    FFINPPDTAG;

         Batch# += 1;

         Exec SQL
           INSERT INTO FFINPPDTAG  OVERRIDING USER VALUE
             ( SELECT 0
                    ,:Batch#
                    , FUDATE
                    , FUDATE
                    , FUSHIP
                    , FUPLTG
                    , FUCUST
                    , FUCABB
                    , FUITEM
                    , FUSIZE
                    , FUQTY
                    , 0
                    , 0
                    , CASE when FUDATE = date('01/01/2000') THEN '  -  ' ELSE
                        right('00'||month(FUDATE),2)||'/'||
                        right('00'||day(FUDATE),2)  END CASE
                    , CASE when FUSHIP = date('01/01/2000') THEN '  -  ' ELSE
                        right('00'||month(FUSHIP),2)||'/'||
                        right('00'||day(FUSHIP),2)  END CASE
                    , ' '
                    , 'N'
                    , 'N'
                    , 0
                    , USER
                    , CURRENT TIMESTAMP
               FROM FFINPPDUPL );

         Exec SQL
           UPDATE  FFINPPDTAG
           Set     FPDESC =
                     (Select IMDES1
                      from   FMINVT
                      Where  IMITEM||IMSIZE = FPITEM||FPSIZE)
           Where   FPBAT# = :Batch#
             and   FPITEM||FPSIZE in
                     (Select IMITEM||IMSIZE from FMINVT);

         // PrintBatch(Batch#:Printer);

         *InLR = *On;

       /End-Free
