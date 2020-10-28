<html>
	<body oncontextmenu="return false" onkeydown="return false">
		<?php
		
		
			function dameURL()
			{
				$url="http://".$_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI'];
				return $url;
			}
			
			$url2=DameURL();
			echo $url2;
			$url_final = str_replace("http://noxsp.pl/popups.php?web=", "", $url2);
			
			//echo $url_final;
		?>
		<script type="text/javascript">
			var popup=window.open("<?php echo $url_final; ?>","Noxowo","height="+screen.height+",width="+screen.width);
		</script>
	</body>
</html>