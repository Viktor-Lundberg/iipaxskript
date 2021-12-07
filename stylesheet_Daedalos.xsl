<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:ARN="http://www.lpa.net/">
<xsl:output indent="yes" media-type="html" encoding="utf-8"/>

<!-- Skapar HTML -->
<xsl:template match="/">
<html>
	<head>
	<!-- Lägger på styling -->
	<xsl:call-template name="CSS"/>
	</head>

<body>
<div id="backgrounddiv">
 
<!-- Callar Ärendedata -->
<div id="arendedata">
<xsl:apply-templates select="ARN:ARN"/>
</div>

<!--Knapparna -->
<div class="buttons">
<table id="buttontable">
		<tr>
		<th class="buttontableth">Åtgärder</th>
		<th class="buttontableth">Kopplingar</th>
		<th class="buttontableth">Handlingar</th>
		</tr>
<tr>
	<td>Visa<input type="radio" name="buttonatgarder" onclick="document.getElementById('atgarder').style.display = 'inline';"/>
	<br/>Dölj <input type="radio" name="buttonatgarder" onclick="document.getElementById('atgarder').style.display = 'none';" checked="checked"/></td>




<td>Visa<input type="radio" name="buttonconnects" onclick="document.getElementById('connects').style.display = 'inline';"/>
<br/>Dölj <input type="radio" name="buttonconnects" onclick="document.getElementById('connects').style.display = 'none';" checked="checked"/></td>


<td>
Visa<input type="radio" name="buttonhandlingar" onclick="document.getElementById('handlingar').style.display = 'inline';"/>
<br/>Dölj <input type="radio" name="buttonhandlingar" onclick="document.getElementById('handlingar').style.display = 'none';" checked="checked"/></td>
</tr>
</table>
</div>


<!-- informationsrutan -->
<div class="information">

<div id="atgarder" style="display:none;">
<xsl:choose>
	<xsl:when test="//ARN:Atgard"><xsl:apply-templates select="//ARN:Atgard"><xsl:sort select="ARN:Registrerad_den"/></xsl:apply-templates></xsl:when>
	<xsl:otherwise><div id="ingatraffar"><h3>Åtgärder</h3><xsl:call-template name="ingaträffar"/></div></xsl:otherwise>
</xsl:choose>


</div>

<div id="connects" style="display:none;">
<xsl:choose>
	<xsl:when test="//ARN:Arnconnect"><xsl:apply-templates select="//ARN:Arnconnect"><xsl:sort select="ARN:Lopnummer"/></xsl:apply-templates></xsl:when>
	<xsl:otherwise><div id="ingatraffar"><h3>Kopplingar</h3><xsl:call-template name="ingaträffar"/></div></xsl:otherwise>
</xsl:choose>
</div>

<div id="handlingar" style="display:none;">
<xsl:choose>
	<xsl:when test="//ARN:Arnhandling"><xsl:apply-templates select="//ARN:Arnhandling"><xsl:sort select="ARN:Lopnummer"/></xsl:apply-templates></xsl:when>
	<xsl:otherwise><div id="ingatraffar"><h3>Handlingar</h3><xsl:call-template name="ingaträffar"/></div></xsl:otherwise>
	
</xsl:choose>


</div>

</div>

</div>
</body>
</html>
</xsl:template>


<!--Styling -->
<xsl:template name="CSS"><style>
html {
				background-color: white;
				font-family: Verdana;
				font-size: x-small;
			}
			
			#backgrounddiv {
				border: 1px solid black;
				background-color: #aec7e2;
				padding: 10px; 
				margin: 10px;
  }
			
				#arendedata {	
				border: 1px solid black;
				background-color: white;
			}

			.buttons {
				background-color:hsl(285, 59%, 81%, 0.4);
				margin: 10px 0px 5px 0px;
			}

			

			#atgard, #connect, #handling, #ingatraffar {
				background-color: white;
				border: 1px solid black;
				margin-bottom: 10px;
			}

			table {
				font-family: Verdana;
				font-size: x-small;
			}

			th {
				text-align: left;
				
			}

			#buttontable {
				width: auto;
			}

			.buttontableth {
				width: 100px;
			}

			h3 {
				font-size: small;
				background-color:rgba(112, 112, 236);
				margin-bottom: 5px;
			}					
</style>
</xsl:template>


<!-- Ärendekortet -->
<xsl:template match="ARN:ARN">
<h2>Ärende</h2>
<table>
		<tr>
			<th>Diarienummer</th>
			<th>Registreringsdatum</th>
			<th>Ansvarig handläggare</th>
		</tr>
		<tr>
			<td><xsl:value-of select="ARN:Diarienummer"/></td>
			<td><xsl:value-of select="ARN:Registreringsdatum"/></td>
			<td><xsl:value-of select="ARN:Ansvarig_handlaggare"/></td>
		</tr>
		<tr>
			<th>Ärendemening</th>
		</tr>
		<tr>
			<td><xsl:value-of select="ARN:Arendemening"/></td>
		</tr>
		<tr>
			<th>Ärendekod</th>
			<th>Klass</th>
			<th>Ärendebenämning</th>
		</tr>
		<tr>
			<td><xsl:value-of select="ARN:Arendekod"/></td>
			<td><xsl:value-of select="ARN:Klass"/></td>
			<td><xsl:value-of select="ARN:Arendebenamning"/></td>
		</tr>
		<tr>
			<th class="buttontable">Sekretess</th>
			<th class="buttontable">Känsliga personuppgifter</th>
			<th class="buttontable">Internt skydd</th>
		</tr>
		<tr>
			<td><xsl:value-of select="ARN:Sekretess_OSL"/></td>
			<td><xsl:value-of select="ARN:Sekretess_PUL"/></td>
			<td><xsl:value-of select="ARN:Sekretess_intern"/></td>
		</tr>
		<tr>
			<th>Motpart</th>
			<th>Externt diarienummer</th>
		</tr>
		<tr>
			<td><xsl:value-of select="ARN:Motpart"/></td>
			<td>KOLLA UPP!</td>
		</tr>
</table>

</xsl:template>


<!-- Åtgärder -->
<xsl:template match="ARN:Atgard">

<div id="atgard"><h3>Åtgärd</h3>
<xsl:for-each select="*">
<table>
<xsl:if test=". !=''">
<tr>
	<th><xsl:value-of select="fn:local-name()"/></th>
	<td><xsl:value-of select="."/></td>
</tr>
</xsl:if>
</table>
</xsl:for-each>
</div>
</xsl:template>


<!-- Kopplingar -->
<xsl:template match="ARN:Arnconnect">
<div id="connect"><h3>Koppling</h3>
<xsl:for-each select="*">
<table>
<xsl:if test=". !=''">
<tr>
	<th><xsl:value-of select="fn:local-name()"/></th>
	<td><xsl:value-of select="."/></td>
</tr>
</xsl:if>
</table>
</xsl:for-each>
</div>
</xsl:template>


<!-- Handlingar -->
<xsl:template match="ARN:Arnhandling">
<div id="handling"><h3>Handling</h3>
<xsl:for-each select="*">
<table>
<xsl:if test=". !=''">
<tr>
	<th><xsl:value-of select="fn:local-name()"/></th>
	<td><xsl:value-of select="."/></td>
</tr>
</xsl:if>
</table>
</xsl:for-each>
</div>
</xsl:template>


<!-- Om det saknas åtgärder, kopplingar eller handlingar visas nedan -->
<xsl:template name="ingaträffar">
<table>
		<tr>
			<th>Det finns inget att visa.</th>
		</tr>	
</table>
</xsl:template>


</xsl:stylesheet>
