<!DOCTYPE html>
<html>
<head>
	<title>Dzienny bonus</title>
	<meta charset="UTF-8">
	<style type="text/css">

	body {
	   color: #fff;
	   text-align: center;
	   background-color: #1a1a1a;
	   font-name: Tahoma;

	}

	.alert {
	   padding: 10px 20px 10px 20px;
	   margin-bottom: 20px;
	   text-shadow: 0 1px 0 rgba(255, 255, 255, 0.5);
	   background-color: #262626;
	   font-weight: bold;
	   width: 48%;
	   border: 1px solid #000; 
	   text-align: center;
	   -moz-border-radius: 6px;
	   -webkit-border-radius: 6px;
	   border-radius: 6px;
	   font-size: 24px;
	}

	table {
	   background-color: #404040;
	   border-color: #000;
	   border-width: 1px;  
	   border-style: groove;
	   border-collapse: collapse;  
	   -moz-border-radius: 3px;
	   -webkit-border-radius: 3px;
	   border-radius: 3px
	}

	td, th {
	   border-radius: 15px
	   height: 100px;
	   text-align: center;
	}

	th {
	   height: 36px;
	   background-color: #262626;
	}

	td {
	   height: 30px;
	}

	.active {
	   text-shadow:3px 3px 10px #00FF00;
	   color: #00ff00;
	}

	.active2 {
	   text-shadow:3px 3px 10px #ff1a1a;
	   color: #ff1a1a;
	}

	.active3 {
	   color: gold;
	   font-weight: bold;
	}

	   





	</style>
</head>
<body>
	<center>
		<div class="alert">
			Dzienny bonus!
		</div>
		<table border="1" width="50%">
			<tr>
				<th <?php if($_GET['day'] == 1) echo 'class="active"'; ?>>	Dzień 1</th>
				<th <?php if($_GET['day'] == 2) echo 'class="active"'; ?>>Dzień 2</th>
				<th <?php if($_GET['day'] == 3) echo 'class="active"'; ?>>Dzień 3</th>
				<th <?php if($_GET['day'] == 4) echo 'class="active"'; ?>>Dzień 4</th>
				<th <?php if($_GET['day'] == 5) echo 'class="active"'; ?>>Dzień 5</th>
				<th <?php if($_GET['day'] == 6) echo 'class="active"'; ?>>Dzień 6</th>
				<th <?php if($_GET['day'] == 7) echo 'class="active"'; else echo 'class="active2"'; ?>>Dzień 7</th>
			</tr>
			<tr>
				<td><img height="100" src="gwiazda.png" width="100"></td>
				<td><img height="100" src="gwiazda.png" width="100"></td>
				<td><img height="100" src="gwiazda.png" width="100"></td>
				<td><img height="100" src="gwiazda.png" width="100"></td>
				<td><img height="100" src="dolar.png" width="100"></td>
				<td><img height="100" src="dolar.png" width="100"></td>
				<td><img height="100" src="dolar.png" width="100"></td>
			</tr>
			<tr>
				<td <?php if($_GET['day'] == 1) echo 'class="active"'; ?>>150 EXP</td>
				<td <?php if($_GET['day'] == 2) echo 'class="active"'; ?>>300 EXP</td>
				<td <?php if($_GET['day'] == 3) echo 'class="active"'; ?>>450 EXP</td>
				<td <?php if($_GET['day'] == 4) echo 'class="active"'; ?>>600 EXP</td>
				<td <?php if($_GET['day'] == 5) echo 'class="active"'; else echo 'class="active3"';?>>15 diamentów</td>
				<td <?php if($_GET['day'] == 6) echo 'class="active"'; else echo 'class="active3"';?>>15 diamentów</td>
				<td <?php if($_GET['day'] == 7) echo 'class="active"'; else echo 'class="active3"';?>>15 diamentów</td>
			</tr>
		</table>
	</center>
</body>
</html>