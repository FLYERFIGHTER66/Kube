**free

ctl-opt DftActGrp(*no)
        DatFmt(*usa)
        BndDir('HTTPAPI': 'QC2LE')  ;

dcl-s Outfile sqltype(xml_clob_file) ;

dcl-s ToOrgId varchar(256) inz;
dcl-s FromOrgId varchar(256) inz;
dcl-s VendorNumber varchar(256) inz;
dcl-s VendorName varchar(256) inz;

dcl-s Path varchar(256) inz('/Webservices/missing_defaults.xml');
dcl-s URL varchar(256) inz;
dcl-s ThisBrokerID char(15) inz('Gloeckner');
dcl-s WkTempFile Char(200) inz;
dcl-S WkFile varchar(256) inz;

Dcl-Pi WSGLKINV02;
   PBrokerId    Char(6);
End-Pi;

/Include QRpglesrc,Httpapi_h

exec sql SET OPTION COMMIT      = *NONE,
                    CLOSQLCSR   = *ENDMOD,
                    DATFMT      = *ISO ;

Get_Defaults();
Generate_XML_File();
Send_XML_File();

*inlr = *on ;

//------------------------------------------------------------------------------
//       Get_Defaults from Broker_Defaults_Control
//------------------------------------------------------------------------------
dcl-proc Get_Defaults;


  // FromOrgId
  exec sql
     Select trim(BROKER_VARIABLE_VALUE) INTO :FromOrgId
      from Broker_Defaults_Control
        where BROKER_NUMBER = :PBrokerId
          and BROKER_VARIABLE = 'FromOrgId';
  // ToOrgId
  exec sql
     Select trim(BROKER_VARIABLE_VALUE) INTO :ToOrgId
      from Broker_Defaults_Control
        where BROKER_NUMBER = :PBrokerId
          and BROKER_VARIABLE = 'ToOrgId';
  // VendorNumber
  exec sql
     Select trim(BROKER_VARIABLE_VALUE) INTO :VendorNumber
      from Broker_Defaults_Control
        where BROKER_NUMBER = :PBrokerId
          and BROKER_VARIABLE = 'VendorNumber';
  // VendorName
  exec sql
     Select trim(BROKER_VARIABLE_VALUE) INTO :VendorName
      from Broker_Defaults_Control
        where BROKER_NUMBER = :PBrokerId
          and BROKER_VARIABLE = 'VendorName';
  // URL
  exec sql
     Select trim(BROKER_VARIABLE_VALUE) INTO :URL
      from  Broker_Defaults_Control
      where BROKER_NUMBER = :PBrokerId
        and BROKER_VARIABLE = 'URL INVENTORY POST';

END-PROC;

//------------------------------------------------------------------------------
//       Generate_XML_File
//------------------------------------------------------------------------------
dcl-proc Generate_XML_File;


  exec sql   // PATH
     Select trim(BROKER_VARIABLE_VALUE) INTO :Path
      from Broker_Defaults_Control where BROKER_VARIABLE = 'IFSINVPATH';
  exec sql   // WkFile
     Set :WkFile = 'AVL-' || trim(:ThisBrokerID) || '_' || CURRENT TIMESTAMP  || '.xml';

  clear Outfile ;

  Outfile_Name = %trimr(%trim(Path)+%trim(WkFile)) ;
  Outfile_NL   = %len(%trimr(Outfile_Name)) ;
  Outfile_FO   = SQFCRT ;

  exec sql
VALUES(SELECT XMLELEMENT (                                  NAME "AvailabilityFeed",
        XMLELEMENT (                                        NAME "Identification",
            XMLFOREST
                ( 'AvailabilityFeed'                            AS "MessageProtocol_ID",
                   current date  || 'T' || current timestamp    AS "Reference_ID",
                   current date  || 'T' || current time         AS "DateTime",
                    trim(:FromOrgId)                            AS "FromOrg_ID",
                    trim(:ToOrgId)                              AS "ToOrg_ID")),
        XMLELEMENT (                                        NAME "AvailabilityHeader",
            XMLFOREST
                ( trim(:VendorNumber)                           AS "VendorNumber",
                  trim(:VendorName)                             AS "VendorName")),
        XMLAGG (
           XMLELEMENT (                                     NAME "AvailabilityItem",
               XMLELEMENT (                                 NAME "MaterialNumber",
                   XMLFOREST ( 'SELLER'                         AS "Type",
                           RTRIM(ITEM_NUMBER)||RTRIM(ITEM_SIZE) AS "Number")),
               XMLELEMENT (                                 NAME "AvailabilityDate",
                   XMLFOREST ( READY_DATE                       AS "Date")),
               XMLELEMENT (                                 NAME "Units",
                   XMLFOREST ( 'EA'                             AS "UnitOfMeasure",
                               int(QUANTITY_AVAILABLE)          AS "Count"))))
                   )
        FROM    KUBE_PAK_STANDARD_PLUG_INVENTORY
        WHERE   VIEW_CONTROL_TYPE = 'WEB'
         AND   READY_DATE between  MOST_RECENT_MONDAY
                               and MOST_RECENT_MONDAY + 365 days)
INTO :Outfile ;

END-PROC;

//------------------------------------------------------------------------------
//       Send_XML_File
//------------------------------------------------------------------------------
dcl-proc Send_XML_File;

// To get tech info about the HTTP transaction
Http_debug(*ON: '/tmp/httpapi_POSTBRKINV_234.log');
// HTTP creates new file to receive reply
WkTempfile = http_tempfile();
// POST Stmf to client site
Http_url_post_stmf(%Trim(Url) :%Trim(Path) + %Trim(WkFile) :WkTempFile);

END-PROC;
