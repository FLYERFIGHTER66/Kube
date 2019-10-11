     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format

      //  Main procedure prototype & interface
     D PCK040          PR                  ExtPgm('PCK040')
     D  #SelFord                      6P 0 Const
     D  #SelTord                      6P 0 Const
     D  #SelList                      6A   Const
     D PCK040          PI
     D  #SelFord                      6P 0 Const
     D  #SelTord                      6P 0 Const
     D  #SelList                      6A   Const

     D DockPick        PR                  ExtPgm('PCK010')
     D  #Order                        6P 0 Const
     D  #SelGrup                     10A   Const
     D  #SelList                      6A   Const

     D/COPY QFunctDefn,$_Dates

     D RHORDR        E DS                  Inz EXTNAME(FHORDR)

     D SelFord         S                       Like(#SelFord)
     D SelTord         S                       Like(#SelTord)
     D SelList         S                       Like(#SelList)

      /Free

         Monitor;
           SelFord = #SelFord;
           SelTord = #SelTord;
           SelList = #SelList;
         On-Error;
           Return;
         ENDMON;

         Monitor;
           SQLSTATE = '00000';

         Exec SQL
           Declare C1 Cursor for
           Select  *
           from    FHORDR
           Where   OHORD# between :SelFord and :SelTord
           For Read Only;

           Exec SQL   Close C1;
           Exec SQL   Open C1;

           DoW SQLSTATE = '00000';
             Exec SQL  Fetch C1 into :RHORDR;
             If  SQLSTATE = '00000' and OHORD# <> 0;
               DockPick(OHORD#:'*ALL':SelList);
             ENDIF;
           ENDDO;

           Exec SQL   Close C1;

         On-Error;
           Exec SQL   Close C1;
         ENDMON;

         Return;
