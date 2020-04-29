<!DOCTYPE html>
<html>

<head>
    <title>Images Selected for Kube-Pak Items</title>
	<link type="text/css" href="../kpphp.css" rel="stylesheet">	
</head>

<body>

<?php
session_start();
$target_dir     = "../TEMPPICTURES/";
$target_dir_tn  = "../TEMPPICTURES/";  // Leave in same directory
$source_file    = $target_dir . basename($_FILES["fileToUpload"]["name"]);
$target_file    = $target_dir . $_SESSION["KPitem"] . ".jpg";
$target_file_tn = $target_dir_tn . $_SESSION["KPitem"] . "_tn.jpg";
$target_file_tn2 = $target_dir_tn . $_SESSION["KPitem"] . "_tn2.jpg";
?>

<h1>Images Selected for Kube-Pak Items</h1>
<hr>
<br>

<h2>
    <?php echo "Selected image for item " . $_SESSION["KPitem"]  . "<br> (" . $_SESSION["KPdescription"] . ")"?>
</h2>
<br>
<br>

<?php

// Use Check if $uploadOk is set to 0 by an error
if (checkImage($_FILES["fileToUpload"]["tmp_name"],$target_file) == 0) {
    echo "Sorry, your file was not uploaded.<br>";
// if everything is ok, try to upload file
} else {
    if (move_uploaded_file($_FILES["fileToUpload"]["tmp_name"], $target_file)) {
        echo "&#10004;The file ". basename( $_FILES["fileToUpload"]["name"]). " has been uploaded to the staging folder.<br>";

        createThumbnail($target_file,$target_file_tn);
        ?>
        <br>
        Review the content below, then click the [ Move to Production Folder ] button.<br>
        (Use the browser back button to reselect a different image.)<br>
        <br>
        <form action="movitmpic.php" method="post" enctype="multipart/form-data">
        <input type="submit" value="Move to Production Folder" name="submit">
        <br>
        <br>
        <Table style="width:820px" class="lists">
            <tr>
                <th style="width:470px">Item Image Sized to 450px for website</th>
                <th style="width:175px">Thumbnail Full Size</th>
                <th style="width:175px">Thumbnail at 20px</th>
            </tr>
                <td><?php echo "UPLOADED ITEM IMAGE:<br>" . $target_file . "<br>";?></td>
                <td colspan="2"><?php echo "THUMBNAIL:<br>" . $target_file_tn  . "<br>"; ?></td>
            </tr>
            <tr>
            </tr>
            <tr>
                <td style="center"><a href="<?php echo $target_dir . $_SESSION["KPitem"];?>.jpg"    target="_blank">
                                  <img src="<?php echo $target_dir . $_SESSION["KPitem"];?>.jpg"    alt='Uploaded File' width='450'></a></td>
                <td style="center"><a href="<?php echo $target_dir_tn . $_SESSION["KPitem"];?>_tn.jpg" target="_blank">
                                  <img src="<?php echo $target_dir_tn . $_SESSION["KPitem"];?>_tn.jpg" alt='Thumbnail Image File' width=120></a></td>
                <td style="center"><img src="<?php echo $target_dir_tn . $_SESSION["KPitem"];?>_tn.jpg" alt='Thumbnail Image at 20px' width=20><br></td>
            </tr>
        </Table>
</form>
        <?php
    } else {
            echo "Sorry, there was an error uploading your file.";
    }
}


//---F-U-N-C-T-I-O-N-S--------------------------------------

function checkImage($checkImage,$target_file)
{
    $imageFileType = strtolower(pathinfo($target_file,PATHINFO_EXTENSION));

    // Check if image file is a actual image or fake image
    if(isset($_POST["submit"])) {
        //convertImage($originalImage, $outputImage, $quality);
        //convertImage($originalImage, $outputImage, $quality);
        $check = getimagesize($checkImage);
        if($check !== false) {
            echo "&#10004;File is an image - " . $check["mime"] . ".<br>";
        } else {
            echo "&#42;File is not an image.<br>";
            return 0;
        }
    }

    // Check file size
    if ($_FILES["fileToUpload"]["size"] > 1500000) {
        echo "&#42;Sorry, your file is too large.<br>";
        return 0;
    } else {
       // echo "the original file size is: " . getimagesize($checkImage) . ".<br>";
    }
    
    // Allow certain file formats
    if($imageFileType != "jpg" 
    && $imageFileType != "jpeg" 
    //&& $imageFileType != "bmp" 
    && $imageFileType != "gif" 
    && $imageFileType != "png" ) {
        echo "&#42;Sorry, only JPG, JPEG, GIF, & PNG files are allowed.  Type Found: (".$imageFileType.")<br>";
        return 0;
    }
        return 1;
}
//---------------------------------------------------------------
function createThumbnail($target_file,$target_file_tn)
{
    imagejpeg(resize_image($target_file,120,120,FALSE),$target_file_tn);
    // if(imagejpeg(resize_image($target_file,120,120,FALSE),$target_file_tn)){
    //     echo "&#10004;The thumbnail file has been created and uploaded to the staging folder.<br>";
    // }else{
    //     echo "&#42;An error occurred creating the thumbnail.<br>";
    // };
}
//---------------------------------------------------------------
function resize_image($fromFile, $w, $h, $crop=FALSE) {
    list($width, $height) = getimagesize($fromFile);
    $r = $width / $height;
    if ($crop) {
        if ($width > $height) {
            $width = ceil($width-($width*abs($r-$w/$h)));
        } else {
            $height = ceil($height-($height*abs($r-$w/$h)));
        }
        $newwidth = $w;
        $newheight = $h;
    } else {
        if ($w/$h > $r) {
            $newwidth = $h*$r;
            $newheight = $h;
        } else {
            $newheight = $w/$r;
            $newwidth = $w;
        }
    }
    $errorLevel = error_reporting();
    error_reporting(0);
    $dst = imagecreatetruecolor($newwidth, $newheight);

    $src = imagecreatefromjpeg($fromFile);
    if(!$src){
        $src = imagecreatefrompng($fromFile);
        if(!$src){
            $src = imagecreatefromgif($fromFile);
            if(!$src){
                $src = imagecreatefrombmp($fromFile);
                if(!$src){
                    echo "File could not be converted to a thumbnail image.";
                }
            }
        }
    }
    error_reporting($errorLevel);
    if (imagecopyresampled($dst, $src, 0, 0, 0, 0, $newwidth, $newheight, $width, $height)){
        debugToConsole("imagecopyresampled: SUCCESS!");
    } else {
        debugToConsole("imagecopyresampled: **FAILED**");
    };
    imagedestroy($src);

    return $dst;
}
//---------------------------------------------------------------
function debugToConsole($msg) { 
    echo "<script>console.log(".json_encode($msg).")</script>";
}