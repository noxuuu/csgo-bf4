<?php 
	include 'database.php';
	if($_GET['auth_id'])
	{
		$statement = $dbh->prepare("SELECT name, badge_knife, badge_pistol, badge_rifle, badge_shotgun, badge_smg, badge_awp, badge_mg, badge_nade, badge_kdr, badge_global, badge_insurgent, badge_pyrotechnic, badge_medal, badge_internship, badge_achievements, badge_badges, badge_mine, badge_universal, badge_mixed, badge_time, badge_healing, badge_slowmo, badge_highlight, badge_deaths, badge_connections FROM bf4_players WHERE auth_data = '".$_GET['auth_id']."'"); 
		$statement->execute();
		$row = $statement->fetch();
	}
?>

<!DOCTYPE html>
<html xml:lang="pl" lang="pl" xmlns="http://www.w3.org/1999/xhtml"> 
<head> 
<title>BF4 :: Odznaki</title> 
<link rel="shortcut icon" href="#"/>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1250" />
<style type="text/css">

	html {
	  font-size: 100%;
	  -webkit-text-size-adjust: 100%;
		  -ms-text-size-adjust: 100%;
	}

	body {
    font-size: 12px;
    line-height: 20px;
    color: #000;
    font-family: 'Rajdhani', sans-serif;
    width: 90%;
    background: #080e1b url(http://forum.cs-4frags.pl/bf4/tlo.png) no-repeat scroll center top;
    margin: 0 auto;
	background-attachment: fixed
}

	small {
	  font-size: 85%;
	}

	strong {
	  font-weight: bold;
	  font-size: 16px;
	}

	.text-center {
	  text-align: center;
	}

	table {
	  max-width: 100%;
	  background-color: #8E2323;
	  border-collapse: collapse;
	  border-spacing: 0;
	}

	.table {
	  width: 100%;
	  margin-bottom: 20px;
	}

	.table th,
	.table td {
	  padding: 8px;
	  line-height: 20px;
	  text-align: left;
	  vertical-align: top;
	  border-top: 1px solid #000000;
	}
	td.left1{
	border-bottom-left-radius: 10px;
	border-right: 1px solid #000000;
	}
	td.right1{
	border-bottom-right-radius: 10px;
	}
	td.mid1{
	border-right: 1px solid #000000;
	}
	td.mid11{
	border-right: 1px solid #000000;
	}
	.table caption + thead tr:first-child th {
	  border-top: 0;
	}

	.table-condensed th,
	.table-condensed td {
	  padding: 4px 5px;
	}

	.table-bordered {
	  border: 1px solid #000000;
	  border-collapse: separate;
	  *border-collapse: collapse;
	  width: 75%;
	  border-left: 0;
	  -webkit-border-radius: 10px;
		 -moz-border-radius: 10px;
			  border-radius: 10px;
			  border-left: 1px solid #000000;
	}

	.table-striped tbody > tr:nth-child(odd) > td,
	.table-striped tbody > tr:nth-child(odd) > th {
	  background-color: #f9f9f9;
	}
	
	.text {
	color: white;
	}


	[class^="icon-"],
	[class*=" icon-"] {
	  display: inline-block;
	  width: 14px;
	  height: 14px;
	  margin-top: 1px;
	  *margin-right: .3em;
	  line-height: 14px;
	  vertical-align: text-top;
	  background-image: url("glyphicons-halflings.png");
	  background-position: 14px 14px;
	  background-repeat: no-repeat;
	}


	.icon-ok-sign {
	  background-position: -72px -96px;
	}
	
	.icon-plus {
	  background-position: -408px -96px;
	}

	.icon-gift {
	  background-position: -24px -120px;
	}

	.alert {
	  padding: 8px 35px 8px 35px;
	  margin-bottom: 20px;
	  text-shadow: 0 1px 0 rgba(255, 255, 255, 0.5);
	  background-color: #8E2323;
	  width: 20%;
	  border: 1px solid #fbeed5
	  -webkit-border-radius: 10px;
		 -moz-border-radius: 10px;
			  border-radius: 10px;
	}

	.alert,
	.alert strong {
	  color: white;
	}

	.alert strong {
	  margin: 0;
	}
	
	.active {
		font-weight: bold;
		color: white;
		text-shadow: 0 0 3px lime, 0 0 5px lime;
		background: rgba(142, 35, 35, 1);
		background: -moz-linear-gradient(top, rgba(142, 35, 35, 1) 0%, rgba(142, 35, 35, 0.84) 30%, rgba(142, 35, 35, 0.84) 44%, rgba(142, 35, 35, 0.70) 100%);
		background: -webkit-gradient(left top, left bottom, color-stop(0%, rgba(142, 35, 35, 1)), color-stop(30%, rgba(142, 35, 35, 0.84)), color-stop(44%, rgba(142, 35, 35, 0.84)), color-stop(100%, rgba(142, 35, 35, 0.70)));
		background: -webkit-linear-gradient(top, rgba(142, 35, 35, 1) 0%, rgba(142, 35, 35, 0.84) 30%, rgba(142, 35, 35, 0.84) 44%, rgba(142, 35, 75, 0.60) 100%);
		background: -o-linear-gradient(top, rgba(142, 35, 35, 1) 0%, rgba(142, 35, 35, 0.84) 30%, rgba(142, 35, 35, 0.84) 44%, rgba(142, 35, 35, 0.70) 100%);
		background: -ms-linear-gradient(top, rgba(142, 35, 35, 1) 0%, rgba(142, 35, 35, 0.84) 30%, rgba(142, 35, 35, 0.84) 44%, rgba(142, 35, 35, 0.70) 100%);
		background: linear-gradient(to bottom, rgba(142, 35, 35, 1) 0%, rgba(142, 35, 35, 0.84) 30%, rgba(142, 35, 35, 0.84) 44%, rgba(142, 35, 35, 0.70) 100%);
		filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#8e2323', endColorstr='#8e2323', GradientType=0);
	}
}

</style>
</head> 
<body> 
<br/>
<p><center><img src="logo.png" weight="105" height="150"></center></p>
<br>
<center><table class="table table-bordered table-condensed table-striped">
	<caption><div class="alert"><strong>Odznaka za Walkę Nożem</strong></div></caption>
	<thead>
		<tr>
			<th><div class="text-center"><div <?php if($row['badge_knife'] >= 1) echo 'class="active"'; else echo 'class="text"';?>>I Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_knife'] >= 2) echo 'class="active"'; else echo 'class="text"';?>>II Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_knife'] >= 3) echo 'class="active"'; else echo 'class="text"';?>>III Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_knife'] >= 4) echo 'class="active"'; else echo 'class="text"';?>>IV Stopnia</div></div></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td <?php if($row['badge_knife'] >= 1) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 20% Obrażeń zadanych nożem zamienia się w HP</div></td>
			<td <?php if($row['badge_knife'] >= 2) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 40% Obrażeń zadanych nożem zamienia się w HP</div></td>
			<td <?php if($row['badge_knife'] >= 3) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 60% Obrażeń zadanych nożem zamienia się w HP</div></td>
			<td <?php if($row['badge_knife'] >= 4) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 80% Obrażeń zadanych nożem zamienia się w HP</div></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			<td <?php if($row['badge_knife'] >= 1) echo 'class="active"';?> class = "left1"><div class="text-center"><i class="icon-ok-sign"></i> 50 Zabić Nożem<br /><i class="icon-ok-sign"></i> 1 Zabicie Nożem w rundzie</div></td>
			<td <?php if($row['badge_knife'] >= 2) echo 'class="active"';?> class = "mid1"><div class="text-center"><i class="icon-ok-sign"></i> 100 Zabić Nożem<br /><i class="icon-ok-sign"></i> 2 Zabicia Nożem w rundzie</div></td>
			<td <?php if($row['badge_knife'] >= 3) echo 'class="active"';?> class = "mid11"><div class="text-center"><i class="icon-ok-sign"></i> 150 Zabić Nożem<br /><i class="icon-ok-sign"></i> 3 Zabicia Nożem w rundzie</div></td>
			<td <?php if($row['badge_knife'] >= 4) echo 'class="active"';?> class = "right1"><div class="text-center"><i class="icon-ok-sign"></i> 200 Zabić Nożem<br /><i class="icon-ok-sign"></i> 3 Zabicia Nożem w rundzie</div></td>
		</tr>
	</tbody>
</table>

<table class="table table-bordered table-condensed table-striped">
	<caption><div class="alert"><strong>Odznaka za Walkę Pistoletami</strong></div></caption>
	<thead>
		<tr>
			<th><div class="text-center"><div <?php if($row['badge_pistol'] >= 1) echo 'class="active"'; else echo 'class="text"';?>>I Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_pistol'] >= 2) echo 'class="active"'; else echo 'class="text"';?>>II Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_pistol'] >= 3) echo 'class="active"'; else echo 'class="text"';?>>III Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_pistol'] >= 4) echo 'class="active"'; else echo 'class="text"';?>>IV Stopnia</div></div></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td <?php if($row['badge_pistol'] >= 1) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> +200$ co runde</div></td>
			<td <?php if($row['badge_pistol'] >= 2) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> +400$ co runde</div></td>
			<td <?php if($row['badge_pistol'] >= 3) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> +600$ co runde</div></td>
			<td <?php if($row['badge_pistol'] >= 4) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> +800$ co runde</div></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			<td <?php if($row['badge_pistol'] >= 1) echo 'class="active"';?> class = "left1"><div class="text-center"><i class="icon-ok-sign"></i> 50 Zabić Pistoletami<br /><i class="icon-ok-sign"></i> 2 Zabicie Pistoletami w rundzie</div></td>
			<td <?php if($row['badge_pistol'] >= 2) echo 'class="active"';?> class = "mid1"><div class="text-center"><i class="icon-ok-sign"></i> 100 Zabić Pistoletami<br /><i class="icon-ok-sign"></i> 3 Zabicia Pistoletami w rundzie</div></td>
			<td <?php if($row['badge_pistol'] >= 3) echo 'class="active"';?> class = "mid11"><div class="text-center"><i class="icon-ok-sign"></i> 200 Zabić Pistoletami<br /><i class="icon-ok-sign"></i> 4 Zabicia Pistoletami w rundzie</div></td>
			<td <?php if($row['badge_pistol'] >= 4) echo 'class="active"';?> class = "right1"><div class="text-center"><i class="icon-ok-sign"></i> 300 Zabić Pistoletami<br /><i class="icon-ok-sign"></i> 4 Zabicia Pistoletami w rundzie</div></td>
		</tr>
	</tbody>
</table>

<table class="table table-bordered table-condensed table-striped">
	<caption><div class="alert"><strong>Odznaka za Walkę Bronią Szturmową</strong></div></caption>
	<thead>
		<tr>
			<th><div class="text-center"><div <?php if($row['badge_rifle'] >= 1) echo 'class="active"'; else echo 'class="text"';?>>I Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_rifle'] >= 2) echo 'class="active"'; else echo 'class="text"';?>>II Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_rifle'] >= 3) echo 'class="active"'; else echo 'class="text"';?>>III Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_rifle'] >= 4) echo 'class="active"'; else echo 'class="text"';?>>IV Stopnia</div></div></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td <?php if($row['badge_rifle'] >= 1) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 110 HP na Start</div></td>
			<td <?php if($row['badge_rifle'] >= 2) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 120 HP na Start</div></td>
			<td <?php if($row['badge_rifle'] >= 3) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 130 HP na Start</div></td>
			<td <?php if($row['badge_rifle'] >= 4) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 140 HP na Start</div></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			<td <?php if($row['badge_rifle'] >= 1) echo 'class="active"';?> class = "left1"><div class="text-center"><i class="icon-ok-sign"></i> 1.000 Zabić<br /><i class="icon-ok-sign"></i> 3 Zabicie w rundzie</div></td>
			<td <?php if($row['badge_rifle'] >= 2) echo 'class="active"';?> class = "mid1"><div class="text-center"><i class="icon-ok-sign"></i> 2.000 Zabić<br /><i class="icon-ok-sign"></i> 4 Zabicia w rundzie</div></td>
			<td <?php if($row['badge_rifle'] >= 3) echo 'class="active"';?> class = "mid11"><div class="text-center"><i class="icon-ok-sign"></i> 3.000 Zabić<br /><i class="icon-ok-sign"></i> 5 Zabicia w rundzie</div></td>
			<td <?php if($row['badge_rifle'] >= 4) echo 'class="active"';?> class = "right1"><div class="text-center"><i class="icon-ok-sign"></i> 5.000 Zabić<br /><i class="icon-ok-sign"></i> 5 Zabicia w rundzie</div></td>
		</tr>
	</tbody>
</table>

<table class="table table-bordered table-condensed table-striped">
	<caption><div class="alert"><strong>Odznaka za Walkę Snajperkami</strong></div></caption>
	<thead>
		<tr>
			<th><div class="text-center"><div <?php if($row['badge_awp'] >= 1) echo 'class="active"'; else echo 'class="text"';?>>I Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_awp'] >= 2) echo 'class="active"'; else echo 'class="text"';?>>II Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_awp'] >= 3) echo 'class="active"'; else echo 'class="text"';?>>III Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_awp'] >= 4) echo 'class="active"'; else echo 'class="text"';?>>IV Stopnia</div></div></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td <?php if($row['badge_awp'] >= 1) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> +10% Obrażeń z AWP<br><i class="icon-gift"></i> 1/4 Szansy na darmową snajperkę</div></td>
			<td <?php if($row['badge_awp'] >= 2) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> +20% Obrażeń z AWP<br><i class="icon-gift"></i> 1/3 Szansy na darmową snajperkę</div></td>
			<td <?php if($row['badge_awp'] >= 3) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> +30% Obrażeń z AWP<br><i class="icon-gift"></i> 1/2 Szansy na darmową snajperkę</div></td>
			<td <?php if($row['badge_awp'] >= 4) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> +40% Obrażeń z AWP<br><i class="icon-gift"></i> 1/1 Szansy na darmową snajperkę</div></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			<td <?php if($row['badge_awp'] >= 1) echo 'class="active"';?> class = "left1"><div class="text-center"><i class="icon-ok-sign"></i> 50 Zabić Snajperkami<br /><i class="icon-ok-sign"></i> 2 Zabicie Snajperkami w rundzie</div></td>
			<td <?php if($row['badge_awp'] >= 2) echo 'class="active"';?> class = "mid1"><div class="text-center"><i class="icon-ok-sign"></i> 100 Zabić Snajperkami<br /><i class="icon-ok-sign"></i> 3 Zabicia Snajperkami w rundzie</div></td>
			<td <?php if($row['badge_awp'] >= 3) echo 'class="active"';?> class = "mid11"><div class="text-center"><i class="icon-ok-sign"></i> 200 Zabić Snajperkami<br /><i class="icon-ok-sign"></i> 4 Zabicia Snajperkami w rundzie</div></td>
			<td <?php if($row['badge_awp'] >= 4) echo 'class="active"';?> class = "right1"><div class="text-center"><i class="icon-ok-sign"></i> 300 Zabić Snajperkami<br /><i class="icon-ok-sign"></i> 4 Zabicia Snajperkami w rundzie</div></td>
		</tr>
	</tbody>
</table>

<table class="table table-bordered table-condensed table-striped">
	<caption><div class="alert"><strong>Odznaka za Walkę Bronią Wsparcja</strong></div></caption>
	<thead>
		<tr>
			<th><div class="text-center"><div <?php if($row['badge_mg'] >= 1) echo 'class="active"'; else echo 'class="text"';?>>I Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_mg'] >= 2) echo 'class="active"'; else echo 'class="text"';?>>II Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_mg'] >= 3) echo 'class="active"'; else echo 'class="text"';?>>III Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_mg'] >= 4) echo 'class="active"'; else echo 'class="text"';?>>IV Stopnia</div></div></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td <?php if($row['badge_mg'] >= 1) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 4% Więcej Obrażen</div></td>
			<td <?php if($row['badge_mg'] >= 2) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 8% Więcej Obrażen</div></td>
			<td <?php if($row['badge_mg'] >= 3) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 12% Więcej Obrażen</div></td>
			<td <?php if($row['badge_mg'] >= 4) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 16% Więcej Obrażen</div></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			<td <?php if($row['badge_mg'] >= 1) echo 'class="active"';?> class = "left1"><div class="text-center"><i class="icon-ok-sign"></i> 50 Zabić M249<br /><i class="icon-ok-sign"></i> 2 Zabicie M249 w rundzie</div></td>
			<td <?php if($row['badge_mg'] >= 2) echo 'class="active"';?> class = "mid1"><div class="text-center"><i class="icon-ok-sign"></i> 100 Zabić M249<br /><i class="icon-ok-sign"></i> 3 Zabicia M249 w rundzie</div></td>
			<td <?php if($row['badge_mg'] >= 3) echo 'class="active"';?> class = "mid11"><div class="text-center"><i class="icon-ok-sign"></i> 200 Zabić M249<br /><i class="icon-ok-sign"></i> 4 Zabicia M249 w rundzie</div></td>
			<td <?php if($row['badge_mg'] >= 4) echo 'class="active"';?> class = "right1"><div class="text-center"><i class="icon-ok-sign"></i> 300 Zabić M249<br /><i class="icon-ok-sign"></i> 4 Zabicia M249 w rundzie</div></td>
		</tr>
	</tbody>
</table>

<table class="table table-bordered table-condensed table-striped">
	<caption><div class="alert"><strong>Odznaka za Walkę Bronią Wybuchową</strong></div></caption>
	<thead>
		<tr>
			<th><div class="text-center"><div <?php if($row['badge_nade'] >= 1) echo 'class="active"'; else echo 'class="text"';?>>I Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_nade'] >= 2) echo 'class="active"'; else echo 'class="text"';?>>II Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_nade'] >= 3) echo 'class="active"'; else echo 'class="text"';?>>III Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_nade'] >= 4) echo 'class="active"'; else echo 'class="text"';?>>IV Stopnia</div></div></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td <?php if($row['badge_nade'] >= 1) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 10% Większa siła rzutu<br/><i class="icon-gift"></i> 1/4 Szansa na darmowe HE</div></td>
			<td <?php if($row['badge_nade'] >= 2) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 20% Większa siła rzutu<br/><i class="icon-gift"></i> 1/3 Szansa na darmowe HE</div></td>
			<td <?php if($row['badge_nade'] >= 3) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 30% Większa siła rzutu<br/><i class="icon-gift"></i> 1/2 Szansa na darmowe HE</div></td>
			<td <?php if($row['badge_nade'] >= 4) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 40% Większa siła rzutu<br/><i class="icon-gift"></i> 1/1 Szansa na darmowe HE</div></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			<td <?php if($row['badge_nade'] >= 1) echo 'class="active"';?> class = "left1"><div class="text-center"><i class="icon-ok-sign"></i> 50 Zabić Granatami</div></td>
			<td <?php if($row['badge_nade'] >= 2) echo 'class="active"';?> class = "mid1"><div class="text-center"><i class="icon-ok-sign"></i> 100 Zabić Granatami</div></td>
			<td <?php if($row['badge_nade'] >= 3) echo 'class="active"';?> class = "mid11"><div class="text-center"><i class="icon-ok-sign"></i> 150 Zabić Granatami</div></td>
			<td <?php if($row['badge_nade'] >= 4) echo 'class="active"';?> class = "right1"><div class="text-center"><i class="icon-ok-sign"></i> 200 Zabić Granatami</div></td>
		</tr>
	</tbody>
</table>

<table class="table table-bordered table-condensed table-striped">
	<caption><div class="alert"><strong>Odznaka za Walkę Strzelbą</strong></div></caption>
	<thead>
		<tr>
			<th><div class="text-center"><div <?php if($row['badge_shotgun'] >= 1) echo 'class="active"'; else echo 'class="text"';?>>I Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_shotgun'] >= 2) echo 'class="active"'; else echo 'class="text"';?>>II Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_shotgun'] >= 3) echo 'class="active"'; else echo 'class="text"';?>>III Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_shotgun'] >= 4) echo 'class="active"'; else echo 'class="text"';?>>IV Stopnia</div></div></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td <?php if($row['badge_shotgun'] >= 1) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> ~60% Widzialności</div></td>
			<td <?php if($row['badge_shotgun'] >= 2) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> ~45% Widzialności</div></td>
			<td <?php if($row['badge_shotgun'] >= 3) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> ~30% Widzialności</div></td>
			<td <?php if($row['badge_shotgun'] >= 4) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> ~15% Widzialności</div></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			<td <?php if($row['badge_shotgun'] >= 1) echo 'class="active"';?> class = "left1"><div class="text-center"><i class="icon-ok-sign"></i> 50 Zabić Strzelbż<br /><i class="icon-ok-sign"></i> 2 Zabicia Strzelbą w rundzie</div></td>
			<td <?php if($row['badge_shotgun'] >= 2) echo 'class="active"';?> class = "mid1"><div class="text-center"><i class="icon-ok-sign"></i> 100 Zabić Strzelbż<br /><i class="icon-ok-sign"></i> 3 Zabicia Strzelbą w rundzie</div></td>
			<td <?php if($row['badge_shotgun'] >= 3) echo 'class="active"';?> class = "mid11"><div class="text-center"><i class="icon-ok-sign"></i> 200 Zabić Strzelba<br /><i class="icon-ok-sign"></i> 4 Zabicia Strzelbą w rundzie</div></td>
			<td <?php if($row['badge_shotgun'] >= 4) echo 'class="active"';?> class = "right1"><div class="text-center"><i class="icon-ok-sign"></i> 300 Zabić Strzelbą<br /><i class="icon-ok-sign"></i> 4 Zabicia Strzelbą w rundzie</div></td>
		</tr>
	</tbody>
</table>

<table class="table table-bordered table-condensed table-striped">
	<caption><div class="alert"><strong>Odznaka za Walkę SMG</strong></div></caption>
	<thead>
		<tr>
			<th><div class="text-center"><div <?php if($row['badge_smg'] >= 1) echo 'class="active"'; else echo 'class="text"';?>>I Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_smg'] >= 2) echo 'class="active"'; else echo 'class="text"';?>>II Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_smg'] >= 3) echo 'class="active"'; else echo 'class="text"';?>>III Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_smg'] >= 4) echo 'class="active"'; else echo 'class="text"';?>>IV Stopnia</div></div></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td <?php if($row['badge_smg'] >= 1) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 5% Szybszy Bieg</div></td>
			<td <?php if($row['badge_smg'] >= 2) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 10% Szybszy Bieg</div></td>
			<td <?php if($row['badge_smg'] >= 3) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 15% Szybszy Bieg</div></td>
			<td <?php if($row['badge_smg'] >= 4) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 20% Szybszy Bieg</div></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			<td <?php if($row['badge_smg'] >= 1) echo 'class="active"';?> class = "left1"><div class="text-center"><i class="icon-ok-sign"></i> 50 Zabić SMG<br /><i class="icon-ok-sign"></i> 2 Zabicia SMG w rundzie</div></td>
			<td <?php if($row['badge_smg'] >= 2) echo 'class="active"';?> class = "mid1"><div class="text-center"><i class="icon-ok-sign"></i> 100 Zabić SMG<br /><i class="icon-ok-sign"></i> 3 Zabicia SMG w rundzie</div></td>
			<td <?php if($row['badge_smg'] >= 3) echo 'class="active"';?> class = "mid11"><div class="text-center"><i class="icon-ok-sign"></i> 200 ZabićSMG<br /><i class="icon-ok-sign"></i> 4 Zabicia SMG w rundzie</div></td>
			<td <?php if($row['badge_smg'] >= 4) echo 'class="active"';?> class = "right1"><div class="text-center"><i class="icon-ok-sign"></i> 300 Zabić SMG<br /><i class="icon-ok-sign"></i> 4 Zabicia SMG w rundzie</div></td>
		</tr>
	</tbody>
</table>

<table class="table table-bordered table-condensed table-striped">
	<caption><div class="alert"><strong>Odznaka za Walkę na KDR</strong></div></caption>
	<thead>
		<tr>
			<th><div class="text-center"><div <?php if($row['badge_kdr'] >= 1) echo 'class="active"'; else echo 'class="text"';?>>I Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_kdr'] >= 2) echo 'class="active"'; else echo 'class="text"';?>>II Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_kdr'] >= 3) echo 'class="active"'; else echo 'class="text"';?>>III Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_kdr'] >= 4) echo 'class="active"'; else echo 'class="text"';?>>IV Stopnia</div></div></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td <?php if($row['badge_kdr'] >= 1) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 8% Mniejsza Grawitacja na Nożu</div></td>
			<td <?php if($row['badge_kdr'] >= 2) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 16% Mniejsza Grawitacja na Nożu</div></td>
			<td <?php if($row['badge_kdr'] >= 3) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 24% Mniejsza Grawitacja na Nożu</div></td>
			<td <?php if($row['badge_kdr'] >= 4) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 32% Mniejsza Grawitacja na Nożu</div></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			<td <?php if($row['badge_kdr'] >= 1) echo 'class="active"';?> class = "left1"><div class="text-center"><i class="icon-ok-sign"></i> 24% Celności<br/><i class="icon-ok-sign"></i> 500 Zabic</div></td>
			<td <?php if($row['badge_kdr'] >= 2) echo 'class="active"';?> class = "mid1"><div class="text-center"><i class="icon-ok-sign"></i> 26% Celności<br/><i class="icon-ok-sign"></i> 1.000 Zabic</div></td>
			<td <?php if($row['badge_kdr'] >= 3) echo 'class="active"';?> class = "mid11"><div class="text-center"><i class="icon-ok-sign"></i> 28% Celności<br/><i class="icon-ok-sign"></i> 1.500 Zabic</div></td>
			<td <?php if($row['badge_kdr'] >= 4) echo 'class="active"';?> class = "right1"><div class="text-center"><i class="icon-ok-sign"></i> 30% Celności<br/><i class="icon-ok-sign"></i> 2.000 Zabic</div></td>
		</tr>
	</tbody>
</table>

<table class="table table-bordered table-condensed table-striped">
	<caption><div class="alert"><strong>Odznaka za Walkę Ogólną</strong></div></caption>
	<thead>
		<tr>
			<th><div class="text-center"><div <?php if($row['badge_global'] >= 1) echo 'class="active"'; else echo 'class="text"';?>>I Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_global'] >= 2) echo 'class="active"'; else echo 'class="text"';?>>II Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_global'] >= 3) echo 'class="active"'; else echo 'class="text"';?>>III Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_global'] >= 4) echo 'class="active"'; else echo 'class="text"';?>>IV Stopnia</div></div></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td <?php if($row['badge_global'] >= 1) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 1/4 na darmowe MP5 na Start</div></td>
			<td <?php if($row['badge_global'] >= 2) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 1/3 na darmowe MP5 na Start</div></td>
			<td <?php if($row['badge_global'] >= 3) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 1/2 na darmowe MP5 na Start</div></td>
			<td <?php if($row['badge_global'] >= 4) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 1/1 na darmowe MP5 na Start</div></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			<td <?php if($row['badge_global'] >= 1) echo 'class="active"';?> class = "left1"><div class="text-center"><i class="icon-ok-sign"></i> 500 Zabić</div></td>
			<td <?php if($row['badge_global'] >= 2) echo 'class="active"';?> class = "mid1"><div class="text-center"><i class="icon-ok-sign"></i> 1.000 Zabić</div></td>
			<td <?php if($row['badge_global'] >= 3) echo 'class="active"';?> class = "mid11"><div class="text-center"><i class="icon-ok-sign"></i> 1.500 Zabić</div></td>
			<td <?php if($row['badge_global'] >= 4) echo 'class="active"';?> class = "right1"><div class="text-center"><i class="icon-ok-sign"></i> 2.000 Zabić</div></td>
		</tr>
	</tbody>
</table>

<table class="table table-bordered table-condensed table-striped">
	<caption><div class="alert"><strong>Odznaka za Walkć Powstańca</strong></div></caption>
	<thead>
		<tr>
			<th><div class="text-center"><div <?php if($row['badge_insurgent'] >= 1) echo 'class="active"'; else echo 'class="text"';?>>I Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_insurgent'] >= 2) echo 'class="active"'; else echo 'class="text"';?>>II Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_insurgent'] >= 3) echo 'class="active"'; else echo 'class="text"';?>>III Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_insurgent'] >= 4) echo 'class="active"'; else echo 'class="text"';?>>IV Stopnia</div></div></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td <?php if($row['badge_insurgent'] >= 1) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 15 HP - Apteczka</div></td>
			<td <?php if($row['badge_insurgent'] >= 2) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 30 HP - Apteczka</div></td>
			<td <?php if($row['badge_insurgent'] >= 3) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 45 HP - Apteczka</div></td>
			<td <?php if($row['badge_insurgent'] >= 4) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 60 HP - Apteczka</div></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			<td <?php if($row['badge_insurgent'] >= 1) echo 'class="active"';?> class = "left1"><div class="text-center"><i class="icon-ok-sign"></i> 50.000 Otrzymanych obrażeń</div></td>
			<td <?php if($row['badge_insurgent'] >= 2) echo 'class="active"';?> class = "mid1"><div class="text-center"><i class="icon-ok-sign"></i> 100.000 Otrzymanych obrażeń</div></td>
			<td <?php if($row['badge_insurgent'] >= 3) echo 'class="active"';?> class = "mid11"><div class="text-center"><i class="icon-ok-sign"></i> 150.000 Otrzymanych obrażeń</div></td>
			<td <?php if($row['badge_insurgent'] >= 4) echo 'class="active"';?> class = "right1"><div class="text-center"><i class="icon-ok-sign"></i> 200.000 Otrzymanych obrażeń</div></td>
		</tr>
	</tbody>
</table>

<table class="table table-bordered table-condensed table-striped">
	<caption><div class="alert"><strong>Odznaka za Walkę Pirotechnika</strong></div></caption>
	<thead>
		<tr>
			<th><div class="text-center"><div <?php if($row['badge_pyrotechnic'] >= 1) echo 'class="active"'; else echo 'class="text"';?>>I Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_pyrotechnic'] >= 2) echo 'class="active"'; else echo 'class="text"';?>>II Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_pyrotechnic'] >= 3) echo 'class="active"'; else echo 'class="text"';?>>III Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_pyrotechnic'] >= 4) echo 'class="active"'; else echo 'class="text"';?>>IV Stopnia</div></div></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td <?php if($row['badge_pyrotechnic'] >= 1) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 20 HP - Mina</div></td>
			<td <?php if($row['badge_pyrotechnic'] >= 2) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 40 HP - Mina</div></td>
			<td <?php if($row['badge_pyrotechnic'] >= 3) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 60 HP - Mina</div></td>
			<td <?php if($row['badge_pyrotechnic'] >= 4) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 80 HP - Mina</div></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			<td <?php if($row['badge_pyrotechnic'] >= 1) echo 'class="active"';?> class = "left1"><div class="text-center"><i class="icon-ok-sign"></i> 100.000 Zadanych obrażeń</div></td>
			<td <?php if($row['badge_pyrotechnic'] >= 2) echo 'class="active"';?> class = "mid1"><div class="text-center"><i class="icon-ok-sign"></i> 200.000 Zadanych obrażeń</div></td>
			<td <?php if($row['badge_pyrotechnic'] >= 3) echo 'class="active"';?> class = "mid11"><div class="text-center"><i class="icon-ok-sign"></i> 300.000 Zadanych obrażeń</div></td>
			<td <?php if($row['badge_pyrotechnic'] >= 4) echo 'class="active"';?> class = "right1"><div class="text-center"><i class="icon-ok-sign"></i> 500.000 Zadanych obrażeń</div></td>
		</tr>
	</tbody>
</table>

<table class="table table-bordered table-condensed table-striped">
	<caption><div class="alert"><strong>Odznaka za Walkę na Medal</strong></div></caption>
	<thead>
		<tr>
			<th><div class="text-center"><div <?php if($row['badge_medal'] >= 1) echo 'class="active"'; else echo 'class="text"';?>>I Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_medal'] >= 2) echo 'class="active"'; else echo 'class="text"';?>>II Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_medal'] >= 3) echo 'class="active"'; else echo 'class="text"';?>>III Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_medal'] >= 4) echo 'class="active"'; else echo 'class="text"';?>>IV Stopnia</div></div></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td <?php if($row['badge_medal'] >= 1) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> O 4% Mniejsze Obrażenia</div></td>
			<td <?php if($row['badge_medal'] >= 2) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> O 8% Mniejsze Obrażenia</div></td>
			<td <?php if($row['badge_medal'] >= 3) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> O 12% Mniejsze Obrażenia</div></td>
			<td <?php if($row['badge_medal'] >= 4) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> O 16% Mniejsze Obrażenia</div></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			<td <?php if($row['badge_medal'] >= 1) echo 'class="active"';?> class = "left1"><div class="text-center"><i class="icon-ok-sign"></i> 40 Medali</div></td>
			<td <?php if($row['badge_medal'] >= 2) echo 'class="active"';?> class = "mid1"><div class="text-center"><i class="icon-ok-sign"></i> 80 Medali</div></td>
			<td <?php if($row['badge_medal'] >= 3) echo 'class="active"';?> class = "mid11"><div class="text-center"><i class="icon-ok-sign"></i> 120 Medali</div></td>
			<td <?php if($row['badge_medal'] >= 4) echo 'class="active"';?> class = "right1"><div class="text-center"><i class="icon-ok-sign"></i> 160 Medali</div></td>
		</tr>
	</tbody>
</table>

<table class="table table-bordered table-condensed table-striped">
	<caption><div class="alert"><strong>Odznaka za Walkę na Staż</strong></div></caption>
	<thead>
		<tr>
			<th><div class="text-center"><div <?php if($row['badge_internship'] >= 1) echo 'class="active"'; else echo 'class="text"';?>>I Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_internship'] >= 2) echo 'class="active"'; else echo 'class="text"';?>>II Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_internship'] >= 3) echo 'class="active"'; else echo 'class="text"';?>>III Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_internship'] >= 4) echo 'class="active"'; else echo 'class="text"';?>>IV Stopnia</div></div></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td <?php if($row['badge_internship'] >= 1) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 4% szansy na respawn </div></td>
			<td <?php if($row['badge_internship'] >= 2) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 8% szansy na respawn </div></td>
			<td <?php if($row['badge_internship'] >= 3) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 12% szansy na respawn </div></td>
			<td <?php if($row['badge_internship'] >= 4) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 16% szansy na respawn </div></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			<td <?php if($row['badge_internship'] >= 1) echo 'class="active"';?> class = "left1"><div class="text-center"><i class="icon-ok-sign"></i> 7.200 min Online</div></td>
			<td <?php if($row['badge_internship'] >= 2) echo 'class="active"';?> class = "mid1"><div class="text-center"><i class="icon-ok-sign"></i> 14.400 min Online</div></td>
			<td <?php if($row['badge_internship'] >= 3) echo 'class="active"';?> class = "mid11"><div class="text-center"><i class="icon-ok-sign"></i> 21.600 min Online</div></td>
			<td <?php if($row['badge_internship'] >= 4) echo 'class="active"';?> class = "right1"><div class="text-center"><i class="icon-ok-sign"></i> 28.800 min Online</div></td>
		</tr>
	</tbody>
</table>

<table class="table table-bordered table-condensed table-striped">
	<caption><div class="alert"><strong>Odznaka za Walkę na Osiągnięcia</strong></div></caption>
	<thead>
		<tr>
			<th><div class="text-center"><div <?php if($row['badge_achievements'] >= 1) echo 'class="active"'; else echo 'class="text"';?>>I Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_achievements'] >= 2) echo 'class="active"'; else echo 'class="text"';?>>II Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_achievements'] >= 3) echo 'class="active"'; else echo 'class="text"';?>>III Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_achievements'] >= 4) echo 'class="active"'; else echo 'class="text"';?>>IV Stopnia</div></div></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td <?php if($row['badge_achievements'] >= 1) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 1/4 na darmowe Deagle na Start</div></td>
			<td <?php if($row['badge_achievements'] >= 2) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 1/3 na darmowe Deagle na Start</div></td>
			<td <?php if($row['badge_achievements'] >= 3) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 1/2 na darmowe Deagle na Start</div></td>
			<td <?php if($row['badge_achievements'] >= 4) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 1/1 na darmowe Deagle na Start</div></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			<td <?php if($row['badge_achievements'] >= 1) echo 'class="active"';?> class = "left1"><div class="text-center"><i class="icon-ok-sign"></i> 5 Osiągnięć</div></td>
			<td <?php if($row['badge_achievements'] >= 2) echo 'class="active"';?> class = "mid1"><div class="text-center"><i class="icon-ok-sign"></i> 10 Osiągnięć</div></td>
			<td <?php if($row['badge_achievements'] >= 3) echo 'class="active"';?> class = "mid11"><div class="text-center"><i class="icon-ok-sign"></i> 15 Osiągnięć</div></td>
			<td <?php if($row['badge_achievements'] >= 4) echo 'class="active"';?> class = "right1"><div class="text-center"><i class="icon-ok-sign"></i> 18 Osiągnięć</div></td>
		</tr>
	</tbody>
</table>

<table class="table table-bordered table-condensed table-striped">
	<caption><div class="alert"><strong>Odznaka za Walkę na Odznaczenia</strong></div></caption>
	<thead>
		<tr>
			<th><div class="text-center"><div <?php if($row['badge_badges'] >= 1) echo 'class="active"'; else echo 'class="text"';?>>I Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_badges'] >= 2) echo 'class="active"'; else echo 'class="text"';?>>II Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_badges'] >= 3) echo 'class="active"'; else echo 'class="text"';?>>III Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_badges'] >= 4) echo 'class="active"'; else echo 'class="text"';?>>IV Stopnia</div></div></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td <?php if($row['badge_badges'] >= 1) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> Samobójca - 100u (150 DMG)</div></td>
			<td <?php if($row['badge_badges'] >= 2) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> Samobójca - 150u (150 DMG)</div></td>
			<td <?php if($row['badge_badges'] >= 3) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> Samobójca - 200u (150 DMG)</div></td>
			<td <?php if($row['badge_badges'] >= 4) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> Samobójca - 250u (150 DMG)</div></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			<td <?php if($row['badge_badges'] >= 1) echo 'class="active"';?> class = "left1"><div class="text-center"><i class="icon-ok-sign"></i> 15 Zdobytych odznak</div></td>
			<td <?php if($row['badge_badges'] >= 2) echo 'class="active"';?> class = "mid1"><div class="text-center"><i class="icon-ok-sign"></i> 30 Zdobytych odznak</div></td>
			<td <?php if($row['badge_badges'] >= 3) echo 'class="active"';?> class = "mid11"><div class="text-center"><i class="icon-ok-sign"></i> 45 Zdobytych odznak</div></td>
			<td <?php if($row['badge_badges'] >= 4) echo 'class="active"';?> class = "right1"><div class="text-center"><i class="icon-ok-sign"></i> 60 Zdobytych odznak</div></td>
		</tr>
	</tbody>
</table>

<table class="table table-bordered table-condensed table-striped">
	<caption><div class="alert"><strong>Odznaka za Walkę Minami</strong></div></caption>
	<thead>
		<tr>
			<th><div class="text-center"><div <?php if($row['badge_mine'] >= 1) echo 'class="active"'; else echo 'class="text"';?>>I Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_mine'] >= 2) echo 'class="active"'; else echo 'class="text"';?>>II Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_mine'] >= 3) echo 'class="active"'; else echo 'class="text"';?>>III Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_mine'] >= 4) echo 'class="active"'; else echo 'class="text"';?>>IV Stopnia</div></div></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td <?php if($row['badge_mine'] >= 1) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 35% widzialności podkładanej miny</div></td>
			<td <?php if($row['badge_mine'] >= 2) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 30% widzialności podkładanej miny</div></td>
			<td <?php if($row['badge_mine'] >= 3) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 25% widzialności podkładanej miny</div></td>
			<td <?php if($row['badge_mine'] >= 4) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 20% widzialności podkładanej miny</div></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			<td <?php if($row['badge_mine'] >= 1) echo 'class="active"';?> class = "left1"><div class="text-center"><i class="icon-ok-sign"></i> 50 Zabić Minami</div></td>
			<td <?php if($row['badge_mine'] >= 2) echo 'class="active"';?> class = "mid1"><div class="text-center"><i class="icon-ok-sign"></i> 100 Zabić Minami</div></td>
			<td <?php if($row['badge_mine'] >= 3) echo 'class="active"';?> class = "mid11"><div class="text-center"><i class="icon-ok-sign"></i> 150 Zabić Minami</div></td>
			<td <?php if($row['badge_mine'] >= 4) echo 'class="active"';?> class = "right1"><div class="text-center"><i class="icon-ok-sign"></i> 200 Zabić Minami</div></td>
		</tr>
	</tbody>
</table>

<table class="table table-bordered table-condensed table-striped">
	<caption><div class="alert"><strong>Odznaka za Walkę Uniwersalną</strong></div></caption>
	<thead>
		<tr>
			<th><div class="text-center"><div <?php if($row['badge_universal'] >= 1) echo 'class="active"'; else echo 'class="text"';?>>I Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_universal'] >= 2) echo 'class="active"'; else echo 'class="text"';?>>II Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_universal'] >= 3) echo 'class="active"'; else echo 'class="text"';?>>III Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_universal'] >= 4) echo 'class="active"'; else echo 'class="text"';?>>IV Stopnia</div></div></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td <?php if($row['badge_universal'] >= 1) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> Dostajesz +5HP</div></td>
			<td <?php if($row['badge_universal'] >= 2) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> Darmowe fleshe</div></td>
			<td <?php if($row['badge_universal'] >= 3) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> Ciche chodzenie</div></td>
			<td <?php if($row['badge_universal'] >= 4) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> Podskok w powietrzu (nóż)</div></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			<td <?php if($row['badge_universal'] >= 1) echo 'class="active"';?> class = "left1"><div class="text-center"><i class="icon-ok-sign"></i> 1.250 Zabić<br><i class="icon-ok-sign"></i> 4 Osiągnięć<br><i class="icon-ok-sign"></i> 15 Odznak</div></td>
			<td <?php if($row['badge_universal'] >= 2) echo 'class="active"';?> class = "mid1"><div class="text-center"><i class="icon-ok-sign"></i> 2.500 Zabić<br><i class="icon-ok-sign"></i> 8 Osiągnięć<br><i class="icon-ok-sign"></i> 30 Odznak</div></td>
			<td <?php if($row['badge_universal'] >= 3) echo 'class="active"';?> class = "mid11"><div class="text-center"><i class="icon-ok-sign"></i> 3.750 Zabić<br><i class="icon-ok-sign"></i> 12 Osiągnięć<br><i class="icon-ok-sign"></i> 45 Odznak</div></td>
			<td <?php if($row['badge_universal'] >= 4) echo 'class="active"';?> class = "right1"><div class="text-center"><i class="icon-ok-sign"></i> 5.000 Zabić<br><i class="icon-ok-sign"></i> 16 Osiągnięć<br><i class="icon-ok-sign"></i> 60 Odznak</div></td>
		</tr>
	</tbody>
</table>

<table class="table table-bordered table-condensed table-striped">
	<caption><div class="alert"><strong>Odznaka za Walkę Mieszaną</strong></div></caption>
	<thead>
		<tr>
			<th><div class="text-center"><div <?php if($row['badge_mixed'] >= 1) echo 'class="active"'; else echo 'class="text"';?>>I Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_mixed'] >= 2) echo 'class="active"'; else echo 'class="text"';?>>II Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_mixed'] >= 3) echo 'class="active"'; else echo 'class="text"';?>>III Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_mixed'] >= 4) echo 'class="active"'; else echo 'class="text"';?>>IV Stopnia</div></div></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td <?php if($row['badge_mixed'] >= 1) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 1/4 Szansy na wypadnięcie paczki z zabitego</div></td>
			<td <?php if($row['badge_mixed'] >= 2) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 1/3 Szansy na wypadnięcie paczki z zabitego</div></td>
			<td <?php if($row['badge_mixed'] >= 3) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 1/2 Szansy na wypadnięcie paczki z zabitego</div></td>
			<td <?php if($row['badge_mixed'] >= 4) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 1/1 Szansy na wypadnięcie paczki z zabitego</div></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			<td <?php if($row['badge_mixed'] >= 1) echo 'class="active"';?> class = "left1"><div class="text-center"><i class="icon-ok-sign"></i> 1.000 Zabić<br><i class="icon-ok-sign"></i> 1 Zabicie M249<br><i class="icon-ok-sign"></i> 1 Zabicie SMG<br><i class="icon-ok-sign"></i> 1 Zabicie Strzelbą<br><i class="icon-ok-sign"></i> 1 Zabicie Nożem</div></td>
			<td <?php if($row['badge_mixed'] >= 2) echo 'class="active"';?> class = "mid1"><div class="text-center"><i class="icon-ok-sign"></i> 2.000 Zabić<br><i class="icon-ok-sign"></i> 1 Zabicie M249<br><i class="icon-ok-sign"></i> 1 Zabicie SMG<br><i class="icon-ok-sign"></i> 1 Zabicie Strzelbą<br><i class="icon-ok-sign"></i> 1 Zabicie Nożem</div></td>
			<td <?php if($row['badge_mixed'] >= 3) echo 'class="active"';?> class = "mid11"><div class="text-center"><i class="icon-ok-sign"></i> 3.000 Zabić<br><i class="icon-ok-sign"></i> 1 Zabicie M249<br><i class="icon-ok-sign"></i> 1 Zabicie SMG<br><i class="icon-ok-sign"></i> 1 Zabicie Strzelbą<br><i class="icon-ok-sign"></i> 1 Zabicie Nożem</div></td>
			<td <?php if($row['badge_mixed'] >= 4) echo 'class="active"';?> class = "right1"><div class="text-center"><i class="icon-ok-sign"></i> 4.000 Zabić<br><i class="icon-ok-sign"></i> 1 Zabicie M249<br><i class="icon-ok-sign"></i> 1 Zabicie SMG<br><i class="icon-ok-sign"></i> 1 Zabicie Strzelbą<br><i class="icon-ok-sign"></i> 1 Zabicie Nożem</div></td>
		</tr>
	</tbody>
</table>

<table class="table table-bordered table-condensed table-striped">
	<caption><div class="alert"><strong>Odznaka za Walkę na Czas</strong></div></caption>
	<thead>
		<tr>
			<th><div class="text-center"><div <?php if($row['badge_time'] >= 1) echo 'class="active"'; else echo 'class="text"';?>>I Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_time'] >= 2) echo 'class="active"'; else echo 'class="text"';?>>II Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_time'] >= 3) echo 'class="active"'; else echo 'class="text"';?>>III Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_time'] >= 4) echo 'class="active"'; else echo 'class="text"';?>>IV Stopnia</div></div></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td <?php if($row['badge_time'] >= 1) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> Podświetlasz miny w odlegśosci 100u</div></td>
			<td <?php if($row['badge_time'] >= 2) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> Podświetlasz miny w odlegśosci 125u</div></td>
			<td <?php if($row['badge_time'] >= 3) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> Podświetlasz miny w odlegśosci 150u</div></td>
			<td <?php if($row['badge_time'] >= 4) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> Podświetlasz miny w odlegśosci 175u</div></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			<td <?php if($row['badge_time'] >= 1) echo 'class="active"';?> class = "left1"><div class="text-center"><i class="icon-ok-sign"></i> 2.500 Zabić<br><i class="icon-ok-sign"></i> 2.500 min Online</td>
			<td <?php if($row['badge_time'] >= 2) echo 'class="active"';?> class = "mid1"><div class="text-center"><i class="icon-ok-sign"></i> 5.000 Zabić<br><i class="icon-ok-sign"></i> 5.000 min Online</td>
			<td <?php if($row['badge_time'] >= 3) echo 'class="active"';?> class = "mid11"><div class="text-center"><i class="icon-ok-sign"></i> 7.500 Zabić<br><i class="icon-ok-sign"></i> 7.500 min Online</td>
			<td <?php if($row['badge_time'] >= 4) echo 'class="active"';?> class = "right1"><div class="text-center"><i class="icon-ok-sign"></i> 10.000 Zabić<br><i class="icon-ok-sign"></i> 10.000 min Online</td>
		</tr>
	</tbody>
</table>

<table class="table table-bordered table-condensed table-striped">
	<caption><div class="alert"><strong>Odznaka za Walkę na Zbieranie</strong></div></caption>
	<thead>
		<tr>
			<th><div class="text-center"><div <?php if($row['badge_healing'] >= 1) echo 'class="active"'; else echo 'class="text"';?>>I Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_healing'] >= 2) echo 'class="active"'; else echo 'class="text"';?>>II Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_healing'] >= 3) echo 'class="active"'; else echo 'class="text"';?>>III Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_healing'] >= 4) echo 'class="active"'; else echo 'class="text"';?>>IV Stopnia</div></div></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td <?php if($row['badge_healing'] >= 1) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> Leczenie członków z drużyny [10 HP](nóż + E)</div></td>
			<td <?php if($row['badge_healing'] >= 2) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> Leczenie członków z drużyny [20 HP](nóż + E)</div></td>
			<td <?php if($row['badge_healing'] >= 3) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> Leczenie członków z drużyny [30 HP](nóż + E)</div></td>
			<td <?php if($row['badge_healing'] >= 4) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> Leczenie członków z drużyny [40 HP](nóż + E)</div></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			<td <?php if($row['badge_healing'] >= 1) echo 'class="active"';?> class = "left1"><div class="text-center"><i class="icon-ok-sign"></i> 250 Podniesionych paczek</td>
			<td <?php if($row['badge_healing'] >= 2) echo 'class="active"';?> class = "mid1"><div class="text-center"><i class="icon-ok-sign"></i> 500 Podniesionych paczek</td>
			<td <?php if($row['badge_healing'] >= 3) echo 'class="active"';?> class = "mid11"><div class="text-center"><i class="icon-ok-sign"></i> 750 Podniesionych paczek</td>
			<td <?php if($row['badge_healing'] >= 4) echo 'class="active"';?> class = "right1"><div class="text-center"><i class="icon-ok-sign"></i> 1.000 Podniesionych paczek</td>
		</tr>
	</tbody>
</table>

<table class="table table-bordered table-condensed table-striped">
	<caption><div class="alert"><strong>Odznaka za Walkę na Spowolnienie</strong></div></caption>
	<thead>
		<tr>
			<th><div class="text-center"><div <?php if($row['badge_slowmo'] >= 1) echo 'class="active"'; else echo 'class="text"';?>>I Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_slowmo'] >= 2) echo 'class="active"'; else echo 'class="text"';?>>II Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_slowmo'] >= 3) echo 'class="active"'; else echo 'class="text"';?>>III Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_slowmo'] >= 4) echo 'class="active"'; else echo 'class="text"';?>>IV Stopnia</div></div></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td <?php if($row['badge_slowmo'] >= 1) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 17% Szansy na spowolnienie przeciwnika (SMG)</div></td>
			<td <?php if($row['badge_slowmo'] >= 2) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 20% Szansy na spowolnienie przeciwnika (SMG)</div></td>
			<td <?php if($row['badge_slowmo'] >= 3) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 25% Szansy na spowolnienie przeciwnika (SMG)</div></td>
			<td <?php if($row['badge_slowmo'] >= 4) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 33% Szansy na spowolnienie przeciwnika (SMG)</div></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			<td <?php if($row['badge_slowmo'] >= 1) echo 'class="active"';?> class = "left1"><div class="text-center"><i class="icon-ok-sign"></i> Walka SMG - I Poziom<br><i class="icon-ok-sign"></i> 150 Zabić SMG<br><i class="icon-ok-sign"></i> 1 Zabicie z SMG w rundzie</td>
			<td <?php if($row['badge_slowmo'] >= 2) echo 'class="active"';?> class = "mid1"><div class="text-center"><i class="icon-ok-sign"></i> Walka SMG - II Poziom<br><i class="icon-ok-sign"></i> 300 Zabić SMG<br><i class="icon-ok-sign"></i> 2 Zabicia z SMG w rundzie</td>
			<td <?php if($row['badge_slowmo'] >= 3) echo 'class="active"';?> class = "mid11"><div class="text-center"><i class="icon-ok-sign"></i> Walka SMG - III Poziom<br><i class="icon-ok-sign"></i> 450 Zabić SMG<br><i class="icon-ok-sign"></i> 2 Zabicia z SMG w rundzie</td>
			<td <?php if($row['badge_slowmo'] >= 4) echo 'class="active"';?> class = "right1"><div class="text-center"><i class="icon-ok-sign"></i> Walka SMG - IV Poziom<br><i class="icon-ok-sign"></i> 600 Zabić SMG<br><i class="icon-ok-sign"></i> 3 Zabicia z SMG w rundzie</td>
		</tr>
	</tbody>
</table>

<table class="table table-bordered table-condensed table-striped">
	<caption><div class="alert"><strong>Odznaka za Walkę na Podświetlenie</strong></div></caption>
	<thead>
		<tr>
			<th><div class="text-center"><div <?php if($row['badge_highlight'] >= 1) echo 'class="active"'; else echo 'class="text"';?>>I Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_highlight'] >= 2) echo 'class="active"'; else echo 'class="text"';?>>II Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_highlight'] >= 3) echo 'class="active"'; else echo 'class="text"';?>>III Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_highlight'] >= 4) echo 'class="active"'; else echo 'class="text"';?>>IV Stopnia</div></div></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td <?php if($row['badge_highlight'] >= 1) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 17% Szansy na podświetlenie niewidzialnego przeciwnika (strzelby)</div></td>
			<td <?php if($row['badge_highlight'] >= 2) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 20% Szansy na podświetlenie niewidzialnego przeciwnika (strzelby)</div></td>
			<td <?php if($row['badge_highlight'] >= 3) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 25% Szansy na podświetlenie niewidzialnego przeciwnika (strzelby)</div></td>
			<td <?php if($row['badge_highlight'] >= 4) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 33% Szansy na podświetlenie niewidzialnego przeciwnika (strzelby)</div></td>	
		</tr>
	</tbody>
	<tbody>
		<tr>
			<td <?php if($row['badge_highlight'] >= 1) echo 'class="active"';?> class = "left1"><div class="text-center"><i class="icon-ok-sign"></i> Walka Strzelba - I Poziom<br><i class="icon-ok-sign"></i> 150 Zabić Strzelbą<br><i class="icon-ok-sign"></i> 1 Zabicie Strzelbą w rundzie</td>
			<td <?php if($row['badge_highlight'] >= 2) echo 'class="active"';?> class = "mid1"><div class="text-center"><i class="icon-ok-sign"></i> Walka Strzelba - II Poziom<br><i class="icon-ok-sign"></i> 300 Zabić Strzelbą<br><i class="icon-ok-sign"></i> 2 Zabicia Strzelbą w rundzie</td>
			<td <?php if($row['badge_highlight'] >= 3) echo 'class="active"';?> class = "mid11"><div class="text-center"><i class="icon-ok-sign"></i> Walka Strzelba - III Poziom<br><i class="icon-ok-sign"></i> 450 Zabić Strzelbą<br><i class="icon-ok-sign"></i> 2 Zabicia Strzelbą w rundzie</td>
			<td <?php if($row['badge_highlight'] >= 4) echo 'class="active"';?> class = "right1"><div class="text-center"><i class="icon-ok-sign"></i> Walka Strzelba - IV Poziom<br><i class="icon-ok-sign"></i> 600 Zabić Strzelbą<br><i class="icon-ok-sign"></i> 3 Zabicia Strzelbą w rundzie</td>
		</tr>
	</tbody>
</table>

<table class="table table-bordered table-condensed table-striped">
	<caption><div class="alert"><strong>Odznaka za Walkę na Zgony</strong></div></caption>
	<thead>
		<tr>
			<th><div class="text-center"><div <?php if($row['badge_deaths'] >= 1) echo 'class="active"'; else echo 'class="text"';?>>I Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_deaths'] >= 2) echo 'class="active"'; else echo 'class="text"';?>>II Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_deaths'] >= 3) echo 'class="active"'; else echo 'class="text"';?>>III Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_deaths'] >= 4) echo 'class="active"'; else echo 'class="text"';?>>IV Stopnia</div></div></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td <?php if($row['badge_deaths'] >= 1) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 17% Szansy na otrzymanie helmu (odbija 1 pocisk)</div></td>
			<td <?php if($row['badge_deaths'] >= 2) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 20% Szansy na otrzymanie helmu (odbija 1 pocisk)</div></td>
			<td <?php if($row['badge_deaths'] >= 3) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 25% Szansy na otrzymanie helmu (odbija 1 pocisk)</div></td>
			<td <?php if($row['badge_deaths'] >= 4) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 33% Szansy na otrzymanie helmu (odbija 1 pocisk)</div></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			<td <?php if($row['badge_deaths'] >= 1) echo 'class="active"';?> class = "left1"><div class="text-center"><i class="icon-ok-sign"></i> 250 Zgonów</td>
			<td <?php if($row['badge_deaths'] >= 2) echo 'class="active"';?> class = "mid1"><div class="text-center"><i class="icon-ok-sign"></i> 500 Zgonów</td>
			<td <?php if($row['badge_deaths'] >= 3) echo 'class="active"';?> class = "mid11"><div class="text-center"><i class="icon-ok-sign"></i> 750 Zgonów</td>
			<td <?php if($row['badge_deaths'] >= 4) echo 'class="active"';?> class = "right1"><div class="text-center"><i class="icon-ok-sign"></i> 1.000 Zgonów</td>
		</tr>
	</tbody>
</table>

<table class="table table-bordered table-condensed table-striped">
	<caption><div class="alert"><strong>Odznaka za Walkę na Połączenia</strong></div></caption>
	<thead>
		<tr>
			<th><div class="text-center"><div <?php if($row['badge_connections'] >= 1) echo 'class="active"'; else echo 'class="text"';?>>I Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_connections'] >= 2) echo 'class="active"'; else echo 'class="text"';?>>II Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_connections'] >= 3) echo 'class="active"'; else echo 'class="text"';?>>III Stopnia</div></div></th>
			<th><div class="text-center"><div <?php if($row['badge_connections'] >= 4) echo 'class="active"'; else echo 'class="text"';?>>IV Stopnia</div></div></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td <?php if($row['badge_connections'] >= 1) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 17% Szansy na otrzymanie ubrania wroga</div></td>
			<td <?php if($row['badge_connections'] >= 2) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 20% Szansy na otrzymanie ubrania wroga</div></td>
			<td <?php if($row['badge_connections'] >= 3) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 25% Szansy na otrzymanie ubrania wroga</div></td>
			<td <?php if($row['badge_connections'] >= 4) echo 'class="active"';?>><div class="text-center"><i class="icon-gift"></i> 33% Szansy na otrzymanie ubrania wroga</div></td>
		</tr>
	</tbody>
	<tbody>
		<tr>
			<td <?php if($row['badge_connections'] >= 1) echo 'class="active"';?> class = "left1"><div class="text-center"><i class="icon-ok-sign"></i> 75 Połączeń z serwerem</td>
			<td <?php if($row['badge_connections'] >= 2) echo 'class="active"';?> class = "mid1"><div class="text-center"><i class="icon-ok-sign"></i> 150 Połączeń z serwerem</td>
			<td <?php if($row['badge_connections'] >= 3) echo 'class="active"';?> class = "mid11"><div class="text-center"><i class="icon-ok-sign"></i> 225 Połączeń z serwerem</td>
			<td <?php if($row['badge_connections'] >= 4) echo 'class="active"';?> class = "right1"><div class="text-center"><i class="icon-ok-sign"></i> 300 Połączeń z serwerem</td>
		</tr>
	</tbody>
</table></center>
</body>
</html>