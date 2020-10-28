<?php 
	include 'database.php';
	if($_GET['auth_id'])
	{
		$statement = $dbh->prepare("SELECT name, achievement_nade, achievement_kdr, achievement_deaths, achievement_kills, achievement_bombs, achievement_diamonds, achievement_money, achievement_mktd, achievement_minekills, achievement_minedeaths, achievement_packages, achievement_time, achievement_medals, achievement_awp, achievement_heads, achievement_dmg, achievement_badges, achievement_invisiblity, achievement_rounds, achievement_connections FROM bf4_players WHERE auth_data = '".$_GET['auth_id']."'"); 
		$statement->execute();
		$row = $statement->fetch();
	}
?>

<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="UTF-8" />
	<title>Osiągnięcia i Wymagania</title>
	<link href="#" rel="shortcut icon">
	<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
	<style type="text/css">
		html {
			font-size: 100%;
			-webkit-text-size-adjust: 100%;
			-ms-text-size-adjust: 100%;
		}
		body {
			font-size: 12px;
			line-height: 20px;
			color: #000000;
			font-family: 'Rajdhani', sans-serif;
			width: 90%;
			background: #080e1b url(tlo.png) no-repeat scroll center top;
			margin: 0 auto;
			background-attachment: fixed;
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
		.text {
			color: #000;
			text-align: center;
		}
		table {
			max-width: 100%;
			background-color: #fff;
			border-collapse: collapse;
			border-spacing: 0;
		}
		.table {
			width: 100%;
			margin-bottom: 20px;
		}
		.table th, .table td {
			padding: 8px;
			line-height: 20px;
			text-align: left;
			vertical-align: top;
			border-top: 1px solid #000000;
		}
		th.kreska1 {
			background-color: #8E2323;
			border-top-left-radius: 8.6px;
		}
		th.kreska2 {
			border-right: 1px solid #000000;
			background-color: #8E2323;
		}
		th.kreska3 {
			background-color: #8E2323;
		}
		th.kreska4 {
			background-color: #8E2323;
			border-top-right-radius: 8.6px;
		}
		th.medal1 {
			border-right: 1px solid #000000;
			background-color: #8E2323;
			border-top-left-radius: 8.5px;
		}
		th.medal2 {
			border-right: 1px solid #000000;
			background-color: #8E2323;
		}
		th.medal3 {
			border-right: 0;
			background-color: #8E2323;
			border-top-right-radius: 8.5px;
		}
		td.medale1 {
			border-bottom-left-radius: 10px;
		}
		td.medale2 {
			border-radius: 0;
		}
		td.medale3 {
			border-bottom-right-radius: 10px;
		}
		td.kreska2 {
			border-right: 1px solid #000000;
		}
		.table caption+thead tr:first-child th {
			border-top: 0;
		}
		.table-condensed th, .table-condensed td {
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
		.table-striped tbody>tr:nth-child(odd)>td, .table-striped tbody>tr:nth-child(odd)>th {
			background-color: #f9f9f9;
		}
		.text-center {
			color: white;
		}
		.alert {
			padding: 8px 35px 8px 35px;
			margin-bottom: 20px;
			text-shadow: 0 1px 0 rgba(255, 255, 255, 0.5);
			background-color: #8E2323;
			width: 20%;
			border: 1px solid #fbeed5 -webkit-border-radius: 10px;
			-moz-border-radius: 10px;
			border-radius: 10px;
		}
		.alert, .alert strong {
			color: white;
		}
		.alert strong {
			margin: 0;
		}
		.active {
			font-weight: bold;
			color: #E47833;
			text-shadow: 0 0 6px #000;
			background: rgba(142, 35, 35, 1);
			background: -moz-linear-gradient(top, rgba(142, 35, 35, 1) 0%, rgba(142, 35, 35, 0.84) 30%, rgba(142, 35, 35, 0.84) 44%, rgba(142, 35, 35, 0.70) 100%);
			background: -webkit-gradient(left top, left bottom, color-stop(0%, rgba(142, 35, 35, 1)), color-stop(30%, rgba(142, 35, 35, 0.84)), color-stop(44%, rgba(142, 35, 35, 0.84)), color-stop(100%, rgba(142, 35, 35, 0.70)));
			background: -webkit-linear-gradient(top, rgba(142, 35, 35, 1) 0%, rgba(142, 35, 35, 0.84) 30%, rgba(142, 35, 35, 0.84) 44%, rgba(142, 35, 75, 0.60) 100%);
			background: -o-linear-gradient(top, rgba(142, 35, 35, 1) 0%, rgba(142, 35, 35, 0.84) 30%, rgba(142, 35, 35, 0.84) 44%, rgba(142, 35, 35, 0.70) 100%);
			background: -ms-linear-gradient(top, rgba(142, 35, 35, 1) 0%, rgba(142, 35, 35, 0.84) 30%, rgba(142, 35, 35, 0.84) 44%, rgba(142, 35, 35, 0.70) 100%);
			background: linear-gradient(to bottom, rgba(142, 35, 35, 1) 0%, rgba(142, 35, 35, 0.84) 30%, rgba(142, 35, 35, 0.84) 44%, rgba(142, 35, 35, 0.70) 100%);
			filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#8e2323', endColorstr='#8e2323', GradientType=0);
		}
	</style>
</head>
<body background="tlo.png">
	<br>
	<p></p>
	<center>
		<img height="150" src="logo.png">
	</center>
	<p></p><br>
	<div style="width:100%;">
		<center>
			<table class="table table-bordered table-condensed table-striped">
				<caption>
					<div class="alert">
						<strong>Osiągnięcia <?php if($_GET['auth_id']) echo 'gracza '.$row['name'].'';?></strong>
					</div>
				</caption>
				<thead>
					<tr>
						<th class="kreska1" style="width: 70px;">
							<div class="text-center"></div>
						</th>
						<th class="kreska2">
							<div class="text-center">
								Wymagania
							</div>
						</th>
						<th class="kreska3" style="width: 70px;">
							<div class="text-center"></div>
						</th>
						<th class="kreska4">
							<div class="text-center">
								Wymagania
							</div>
						</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td <?php if($row['achievement_nade']) echo 'class="active"';?>>
							<div class="text-center"><img src="1.png"></div>
						</td>
						<td <?php if($row['achievement_nade']) echo 'class="active"';?>>
							<div class="text-left">
								<b><u>Gorąca Sprawa</u></b><br>
								<b>Wymagania:</b><br>
								&#187; 250 Zabić granatem<br>
							</div>
						</td>
						<td <?php if($row['achievement_time']) echo 'class="active"';?>>
							<div class="text-center"><img src="2.png"></div>
						</td>
						<td <?php if($row['achievement_time']) echo 'class="active"';?>>
							<div class="text-left">
								<b><u>Wielki Gong</u></b><br>
								<b>Wymagania:</b><br>
								&#187; 15.000 min Online<br>
							</div>
						</td>
					</tr>
					<tr>
						<td <?php if($row['achievement_kdr']) echo 'class="active"';?>>
							<div class="text-center"><img src="4.jpg"></div>
						</td>
						<td <?php if($row['achievement_kdr']) echo 'class="active"';?>>
							<div class="text-left">
								<b><u>Polowanie</u></b><br>
								<b>Wymagania:</b><br>
								&#187; KDR 3.0<br>
							</div>
						</td>
						<td <?php if($row['achievement_medals']) echo 'class="active"';?>>
							<div class="text-center"><img src="5.png"></div>
						</td>
						<td <?php if($row['achievement_medals']) echo 'class="active"';?>>
							<div class="text-left">
								<b><u>Wzorowa Slużba</u></b><br>
								<b>Wymagania:</b><br>
								&#187; 100 Medali<br>
							</div>
						</td>
					</tr>
					<tr>
						<td <?php if($row['achievement_deaths']) echo 'class="active"';?>>
							<div class="text-center"><img src="7.png"></div>
						</td>
						<td <?php if($row['achievement_deaths']) echo 'class="active"';?>>
							<div class="text-left">
								<b><u>Najwyższa Ofiara</u></b><br>
								<b>Wymagania:</b><br>
								&#187; 2.500 Zginięć<br>
							</div>
						</td>
						<td <?php if($row['achievement_awp']) echo 'class="active"';?>>
							<div class="text-center"><img src="8.jpg"></div>
						</td>
						<td <?php if($row['achievement_awp']) echo 'class="active"';?>>
							<div class="text-left">
								<b><u>Cicha Przemoc</u></b><br>
								<b>Wymagania:</b><br>
								&#187; 500 Zabić ze snajperki<br>
							</div>
						</td>
					</tr>
					<tr>
						<td <?php if($row['achievement_kills']) echo 'class="active"';?>>
							<div class="text-center"><img src="3.jpg"></div>
						</td>
						<td <?php if($row['achievement_kills']) echo 'class="active"';?>>
							<div class="text-left">
								<b><u>Szybki i Zabójczy</u></b><br>
								<b>Wymagania:</b><br>
								&#187; 10.000 Zabójstw<br>
							</div>
						</td>
						<td <?php if($row['achievement_heads']) echo 'class="active"';?>>
							<div class="text-center"><img src="6.png"></div>
						</td>
						<td <?php if($row['achievement_heads']) echo 'class="active"';?>>
							<div class="text-left">
								<b><u>Celne Strzaly</u></b><br>
								<b>Wymagania:</b><br>
								&#187; 50.000 Headshotów<br>
							</div>
						</td>
					</tr>
					<tr>
						<td <?php if($row['achievement_bombs']) echo 'class="active"';?>>
							<div class="text-center"><img src="10.jpeg"></div>
						</td>
						<td <?php if($row['achievement_bombs']) echo 'class="active"';?>>
							<div class="text-left">
								<b><u>Aż do Klikniecia</u></b><br>
								<b>Wymagania:</b><br>
								&#187; 50 Wybuchnietych bomb<br>
							</div>
						</td>
						<td <?php if($row['achievement_dmg']) echo 'class="active"';?>>
							<div class="text-center"><img src="9.png"></div>
						</td>
						<td <?php if($row['achievement_dmg']) echo 'class="active"';?>>
							<div class="text-left">
								<b><u>Chodzacy Magazynier</u></b><br>
								<b>Wymagania:</b><br>
								&#187; 75.000 Zadanych obrażeń<br>
							</div>
						</td>
					</tr>
					<tr>
						<td <?php if($row['achievement_diamonds']) echo 'class="active"';?>>
							<div class="text-center"><img src="11.png"></div>
						</td>
						<td <?php if($row['achievement_diamonds']) echo 'class="active"';?>>
							<div class="text-left">
								<b><u>Łowca Okazji</u></b><br>
								<b>Wymagania:</b><br>
								&#187; 6 Diamentów<br>
							</div>
						</td>
						<td <?php if($row['achievement_badges']) echo 'class="active"';?>>
							<div class="text-center"><img src="12.png"></div>
						</td>
						<td <?php if($row['achievement_badges']) echo 'class="active"';?>>
							<div class="text-left">
								<b><u>Prawdziwe Wyzwanie</u></b><br>
								<b>Wymagania:</b><br>
								&#187; 45 Zdobyte odznaki<br>
							</div>
						</td>
					</tr>
					<tr>
						<td <?php if($row['achievement_money']) echo 'class="active"';?>>
							<div class="text-center"><img src="13.jpg"></div>
						</td>
						<td <?php if($row['achievement_money']) echo 'class="active"';?>>
							<div class="text-left">
								<b><u>Milioner</u></b><br>
								<b>Wymagania:</b><br>
								&#187; Zbierz 1.000.000$<br>
							</div>
						</td>
						<td <?php if($row['achievement_invisiblity']) echo 'class="active"';?>>
							<div class="text-center"><img src="14.jpg"></div>
						</td>
						<td <?php if($row['achievement_invisiblity']) echo 'class="active"';?>>
							<div class="text-left">
								<b><u>Incognito</u></b><br>
								<b>Wymagania:</b><br>
								&#187; Zdobycie niewidzialności<br>
							</div>
						</td>
					</tr>
					<tr>
						<td <?php if($row['achievement_mktd']) echo 'class="active"';?>>
							<div class="text-center"><img src="15.jpg"></div>
						</td>
						<td <?php if($row['achievement_mktd']) echo 'class="active"';?>>
							<div class="text-left">
								<b><u>Królewska gra</u></b><br>
								<b>Wymagania:</b><br>
								&#187; 10.000 Więcej zabić niż zginięć<br>
							</div>
						</td>
						<td <?php if($row['achievement_rounds']) echo 'class="active"';?>>
							<div class="text-center"><img src="16.jpg"></div>
						</td>
						<td <?php if($row['achievement_rounds']) echo 'class="active"';?>>
							<div class="text-left">
								<b><u>Niezniszczalny</u></b><br>
								<b>Wymagania:</b><br>
								&#187; 2.500 Przetrwanych rund<br>
							</div>
						</td>
					</tr>
					<tr>
						<td <?php if($row['achievement_minekills']) echo 'class="active"';?>>
							<div class="text-center"><img src="17.png"></div>
						</td>
						<td <?php if($row['achievement_minekills']) echo 'class="active"';?>>
							<div class="text-left">
								<b><u>Saper</u></b><br>
								<b>Wymagania:</b><br>
								&#187; 100 Zabić miną<br>
							</div>
						</td>
						<td <?php if($row['achievement_minedeaths']) echo 'class="active"';?>>
							<div class="text-center"><img src="18.png"></div>
						</td>
						<td <?php if($row['achievement_minedeaths']) echo 'class="active"';?>>
							<div class="text-left">
								<b><u>Nieudacznik</u></b><br>
								<b>Wymagania:</b><br>
								&#187; 200 Zginięć od miny<br>
							</div>
						</td>
					</tr>
					<tr>
						<td <?php if($row['achievement_pockets']) echo 'class="active"';?>>
							<div class="text-center"><img src="19.jpg"></div>
						</td>
						<td <?php if($row['achievement_pockets']) echo 'class="active"';?>>
							<div class="text-left">
								<b><u>Padlinożerca</u></b><br>
								<b>Wymagania:</b><br>
								&#187; 500 Podniesionych paczek<br>
							</div>
						</td>
						<td <?php if($row['achievement_connections']) echo 'class="active"';?>>
							<div class="text-center"><img src="20.png"></div>
						</td>
						<td <?php if($row['achievement_connections']) echo 'class="active"';?>>
							<div class="text-left">
								<b><u>Bywalec</u></b><br>
								<b>Wymagania:</b><br>
								&#187; 2.000 Połączeń z serwerem<br>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</center>
		<center>
			<table class="table table-bordered table-condensed table-striped">
				<caption>
					<div class="alert">
						<strong>Medale</strong>
					</div>
				</caption>
				<thead>
					<tr>
						<th class="medal1">
							<div class="text-center">
								Brazowy Medal
							</div>
						</th>
						<th class="medal2">
							<div class="text-center">
								Srebrny Medal
							</div>
						</th>
						<th class="medal3">
							<div class="text-center">
								Złoty Medal
							</div>
						</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="medale1">
							<div class="text">
								&#187; Zdobadź 3 miejsce w ilości fragów na mapie
							</div>
						</td>
						<td class="medale2">
							<div class="text">
								&#187; Zdobadź 2 miejsce w ilości fragów na mapie
							</div>
						</td>
						<td class="medale3">
							<div class="text">
								&#187; Zdobadź 1 miejsce w ilości fragów na mapie
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</center>
	</div>
</body>
</html>