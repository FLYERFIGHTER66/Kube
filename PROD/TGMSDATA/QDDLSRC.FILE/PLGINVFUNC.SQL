  CREATE OR REPLACE FUNCTION Standard_Plug_53Week_Availability ()

    RETURNS TABLE
        (
        ITEM_NUMBER         char(12),
        ITEM_SIZE           char(3),
        ITEM_DESCRIPTION    char(30),
        ITEM_SORT           char(15),

        WK00                dec(11,2),
        WK01                dec(11,2),
        WK02                dec(11,2),
        WK03                dec(11,2),
        WK04                dec(11,2),
        WK05                dec(11,2),
        WK06                dec(11,2),
        WK07                dec(11,2),
        WK08                dec(11,2),
        WK09                dec(11,2),

        WK10                dec(11,2),
        WK11                dec(11,2),
        WK12                dec(11,2),
        WK13                dec(11,2),
        WK14                dec(11,2),
        WK15                dec(11,2),
        WK16                dec(11,2),
        WK17                dec(11,2),
        WK18                dec(11,2),
        WK19                dec(11,2),

        WK20                dec(11,2),
        WK21                dec(11,2),
        WK22                dec(11,2),
        WK23                dec(11,2),
        WK24                dec(11,2),
        WK25                dec(11,2),
        WK26                dec(11,2),
        WK27                dec(11,2),
        WK28                dec(11,2),
        WK29                dec(11,2),

        WK30                dec(11,2),
        WK31                dec(11,2),
        WK32                dec(11,2),
        WK33                dec(11,2),
        WK34                dec(11,2),
        WK35                dec(11,2),
        WK36                dec(11,2),
        WK37                dec(11,2),
        WK38                dec(11,2),
        WK39                dec(11,2),

        WK40                dec(11,2),
        WK41                dec(11,2),
        WK42                dec(11,2),
        WK43                dec(11,2),
        WK44                dec(11,2),
        WK45                dec(11,2),
        WK46                dec(11,2),
        WK47                dec(11,2),
        WK48                dec(11,2),
        WK49                dec(11,2),

        WK50                dec(11,2),
        WK51                dec(11,2),
        WK52                dec(11,2),
        WK53                dec(11,2)
        )

    LANGUAGE SQL
    Not Deterministic

    BEGIN
      Return
        Select ITEM_NUMBER, ITEM_SIZE, ITEM_DESCRIPTION, ITEM_SORT,
            WK00,WK01,WK02,WK03,WK04,WK05,WK06,WK07,WK08,WK09,
            WK10,WK11,WK12,WK13,WK14,WK15,WK16,WK17,WK18,WK19,
            WK20,WK21,WK22,WK23,WK24,WK25,WK26,WK27,WK28,WK29,
            WK30,WK31,WK32,WK33,WK34,WK35,WK36,WK37,WK38,WK39,
            WK40,WK41,WK42,WK43,WK44,WK45,WK46,WK47,WK48,WK49,
            WK50,WK51,WK52,WK53
        from PLUG_INVENTORY_53WEEK_SUMMARY
        Order by ITEM_SORT, ITEM_SIZE;

    END ;

