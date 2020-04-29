<!DOCTYPE html>
<html>

<head>
    <title>Select Images for Kube-Pak Items</title>
	<link type="text/css" href="../kpphp.css" rel="stylesheet">	
</head>

<script language="javascript"> 
    var width = 600; 
    var height = 400; 
    window.resizeTo(width, height); 
    window.moveTo(50,50); 
</script>

<body>


<h1>Select Images for Kube-Pak Items</h1>

<hr>
<br>
<?php
session_start();
$_SESSION["KPitem"] = $_GET['item'];
$_SESSION["KPdescription"] = $_GET['description'];
?>

<h2>
Select an image for item <?php echo $_SESSION["KPitem"]?>  
<br><?php echo $_SESSION["KPdescription"]?>
</h2>
<br>
<a href="https://www.google.com/search?tbm=isch&q=<?php echo $_SESSION["KPdescription"] ?>" target="_blank"><button class="button">Google Search for <?php echo $_SESSION["KPdescription"]?></button></a>
<br>
<br>
<br>
<form action="uplitmpic.php" method="post" enctype="multipart/form-data">
    Select image to upload:
    <br><br>
    <input type="file" name="fileToUpload" id="fileToUpload"><br>
    <input type="hidden" name="KPitem" id="KPitem" value="<?php echo $_GET['item'] ?>">
    <br>
    <input type="submit" value="Upload Image" name="submit">
</form>
<br>
<br>




</body>
</html>