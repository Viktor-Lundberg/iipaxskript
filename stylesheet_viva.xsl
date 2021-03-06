<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:ra="http://xml.ra.se/e-arkiv/FGS-ERMS" xmlns:ca="Cambio" exclude-result-prefixes="xs fn ra fo ca">
	<xsl:output indent="yes" media-type="xml" encoding="ISO-8859-1"/>
	<xsl:template match="/">
		<html>
			<style>

html{
background-color: 879EAD;
font-family: Verdana;
font-size: small;
}

h1 {
	text-align:center;

}

p {
  margin: 3px}


  .tab {
	  background-color: 879EAD;
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

	#tablemeny {
	 width: 92%;
	 position:center;	
	 
	 }
 

table {
	border-spacing: 10px;
	font-family: Verdana;
font-size: small;
} 

 
 td {
 vertical-align: top;
 height:100%
 text-align: left;
 padding: 6px;
 
 }

th {
	text-align: left;
	vertical-align: top;
	padding: 6px;
}
	.tablemenydiv {
		background-color:#ececec;
		border: 1px solid black;
	
	
	}

  h5 {margin: 3px;} 
  h4 {margin-bottom:3px;}
  
  
  .midrubrik {font: italic;
			  margin-bottom:1px;}
  
  .insidediv {
		background-color:#ececec;
		} 
	
	.beslutslistatabell {
	background-color:D3D7DA;
	border-collapse: collapse;
	 word-wrap: break-word;
	}
	
	.beslutslistatabell th {
	background-color: 3B5F77;
	color: white;
	word-wrap: break-word;
	border: 1px solid black;	
	}
	
	.beslutslistatabell td {
		border: 1px solid black;
		font-size: x-small;
		word-wrap: break-word;

		}
		
	.createinfo { 
	font-size: x-small;
	background-color: #ececec;
	text-align: right;
	
	}
  
  </style>
			<xsl:for-each select="//ra:ArkivobjektArende">
				<xsl:variable name="id">
					<xsl:value-of select="ra:ArkivobjektID"/>
				</xsl:variable>
				<div class="tab">
					<button class="tablinks" onclick="location.href='#oversikt'">??versikt</button>
					<xsl:if test="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Anteckningar">
						<button class="tablinks" onclick="location.href='#anteckningar'">Anteckningar</button>
					</xsl:if>
					<xsl:if test="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Ans??kningar">
						<button class="tablinks" onclick="location.href='#ansokningar'">Ans??kningar</button>
					</xsl:if>
					<xsl:if test="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Anm??lningar">
						<button class="tablinks" onclick="location.href='#anmalningar'">Anm??lningar</button>
					</xsl:if>
					<xsl:if test="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Utredningar">
						<button class="tablinks" onclick="location.href='#utredningar'">Utredningar</button>
					</xsl:if>
					<xsl:if test="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Insatser">
						<button class="tablinks" onclick="location.href='#insatser'">Insatser</button>
					</xsl:if>
					<xsl:if test="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Bilagor">
						<button class="tablinks" onclick="location.href='#bilagor'">Bilagor</button>
					</xsl:if>
					<xsl:if test="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Beslutslista">
						<button class="tablinks" onclick="location.href='#beslutslista'">Beslutslista</button>
					</xsl:if>
					<xsl:if test="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Ber??kningar">
						<button class="tablinks" onclick="location.href='#berakningar'">Ber??kningar</button>
					</xsl:if>
					<xsl:if test="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Ekonomi">
						<button class="tablinks" onclick="location.href='#ekonomi'">Ekonomi</button>
					</xsl:if>
				</div>
				<!--??versikt -->
				<div id="oversikt" class="tabcontent">
					<h1>
						<xsl:value-of select="ra:Arendemening"/>
					</h1>
					<hr/>
					<!--Tabell-->
					<table id="tablemeny">
						<tr>
							<td>
								<div class="tablemenydiv">
									<h3>??rendeinformation</h3>
									<p>??rendeID: <xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:ExtraID"/>
									</p>
									<p>??rendetyp: <xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Arendetyp"/>
									</p>
									<p>??rendemening: <xsl:value-of select="ra:Arendemening"/>
									</p>
									<p>??rendet ??ppnat: <xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:??ppnad"/>
									</p>
									<p>??rendet skapat: <xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Skapad"/>
									</p>
									<p>??rendet avslutat: <xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Avslutad"/>
									</p>
								</div>
							</td>
							<td>
								<div class="tablemenydiv">
									<h3>Registerh??llare</h3>
									<p>Personnummer: <xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Personnummer"/>
									</p>
									<p>Namn: <xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Namn"/>
									</p>
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="tablemenydiv">
									<h3>Handl??ggning</h3>
									<p>Enhet: <xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handl??ggning/ca:Enhet"/>
									</p>
									<p>Team: <xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handl??ggning/ca:Team"/>
									</p>
									<p>Handl??ggare: <xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handl??ggning/ca:Handl??ggare/ca:VisningsNamn"/>
										<xsl:text>, </xsl:text>
										<xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handl??ggning/ca:Handl??ggare/ca:Titel"/>
									</p>
									<xsl:if test="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handl??ggning/ca:Medhandl??ggare">
										<p>Medhandl??ggare: <xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handl??ggning/ca:Medhandl??ggare/ca:VisningsNamn"/>
											<xsl:text>, </xsl:text>
											<xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handl??ggning/ca:Medhandl??ggare/ca:Titel"/>
										</p>
									</xsl:if>
								</div>
							</td>
						</tr>
					</table>
				</div>
				
				<!--Anteckningar-->
				<xsl:if test="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Anteckningar">
					<div id="anteckningar" class="tabcontent">
						<h2>Anteckningar</h2>
						<xsl:for-each select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Anteckningar/ca:Anteckning">
						<xsl:sort select="ca:Skapad" order="descending"/>
							<div class="insidediv">
								<h3>Anteckning <xsl:value-of select="ca:Skapad"/>
								</h3>
								<table>
									<tr>
										<td>H??ndelsedatum</td>
										<td>
											<xsl:value-of select="ca:H??ndelsedatum"/>
										</td>
									</tr>
									<tr>
										<td>Beskrivning</td>
										<td>
											<xsl:value-of select="ca:Beskrivning"/>
										</td>
									</tr>
									<xsl:for-each select="ca:Dokumentation">
										<tr>
											<th>
												<xsl:value-of select="ca:Rubrik"/>
											</th>
											<td>
												<xsl:value-of select="ca:Text"/>
											</td>
										</tr>
									</xsl:for-each>
								</table>

								<hr class="row"></hr>
								<p class="createinfo">Dokumentet skapades <xsl:value-of select="ca:Skapad"/>
								 av<xsl:text> </xsl:text><xsl:value-of select="ca:Skapad_av/ca:VisningsNamn"/><xsl:text>, </xsl:text><xsl:value-of select="ca:Skapad_av/ca:Titel"/></p>
								
								
							</div>
						</xsl:for-each>
					</div>
				</xsl:if>
				
				<!--Ans??kningar-->
				<xsl:for-each select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Ans??kningar">
					<div id="ansokningar" class="tabcontent">
						<h2>Ans??kningar</h2>
						<xsl:for-each select="ca:Ans??kan">
						<xsl:sort select="ca:Ans??kningshandlingar/ca:Handling_inkom" order="descending"/>
						<div class="insidediv">
							<h3>Ans??kan</h3>
							<h4 class="midrubrik">Ans??kningshandlingar</h4>
							<hr></hr>
							<table>
								<tbody>
									<tr>
										<th>Skickade</th>
										<td><xsl:value-of select="ca:Ans??kningshandlingar/ca:Handling_skickad"/></td>
									</tr>
									<tr>
										<th>Inkom</th>
										<td><xsl:value-of select="ca:Ans??kningshandlingar/ca:Handling_inkom"/></td>
									</tr>
									<tr>
										<th>Ans??kan gjordes av</th>
										<td><xsl:value-of select="ca:Ans??kningshandlingar/ca:Ans??kan_gjordes_av"/></td>
									</tr>
									<tr>
										<th>Hur ans??kan gjordes</th>
										<td><xsl:value-of select="ca:Ans??kningshandlingar/ca:Hur_ans??kan_gjordes"/></td>
									</tr>
									<tr>
										<th>Samtycke</th>
										<td><xsl:value-of select="ca:Samtycke/ca:V??rde"/></td>
									</tr>
									<tr>
										<th>Datum f??r samtycke</th>
										<td><xsl:value-of select="ca:Samtycke/ca:Datum"/></td>
									</tr>
								</tbody>
							</table>
							
							<h4>Inneh??llet i ans??kan</h4>
							<p><xsl:value-of select="ca:Inneh??ll"/></p>
							
							<h4>??vriga noteringar</h4>
							<p><xsl:value-of select="ca:??vrig_notering"/></p>
								
							<xsl:if test="ca:Checklista">
							<xsl:for-each select="ca:Checklista/ca:Checklistedel">
							<fieldset>
							<legend><xsl:value-of select="ca:Rubrik"/></legend>
							<xsl:for-each select="ca:V??rde">
							<input type="checkbox" id="checkbox" readonly="readonly" checked="checked" disabled="disabled"></input>
							<label for="checkbox"><xsl:value-of select="."/></label><br></br>
							</xsl:for-each>
							<h4>Notering</h4>
							<p><xsl:value-of select="ca:Notering"/></p>
							</fieldset>
							
							</xsl:for-each>
							
							
							
							</xsl:if>
							
							
							<hr class="row"></hr>
								<p class="createinfo">Dokumentet skapades <xsl:value-of select="ca:Skapad"/>
								 av<xsl:text> </xsl:text><xsl:value-of select="ca:Skapad_av/ca:VisningsNamn"/><xsl:text>, </xsl:text><xsl:value-of select="ca:Skapad_av/ca:Titel"/></p>
							</div>
						</xsl:for-each>
						<xsl:for-each select="ca:Fortsatt_ans??kan">
						<div class="insidediv">
						<h3>Fortsatt ans??kan</h3>
						<table>
							<tbody>
								<tr>
									<th>Inkom</th>
									<td><xsl:value-of select="ca:Inkom"/></td>
								</tr>
								<tr>
									<th>Period</th>
									<td><xsl:value-of select="ca:Period"/></td>
								</tr>
								<tr>
									<th>Beskrivning</th>
									<td><xsl:value-of select="ca:Beskrivning"/></td>
								</tr>
							</tbody>
						</table>
						<xsl:if test="ca:E-Ans??kan">
							
							<h4 class="midrubrik">E-Ans??kan</h4>
							<hr></hr>
								<xsl:for-each select="ca:E-Ans??kan/ca:Kategori">
								<xsl:choose>
									<xsl:when test="ca:Post">
									<h4><xsl:value-of select="ca:Rubrik"/></h4>
									<xsl:for-each select="ca:Post/ca:Information">
								<table>
									<tbody>
										<tr>
											<th><xsl:value-of select="ca:Rubrik"/></th>
											<td><xsl:value-of select="ca:V??rde"/><xsl:value-of select="ca:Text"/></td>
										</tr>
									</tbody>
								</table>
									
								
								</xsl:for-each>
								
									
									
									
									</xsl:when>
									
									
								<xsl:otherwise>
								
								<h4><xsl:value-of select="ca:Rubrik"/></h4>
									<xsl:for-each select="ca:Information">
								<table>
									<tbody>
										<tr>
											<th><xsl:value-of select="ca:Rubrik"/></th>
											<td><xsl:value-of select="ca:V??rde"/><xsl:value-of select="ca:Text"/></td>
										</tr>
									</tbody>
								</table>
								</xsl:for-each>
								</xsl:otherwise>	
								</xsl:choose>
								
								
								
								
							</xsl:for-each>
						</xsl:if>
						
						<xsl:if test="ca:Komplettering">
						<h4 class="midrubrik">komplettering</h4>
							<hr></hr>
						
						<xsl:for-each select="ca:Komplettering">
						<table>
							<tbody>
								<tr>
									<th>Skickad</th>
									<td><xsl:value-of select="ca:Komplettering_skickad"/></td>
								</tr>
								<tr>
									<th>Komplettering ??ter senast</th>
									<td><xsl:value-of select="ca:Komplettering_??ter_senast"/></td>
								</tr>
								<tr>
									<th>Beg??rda kompletteringar</th>
									<td><xsl:value-of select="ca:Beg??rda_kompletteringar"/></td>
								</tr>
								<tr>
									<th>F??rtydligande</th>
									<td><xsl:value-of select="ca:F??rtydligande"/></td>
								</tr>
								<tr>
									<th>Komplettering inkom</th>
									<td><xsl:value-of select="ca:Komplettering_inkom"/></td>
								</tr>
								<tr>
									<th>Inkomna kompletteringar</th>
									<td><xsl:value-of select="ca:Inkomna_kompletteringar"/></td>
								</tr>
							</tbody>
						</table>
						
						
						
						</xsl:for-each>
						
						</xsl:if>	
						<hr class="row"></hr>
								<p class="createinfo">Dokumentet skapades <xsl:value-of select="ca:Skapad"/>
								 av<xsl:text> </xsl:text><xsl:value-of select="ca:Skapad_av/ca:VisningsNamn"/><xsl:text>, </xsl:text><xsl:value-of select="ca:Skapad_av/ca:Titel"/></p>	
						</div>
						</xsl:for-each>
						
								
					</div>
				</xsl:for-each>
				
				<!-- Anm??lningar -->
				<xsl:for-each select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Anm??lningar">
					<div id="anmalningar" class="tabcontent">
						<h2>Anm??lningar</h2>
						<xsl:for-each select="ca:Anm??lan">
						
						<div class="insidediv">
							<h3>Anm??lan</h3>
							<table>
								<tbody>
									<tr>
										<th>Anm??lan ID</th>
										<td><xsl:value-of select="ca:Anm??lanID"/></td>
									</tr>
									<tr>
										<th>Mottagare</th>
										<td><xsl:value-of select="ca:Mottagare/ca:VisningsNamn"/>,<xsl:value-of select="ca:Mottagare/ca:Titel"/></td>
									</tr>
									<tr>
										<th>Kort beskrivning av anm??lan</th>
										<td><xsl:value-of select="ca:Kort_beskrivning"/></td>
									</tr>
									<xsl:for-each select="ca:Beskrivning">
									<tr>
										<th><xsl:value-of select="ca:Rubrik"/></th>
										<td><xsl:value-of select="ca:Text"/></td>
									</tr>
									</xsl:for-each>
									
									<tr>
										<th>Bilagor</th><td>
										<xsl:for-each select="ca:Bilagor/ca:Bilaga">
										<xsl:value-of select="ca:Filnamn"/><xsl:text>, </xsl:text>
										</xsl:for-each>
										</td>

									</tr>
									
									
								</tbody>
							</table>
								
							
							
							
							<hr class="row"></hr>
								<p class="createinfo">Dokumentet skapades <xsl:value-of select="ca:Skapad"/>
								 av<xsl:text> </xsl:text><xsl:value-of select="ca:Skapad_av/ca:VisningsNamn"/><xsl:text>, </xsl:text><xsl:value-of select="ca:Skapad_av/ca:Titel"/></p>
							</div>
						</xsl:for-each>
						</div>
				</xsl:for-each>
				
					
				
				
				<!--Utredningar -->
				<xsl:for-each select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Utredningar">
					<div id="utredningar" class="tabcontent">
						<h2>Utredningar</h2>
						<xsl:for-each select="ca:Utredning_2">
						<xsl:sort select="ca:Inledd" order="descending"/>
							<div class="insidediv">
								<h3>Utredning</h3>
								<table>
									<tr>
										<th>Utredningsnamn</th>
										<td>
											<xsl:value-of select="ca:Utredningsnamn"/>
										</td>
									</tr>
									<tr>
										<th>Utredningen avser</th>
										<td>
											<xsl:value-of select="ca:Avser/ca:Namn"/>
											<xsl:text> (</xsl:text>
											<xsl:value-of select="ca:Avser/ca:Personnummer"/>
											<xsl:text>)</xsl:text>
										</td>
									</tr>
									<tr>
										<th>Inledd</th>
										<td>
											<xsl:value-of select="ca:Inledd"/>
										</td>
									</tr>
									<tr>
										<th>Inledd enligt beslut</th>
										<td>
											<xsl:value-of select="ca:Inledd_enligt_beslut"/>
										</td>
									</tr>
									<tr>
										<th>Avslutad</th>
										<td>
											<xsl:value-of select="ca:Avslutad"/>
										</td>
									</tr>
									<tr>
										<th>Avslutsorsak</th>
										<td>
											<xsl:value-of select="ca:Avslutsorsak"/>
										</td>
									</tr>
									<xsl:for-each select="ca:Dokumentation">
										<tr>
											<th>
												<xsl:value-of select="ca:Rubrik"/>
											</th>
											<td>
												<xsl:value-of select="ca:Text"/>
											</td>
										</tr>
									</xsl:for-each>
								</table>
								<hr class="row"></hr>
								<p class="createinfo">Dokumentet skapades <xsl:value-of select="ca:Skapad"/>
								 av<xsl:text> </xsl:text><xsl:value-of select="ca:Skapad_av/ca:VisningsNamn"/><xsl:text>, </xsl:text><xsl:value-of select="ca:Skapad_av/ca:Titel"/></p>
							</div>
						</xsl:for-each>
						
					</div>
				</xsl:for-each>
				
				<!--INSATSER -->
				<xsl:for-each select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Insatser">
					<div id="insatser" class="tabcontent">
						<h2>Insatser</h2>
						<xsl:for-each select="ca:Insats">
						<xsl:sort select="ca:Skapad" order="descending"/>
							<div class="insidediv">
								<h3>Insats</h3>
								<h4>Allm??n information</h4>
								<table>
									<tr>
										<th>Avser</th>
										<th>Beviljad</th>
										<th>Beviljad period</th>
										<th>Insats</th>
									</tr>
									<tr>
										<td>
											<xsl:value-of select="ca:Avser/ca:Namn"/>, <xsl:value-of select="ca:Avser/ca:Personnummer"/>
										</td>
										<td>
											<xsl:value-of select="ca:Beviljad"/>
										</td>
										<td>
											<xsl:value-of select="ca:Beviljad_period"/>
										</td>
										<td>
											<xsl:value-of select="ca:Namn"/>
										</td>
									</tr>
								</table>
								<xsl:if test="ca:Verkst??llda_perioder/ca:Verkst??lld_period">
									<h4>Verkst??llda perioder</h4>
									<xsl:for-each select="ca:Verkst??llda_perioder/ca:Verkst??lld_period">
										<table>
											<tr>
												<th>Period</th>
												<td>
													<xsl:value-of select="."/>
												</td>
											</tr>
										</table>
									</xsl:for-each>
								</xsl:if>
								<table>
									<tbody>
										<tr>
											<th>Avslutad</th>
											<th>Avslutsorsak</th>
										</tr>
										<tr>
											<td>
												<xsl:value-of select="ca:Avslutad"/>
											</td>
											<td>
												<xsl:value-of select="ca:Avslutsorsak/ca:Orsak"/>
											</td>
										</tr>
									</tbody>
								</table>
								<xsl:for-each select="ca:Beslut">
									<h4>Beslut</h4>
									<table>
										<tr>
											<th>Beslutskategori</th>
											<th>Beslutstyp</th>
											<th>Beslutsfattare</th>
											<th>Beslutsdatum</th>
										</tr>
										<tr>
											<td>
												<xsl:value-of select="ca:Beslutskategori"/>
											</td>
											<td>
												<xsl:value-of select="ca:Beslutstyp"/>
											</td>
											<td>
												<xsl:value-of select="ca:Beslutsfattare/ca:VisningsNamn"/>
												<xsl:text>, </xsl:text>
												<xsl:value-of select="ca:Beslutsfattare/ca:Titel"/>
											</td>
											<td>
												<xsl:value-of select="ca:Beslutsdatum"/>
											</td>
										</tr>
										<tr>
											<th>Enligt</th>
											<th>Beviljad fr.o.m</th>
											<th>Beviljad t.o.m</th>
										</tr>
										<tr>
											<td>
												<xsl:value-of select="ca:Enligt"/>
											</td>
											<td>
												<xsl:value-of select="ca:Beviljad_fr.o.m."/>
											</td>
											<td>
												<xsl:value-of select="ca:Beviljad_t.o.m."/>
											</td>
										</tr>
									</table>
									<xsl:for-each select="ca:Inneh??ll/ca:Tj??nst">
										<table>
											<tbody>
												<tr>
													<th>Tj??nst</th>
													<td>
														<xsl:value-of select="ca:Namn"/>
													</td>
												</tr>
											</tbody>
										</table>
									</xsl:for-each>
								</xsl:for-each>
								<xsl:for-each select="ca:Best??llning">
								<h4>Best??llning</h4>
								<table>
									<tr>
										<th>Beviljad Period</th>
										<td><xsl:value-of select="ca:Beviljad_period"/></td>
									</tr>
									<tr>
										<th>Avser period</th>
										<td><xsl:value-of select="ca:Avser_period"/></td>
									</tr>
									
								</table>
								<table>
									<tbody>
										<tr>
											<th>Tj??nst</th>
											<td><xsl:value-of select="ca:Inneh??ll/ca:Tj??nst/ca:Namn"/></td>
										</tr>
										<xsl:for-each select="ca:Information">
										<th><xsl:value-of select="ca:Rubrik"/></th>
										<td><xsl:value-of select="ca:Text"/></td>
										
										</xsl:for-each>
										<xsl:for-each select="ca:V??rdplan_uppdrag">
										<tr>
										<th><h3><xsl:value-of select="ca:Rubrik[1]"/></h3></th>
										</tr>
										<xsl:for-each select="ca:Information">
										<tr>
											
										
										<th><xsl:value-of select="ca:Rubrik"/></th>
										<td><xsl:value-of select="ca:Text"/></td>
										</tr>
										</xsl:for-each>
								
										</xsl:for-each>										
										<xsl:for-each select="ca:Kompletterande_information">
										<tr>
											<th><h3>Kompletterande Information</h3></th>
										</tr>
										<xsl:for-each select="ca:Information">
										<tr>
											
										
										<th><xsl:value-of select="ca:Rubrik"/></th>
										<td><xsl:value-of select="ca:Text"/></td>
										</tr>
										</xsl:for-each>
										
										</xsl:for-each>
										<tr>
											<th>Resurs</th>
											<th>Mottagen</th>
											
										</tr>
										<tr>
											<td><xsl:value-of select="ca:Resurs"/></td>
											<td><xsl:value-of select="ca:Mottagen"/></td>
										</tr>
										<tr>
											<th>Mottagen av</th>
											<td><xsl:value-of select="ca:Mottagen_av/ca:VisningsNamn"/>, <xsl:value-of select="ca:Mottagen_av/ca:Titel"/></td>
										</tr>
									</tbody>
								</table>
								
								</xsl:for-each>
								<xsl:for-each select="ca:Insats_verkst??lld">
								<h4>Insats verkst??lld</h4>
								<table>
									<tr>
										<th>Verkst??lld</th>
										<th>Verkst??lld period</th>
										<th>Verkst??lld av</th>
									</tr>
									<tr>
										<td><xsl:value-of select="ca:Verkst??lld"/></td>
										<td><xsl:value-of select="ca:Verkst??lld_period"/></td>
										<td><xsl:value-of select="ca:Verkst??lld_av/ca:VisningsNamn"/>, <xsl:value-of select="ca:Verkst??lld_av/ca:Titel"/></td>
									</tr>
								</table>
								</xsl:for-each>
								<hr class="row"></hr>
								<p class="createinfo">Dokumentet skapades <xsl:value-of select="ca:Skapad"/>
								 av<xsl:text> </xsl:text><xsl:value-of select="ca:Skapad_av/ca:VisningsNamn"/><xsl:text>, </xsl:text><xsl:value-of select="ca:Skapad_av/ca:Titel"/></p>	
							</div>
						</xsl:for-each>
					</div>
				</xsl:for-each>
				
				<!-- Bilagor FIXA REFERENSER -->
				<xsl:for-each select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Bilagor">
					<div id='bilagor' class="tabcontent">
						<h3>Bilagor</h3>
						<xsl:for-each select="ca:Bilaga">
						<xsl:sort select="ca:Skapad" order="descending"/>
							<div class="insidediv">
								<h4>Bilaga - <xsl:value-of select="ca:Namn"/></h4>
								
								<table>
								<tr>
										<th>Skapad</th>
										<td><xsl:value-of select="ca:Skapad"/></td>
									</tr>
									<tr>
										<th>Filnamn</th>
										<td>
											<xsl:value-of select="ca:Filnamn"/>
										</td>
									</tr>
									
									<xsl:if test="ca:Referenser">
										<xsl:for-each select="ca:Referenser/ca:Referens">
											<tr>
												<th>Referens</th>
												<td>
													<xsl:value-of select="ca:Typ"/>
												</td>
											</tr>
										</xsl:for-each>
									</xsl:if>
								</table>
								<hr class="row"></hr>
								<p class="createinfo">Dokumentet skapades <xsl:value-of select="ca:Skapad"/>
								 av<xsl:text> </xsl:text><xsl:value-of select="ca:Skapad_av/ca:VisningsNamn"/><xsl:text>, </xsl:text><xsl:value-of select="ca:Skapad_av/ca:Titel"/></p>
							</div>
						</xsl:for-each>
					</div>
				</xsl:for-each>
				<!--Beslutslista -->
				<xsl:for-each select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Beslutslista">
					<div id="beslutslista" class="tabcontent">
						<div class="insidediv">
						<h2>Beslutslista</h2>
						<table class="beslutslistatabell">
							<tbody>
								<tr>
									<th>Slag</th>
									<th>Skapad</th>
									<th>Beslutsfattare</th>
									<th>Beslutsdatum</th>
									<th>Beslut</th>
									<th>Beslutsmotivering</th>
									<th>Utredning</th>
									<th>Avser</th>
								</tr>
								<xsl:for-each select="ca:Beslut">
								
								 
								<xsl:sort select="ca:Skapad" order="descending"/>
								<!-- Problem med att vissa beslut tydligen har tv??-beslutsdatum
								<xsl:sort select="ca:Beslutsinformation/ca:Beslutsdatum" order="descending"/> -->
								
									<tr>
										<td>
											<xsl:value-of select="ca:Slag"/>
										</td>
										<td>
											<xsl:value-of select="ca:Skapad"/>
										</td>
										<td>
											<xsl:value-of select="ca:Beslutsinformation/ca:Beslutsfattare/ca:VisningsNamn"/>
											<xsl:text>, </xsl:text>
											<xsl:value-of select="ca:Beslutsinformation/ca:Beslutsfattare/ca:Titel"/>
										</td>
										<td>
											<xsl:value-of select="ca:Beslutsinformation/ca:Beslutsdatum"/>
										</td>
										<td>
											<xsl:value-of select="ca:Beslutsinformation/ca:Beslut"/>
										</td>
										<td>
											<xsl:value-of select="ca:Beslutsinformation/ca:Beslutsmotivering"/>
										</td>
										<td>
											<xsl:value-of select="ca:Beslutsinformation/ca:Utredning"/>
										</td>
										<td>
											<xsl:value-of select="ca:Beslutsinformation/ca:Avser"/>
										</td>
									</tr>
								</xsl:for-each>
							</tbody>
						</table>
						</div>
					</div>
				</xsl:for-each>
				
<!--Ber??kningar -->
				<xsl:for-each select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Ber??kningar">
					<div id="berakningar" class="tabcontent">
						<h2>Ber??kningar</h2>
						
						<xsl:for-each select="ca:Ber??kning">
						<xsl:sort select="ca:Ber??kningsdatum" order="descending"/>
						<div class="insidediv">
							<h3>Ber??kning</h3>
							<table>
								<tbody>
									<tr>
										<th>Period</th>
										<td><xsl:value-of select="ca:Period"/></td>
									</tr>
									<tr>
										<th>Ber??kningsdatum</th>
										<td><xsl:value-of select="ca:Ber??kningsdatum"/></td>
									</tr>
								</tbody>
							</table>
							<h4 class="midrubrik">Personer som p??verkar normen</h4>
							<hr></hr>
							<table>
								<tbody>
									<tr>
										<th>Namn</th>
										<th>Personnummer</th>
										<th>Med i norm</th>
										<th>Dagar</th>
										<th>Hush??ll</th>
										<th>Dagis</th>
									</tr>
									<xsl:for-each select="ca:Personer_i_norm/ca:Person">
									<tr>
										<td><xsl:value-of select="ca:Namn"/></td>
										<td><xsl:value-of select="ca:Personnummer"/></td>
										<td><xsl:value-of select="ca:Med_i_norm"/></td>
										<td><xsl:value-of select="ca:Dagar"/></td>
										<td><xsl:value-of select="ca:Med_i_hush??ll"/></td>
										<td></td>
									</tr>
									</xsl:for-each>
								</tbody>
							</table>
							<h4 class="midrubrik">Utgifter</h4>
							<hr></hr>
							<table>
								<tbody>
									<tr>
										<th>Utgifter</th>
										<th>Faktiska</th>
										<th>Godk??nda</th>
										<th>Anteckningar</th>
									</tr>
									<xsl:for-each select="ca:Utgifter/ca:Post">
									<tr>
										<td><xsl:value-of select="ca:Utgift"/></td>
										<td><xsl:value-of select="ca:Faktisk"/></td>
										<td><xsl:value-of select="ca:Godk??nd"/></td>
										<td><xsl:value-of select="ca:Anteckning"/></td>
									</tr>
									</xsl:for-each>
									<tr>
										<th>Summa</th>
										<td><xsl:value-of select="ca:Utgifter/ca:Summa"/></td>	
									</tr>
								</tbody>
							</table>
							
							<h4 class="midrubrik">Inkomster</h4>
							<hr></hr>
							<table>
								<tbody>
									<tr>
										<th>Inkomster</th>
										<th>Datum</th>
										<th>Belopp</th>
										<th>Anteckningar</th>
									</tr>
									<xsl:for-each select="ca:Inkomster/ca:Post">
									<tr>
										<td><xsl:value-of select="ca:Inkomst"/></td>
										<td><xsl:value-of select="ca:Datum"/></td>
										<td><xsl:value-of select="ca:Belopp"/></td>
										<td><xsl:value-of select="ca:Anteckning"/></td>
									</tr>
									</xsl:for-each>
									<tr>
										<th>Summa</th>
										<td><xsl:value-of select="ca:Inkomster/ca:Summa"/></td>	
									</tr>
								</tbody>
							</table>
							
							<!--OBS SAKNAS I XML -->
							<h4 class="midrubrik">Reducering</h4>
							<hr></hr>
							<table>
								<tbody>
									<tr>
										<th>Reducering</th>
										<th>Dagar</th>
										<th>Belopp</th>
										<th>Anteckningar</th>
									</tr>
									<xsl:for-each select="ca:Reduceringar/ca:Post">
									<tr>
										<td><xsl:value-of select="ca:Reducering"/></td>
										<td><xsl:value-of select="ca:Dagar"/></td>
										<td><xsl:value-of select="ca:Belopp"/></td>
										<td><xsl:value-of select="ca:Anteckning"/></td>
									</tr>
									</xsl:for-each>
									<tr>
										<th>Summa</th>
										<td><xsl:value-of select="ca:Reduceringar/ca:Summa"/></td>	
									</tr>
								</tbody>
							</table>
							<h4 class="midrubrik">Summering</h4>
							<hr></hr>
							<table>
								<tbody>
									<tr>
										<th>Belopp per person enligt norm</th>
									</tr>
									<xsl:for-each select="ca:Summering/ca:Belopp_per_person/ca:Person">
									<tr>
										<td><xsl:value-of select="ca:Namn"/></td>
										<td style="text-align: left;"><xsl:value-of select="ca:Belopp"/></td>
									</tr>
									</xsl:for-each>
									<tr>
										<th style="text-align: left;">Summa</th>
										
										<td style="text-align: left;"><xsl:value-of select="ca:Summering/ca:Belopp_per_person/ca:Summa"/></td>
									</tr>
								</tbody>
							</table>
							
							<table>
								<tbody>
									<tr>
										<th>Gemensamma hush??llskostnader</th>
									</tr>
									<xsl:for-each select="ca:Summering/ca:Gemensamma_hush??llskostnader">
									<tr>
										<td><xsl:value-of select="ca:Namn"/></td>
										<td><xsl:value-of select="ca:Belopp"/></td>
									</tr>
									</xsl:for-each>
								</tbody>
							</table>
							
							
							<table>
								<tbody>
									<tr>
										<th>Ber??kning</th>
									</tr>
									<xsl:for-each select="ca:Summering/ca:Ber??kning/ca:Poster">
									<tr>
										<td><xsl:value-of select="ca:Post"/></td>
										<td><xsl:value-of select="ca:Belopp"/></td>
									</tr>
									</xsl:for-each>
									<tr>
										<td>Summa (<xsl:value-of select="ca:Summering/ca:Ber??kning/ca:Summa/ca:Typ"/>)</td>
										<td><xsl:value-of select="ca:Summering/ca:Ber??kning/ca:Summa/ca:Belopp"/></td>
									</tr>
								</tbody>
							</table>
							<hr class="row"></hr>
								<p class="createinfo">Dokumentet skapades <xsl:value-of select="ca:Skapad"/>
								 av<xsl:text> </xsl:text><xsl:value-of select="ca:Skapad_av/ca:VisningsNamn"/><xsl:text>, </xsl:text><xsl:value-of select="ca:Skapad_av/ca:Titel"/></p>
						</div>
						</xsl:for-each>
					</div>
				</xsl:for-each>
				





<!--Ekonomi -->
				<xsl:for-each select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Ekonomi">
					<div id="ekonomi" class="tabcontent">
						<h2>Ekonomi</h2>
						<xsl:for-each select="ca:Utbetalning">
						<xsl:sort select="ca:Skapad" order="descending"/>
						<div class="insidediv">
							<h3>Utbetalning</h3>
							<table>
								<tbody>
									<tr>
										<th>Typ</th>
										<th>ID</th>
										<th>Status</th>
										<th>Betalning</th>
									</tr>
									<tr>
										<td><xsl:value-of select="ca:Typ"/></td>
										<td><xsl:value-of select="ca:Utbetalningsid"/></td>
										<td><xsl:value-of select="ca:Status"/></td>
										<td><xsl:value-of select="ca:Betalning"/></td>
									</tr>
									<tr>
										<th>Mottagare</th>
										<th>Reg. Mottagare</th>
										<th>Namn</th>
										<th>Betalningss??tt</th>
										<th>Belopp</th>
										<th>Moms</th>
										<th>Datum tillh.</th>
									</tr>
									<tr>
										<td><xsl:value-of select="ca:Betalningsmottagare"/></td>
										<td><xsl:value-of select="ca:Registrerad_mottagare"/></td>
										<td><xsl:value-of select="ca:Namn"/></td>
										<td><xsl:value-of select="ca:Betalningss??tt"/></td>
										<td><xsl:value-of select="ca:Belopp"/></td>
										<td><xsl:value-of select="ca:Moms"/></td>
										<td><xsl:value-of select="ca:Tillhandadatum"/></td>
									</tr>
									<tr>
										<th>Meddelande</th>
										<td><xsl:value-of select="ca:Meddelande"/></td>
									</tr>
								</tbody>
							</table>	
							<hr class="row"></hr>
								<p class="createinfo">Dokumentet skapades <xsl:value-of select="ca:Skapad"/>
								 av<xsl:text> </xsl:text><xsl:value-of select="ca:Skapad_av/ca:VisningsNamn"/><xsl:text>, </xsl:text><xsl:value-of select="ca:Skapad_av/ca:Titel"/></p>
						</div>
						</xsl:for-each>
					</div>
				</xsl:for-each>
			</xsl:for-each>
		</html>
	</xsl:template>
</xsl:stylesheet>
