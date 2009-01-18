<html>
<head>
<title>-+ The District +-</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-store">
<link rel="icon" href="images/thedistrict.ico" />
<link href="cont.css" rel="stylesheet" type="text/css" />
</head>

<body>
<table cellpadding="5" cellspacing="0" width="450px" align="center">
	<tr>
	  <td class="head">
		Contact us
	</td>
	</tr>

	<tr><td>
		<strong>&nbsp;Phone:</strong><br />
		&nbsp;&nbsp;office-248.391.6166<br /><br />
		
		<strong>&nbsp;Email:</strong><br />
		&nbsp;&nbsp;mail@thedistrictvenue.com<br /><br />
		
		
		<strong>&nbsp;Mail:</strong><br />
		&nbsp;&nbsp;The District<br />
		&nbsp;&nbsp;4005 S. Baldwin Rd.<br />
		&nbsp;&nbsp;Orion, MI 48359
	</td></tr>
	<tr><td align="center"><img src="images/blank.gif" width="100%" height="1px" /></td></tr>
	<tr>
	  <td class="head">
		question or comment
	</td>
	</tr>
	<tr><td>
		Thank you. 
	</td></tr>
</table>
<?php

$today = date('F d, Y  h:i:s A');
$to = "mail@thedistrictvenue.com";
$subject = "The District Contact";
$message = "First Name: " . $title . " " . $fname;
$message .= "\nLast Name: " . $lname;
$message .= "\n\n Date: " . $today;
$message .= "\n\n Address 1: " . $address1;
$message .= "\n Address 2: " . $address2;
$message .= "\n City: " . $city;
$message .= "\n State: " . $state;
$message .= "\n Zip: " . $zip;
$message .= "\n Country: " . $country;
$message .= "\n\n Phone: " . $telephone;
$message .= "\n\n E-mail: " . $email;
$message .= "\n\n Comment: " . $comment;

$headers = "From: $email";
$headers .= "\nReply-To: $email";

$sentOK = mail($to,$subject,$message,$headers);

?> 

</body>
</html>
