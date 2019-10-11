       // FIELD PROC for Zoned(16:0) ONLY

        Ctl-Opt  debug option(*NODEBUGIO : *SRCSTMT );
        Ctl-Opt  dftactgrp(*no) actgrp(*caller);
        Ctl-Opt  thread(*serialize);

      /Include QSYSINC/QRPGLESRC,SQLFP
      /Include KUBEPAK400/QSQLSRC,$FLD_TYP

        dcl-pr FP_CRC#                 extpgm('FP_CRC#');
           functionCode                int(5) const;
           optParms                    likeds(SQLFOPVD);
           decodeType                  likeds(SQLFPD);
           decodeData                  zoned(16:0);
           encodeType                  likeds(SQLFPD);
           encodeData                  varchar(32);
           pSqlState                    char(5);
           sqlMsgText                  likeds(SQLFMT);
        end-pr;
        dcl-pi FP_CRC#;
           functionCode                int(5) const;
           optParms                    likeds(SQLFOPVD);
           decodeType                  likeds(SQLFPD);
           decodeData                  zoned(16:0);
           encodeType                  likeds(SQLFPD);
           encodeData                  varchar(32);
           pSqlState                    char(5);
           sqlMsgText                  likeds(SQLFMT);
        end-pi;

       dcl-c  ENCODE                  0;
       dcl-c  DECODE                  4;
       dcl-c  INITIALIZE              8;

       dcl-c  UnsupportedDataType     '38001';

       dcl-s  passphrase varchar(256) Inz('We Should Realy Hide this Better!!');

        pSqlState = '00000';

        select;
          when functionCode = INITIALIZE;
            INITIALIZE_SP();
          when functionCode = ENCODE;
            ENCODE_SP();
          when functionCode = DECODE;
            DECODE_SP();
          other;
            pSqlState = '38003';
        endsl;


        Return ;


       //---------------------------------------------------------------------
       // Initialize_SP
       //---------------------------------------------------------------------
        dcl-proc  Initialize_SP;
          // Called when FIELDPROC is initially added to the field.
          // This procedure returns the SQL Data Type that will be
          // used to store the encoded data.

            // Verify field type is Zoned
             if  decodeType.SQLFST <> SQL_TYP_ZONED;
               // Return error for unsupported data type
                pSqlState = UnsupportedDataType;
                sqlMsgText = 'Invalid data type for fieldproc';
             else;
               // The Encoded value has almost all of the same attributes
               // as the decoded value...just need to change the length.
                encodeType = decodeType;
                encodeType.SQLFST = %int(SQL_TYP_VARCHAR);
                encodeType.SQLFL = 40;
                encodeType.SQLFBL = 40;
             endif;

       end-proc;

       //---------------------------------------------------------------------
       // Encode_SP
       //---------------------------------------------------------------------
        dcl-proc  Encode_SP;
           // Called (usually) on write/update to encode the field.

                // make sure we don't encode a masked value !!
                 if decodeData <= 9999;
                      pSqlState = '09501';
                      sqlMsgText = 'Encoding not valid for a masked value';
                 else;
                     // your logic to encrypt the data goes here...
                      encodeData = EncodeCard(decodeData);
                      pSqlState = sqlState;
                 endif;

       end-proc;

       //---------------------------------------------------------------------
       // Decode_SP
       //---------------------------------------------------------------------
       dcl-proc  Decode_SP;
           // Called (usually) on read to decode the field.
                // logic to encode the data goes here
                 decodeData = DecodeCard(encodeData);
                 pSqlState = sqlState;

       end-proc;



       //---------------------------------------------------------------------
       // Procedure to encode data
       //---------------------------------------------------------------------
        dcl-proc  EncodeCard;
          dcl-pi  EncodeCard           varchar(32);
            inData                     zoned(16);
          end-pi;

         dcl-s encodedText varchar(32);

          Exec SQL
            Set :encodedText = encrypt(char(:inData), :passphrase);
          Return encodedText;

        end-proc  EncodeCard;


       //---------------------------------------------------------------------
       // Procedure to decode data
       //---------------------------------------------------------------------
        dcl-proc  DecodeCard;
          dcl-pi  DecodeCard           zoned(16:0);
            inData                     varchar(32);
          end-pi;

          dcl-s   decodedText          zoned(16:0);

          Exec SQL
            Set :decodedText = int(decrypt_char(:inData, :passphrase));

          Return decodedText;

        end-proc  DecodeCard;

