<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:ra="http://xml.ra.se/e-arkiv/FGS-ERMS" xmlns:ca="Cambio" exclude-result-prefixes="xs fn ra fo ca">
<xsl:output indent="yes" media-type="xml" encoding="ISO-8859-1"/>
<xsl:template match="/">
<html>
<style>

html{
background-color: gray;
}

h1 {
	text-align:center;

}

p {
  margin: 3px}


  .tab {
	  background-color: gray;
	  position: fixed;
	  padding: 10px;
	  top: -10px;
	  right:-11px;
	  left:-10px;
	  border: none;
  }

  div {
	  border: 1px solid black;
background-color: white;
  padding: 10px; 
  margin: 10px;
  }

  #oversikt {
	  border: 1px solid black;
background-color:white;
  padding: 10px; 
  margin: 10px;
  margin-top: 55px;
  }

 

  h5 {margin: 3px;}  

  
  </style>
  
  
<xsl:for-each select="//ra:ArkivobjektArende">
<xsl:variable name="id"><xsl:value-of select="ra:ArkivobjektID"/></xsl:variable>


<div class="tab">
	<button class="tablinks" onclick="location.href='#oversikt'">Översikt</button>
	<button class="tablinks" onclick="location.href='#anteckningar'">Anteckningar</button>
	<button class="tablinks" onclick="location.href='#ansokningar'">Ansökningar</button>
	<button class="tablinks" onclick="location.href='#utredningar'">Utredningar</button>
	<button class="tablinks" onclick="location.href='#bilagor'">Bilagor</button>
	<button class="tablinks" onclick="location.href='#beslutslista'">Beslutslista</button>
	<button class="tablinks" onclick="location.href='#berakningar'">Beräkningar</button>
	<button class="tablinks" onclick="location.href='#ekonomi'">Ekonomi</button>
	</div>


<!--Översikt -->
<div id="oversikt" class="tabcontent">
<h1><xsl:value-of select="ra:Arendemening"/></h1>
<hr></hr>
<h2>Registerhållare</h2>
<p>ÄrendeID: <xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:ExtraID"/></p>
<p>Personnummer: <xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Personnummer"/></p>
<p>Namn: <xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Namn"/></p>
<p>Ärendet öppnat: <xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Skapad"/></p>

</div>


<!--Anteckningar-->
<div id="anteckningar" class="tabcontent">
<h2>Anteckningar</h2>

<xsl:for-each select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Anteckningar/ca:Anteckning">
<h3>Anteckning <xsl:value-of select="ca:Skapad"/></h3> 
<p>Skapad: <xsl:value-of select="ca:Skapad"/></p>
<p>Skapad av: <xsl:value-of select="ca:SkapadAv/ca:VisningsNamn"/></p>

<xsl:for-each select="ca:Dokumentation">
<br></br>
<h5><xsl:value-of select="ca:Rubrik"></xsl:value-of></h5>
<p><xsl:value-of select="ca:Text"></xsl:value-of></p>
</xsl:for-each>

</xsl:for-each>
</div>

<!--Ansökningar -->
<xsl:for-each select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Ansökningar">
<div id="ansokningar" class="tabcontent">
<h2>Ansökningar</h2>

<xsl:for-each select="ca:Ansökan">
<h3>Ansökan</h3>
<xsl:value-of select="ca:Skapad"/>
<xsl:value-of select="."/>
</xsl:for-each>

</div>
</xsl:for-each>


<!--Utredningar -->
<xsl:for-each select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Utredningar">
<div id="utredningar" class="tabcontent">
<h2>Utredningar</h2>

<xsl:for-each select="ca:Utredning_2">
<h3>Utredning</h3>
<xsl:value-of select="ca:Inledd_enligt_beslut"/>
<xsl:value-of select="."/>
</xsl:for-each>

</div>
</xsl:for-each>

<!-- Bilagor -->
<xsl:for-each select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Bilagor">
<div id='bilagor' class="tabcontent">
<h3>Bilagor</h3>
<xsl:for-each select="ca:Bilaga">
<h4>Bilaga <xsl:number value="position()" format="1"/>.</h4>
<p><xsl:value-of select="ca:Namn"></xsl:value-of></p>
<xsl:value-of select="."/>
</xsl:for-each>

</div>
</xsl:for-each>

<!--Beslutslista -->
<xsl:for-each select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Beslutslista">
<div id="beslutslista" class="tabcontent">
<h2>Beslutslista</h2>

<xsl:for-each select="ca:Beslut">
<h3>Beslut</h3>
<xsl:value-of select="ca:Beslutsinformation/ca:Beslut"/>
<xsl:value-of select="."/>
</xsl:for-each>

</div>
</xsl:for-each>


<!--Beräkningar -->
<xsl:for-each select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Beräkningar">
<div id="berakningar" class="tabcontent">
<h2>Beräkningar</h2>

<xsl:for-each select="ca:Beräkning">
<h3>Beräkning</h3>
<xsl:value-of select="ca:Referenser/ca:Referens/ca:Typ"/>
<xsl:value-of select="."/>

</xsl:for-each>

</div>
</xsl:for-each>

<!--Ekonomi -->
<xsl:for-each select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Ekonomi">
<div id="ekonomi" class="tabcontent">
<h2>Ekonomi</h2>

<xsl:for-each select="ca:Utbetalning">
<h3>Utbetalning</h3>
<xsl:value-of select="."/>

</xsl:for-each>

</div>
</xsl:for-each>


</xsl:for-each>










</html>
</xsl:template>










</xsl:stylesheet>
