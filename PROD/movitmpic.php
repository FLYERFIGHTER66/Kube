<?php 
session_start();
// connect to db2
$options = array('i5_naming'=> DB2_I5_NAMING_ON, 'i5_libl' => 'KUBEPAK400');
$sqlStmt = "CALL MOVE_ITEM_PIC_TO_PICTURES_SP('" . $_SESSION["KPitem"] . "')";
	
$conn = db2_connect("","","", $options)
    or die("Connection failed! ". db2_conn_errormsg()); 

$stmt = db2_prepare ( $conn, $sqlStmt ) 
    or die ( "<br>Prepare failed! <pre><br> $sqlStmt </pre><br>" . db2_stmt_errormsg () );
	
db2_execute($stmt)
    or die ( "<br>Execute failed! <pre><br>$sqlStmt </pre><br>" . db2_stmt_errormsg () );

?>
<br><br>Move function complete. You can Close this Tab or Window.