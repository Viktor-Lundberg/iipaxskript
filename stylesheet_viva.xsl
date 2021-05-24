<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:ra="http://xml.ra.se/e-arkiv/FGS-ERMS" xmlns:ca="Cambio" exclude-result-prefixes="xs fn ra fo ca">
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
					<button class="tablinks" onclick="location.href='#oversikt'">Översikt</button>
					<xsl:if test="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Anteckningar">
						<button class="tablinks" onclick="location.href='#anteckningar'">Anteckningar</button>
					</xsl:if>
					<xsl:if test="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Ansökningar">
						<button class="tablinks" onclick="location.href='#ansokningar'">Ansökningar</button>
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
					<xsl:if test="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Beräkningar">
						<button class="tablinks" onclick="location.href='#berakningar'">Beräkningar</button>
					</xsl:if>
					<xsl:if test="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Ekonomi">
						<button class="tablinks" onclick="location.href='#ekonomi'">Ekonomi</button>
					</xsl:if>
				</div>
				<!--Översikt -->
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
									<h3>Ärendeinformation</h3>
									<p>ÄrendeID: <xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:ExtraID"/>
									</p>
									<p>Ärendetyp: <xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Arendetyp"/>
									</p>
									<p>Ärendemening: <xsl:value-of select="ra:Arendemening"/>
									</p>
									<p>Ärendet öppnat: <xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Öppnad"/>
									</p>
									<p>Ärendet skapat: <xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Skapad"/>
									</p>
									<p>Ärendet avslutat: <xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Avslutad"/>
									</p>
								</div>
							</td>
							<td>
								<div class="tablemenydiv">
									<h3>Registerhållare</h3>
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
									<h3>Handläggning</h3>
									<p>Enhet: <xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handläggning/ca:Enhet"/>
									</p>
									<p>Team: <xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handläggning/ca:Team"/>
									</p>
									<p>Handläggare: <xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handläggning/ca:Handläggare/ca:VisningsNamn"/>
										<xsl:text>, </xsl:text>
										<xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handläggning/ca:Handläggare/ca:Titel"/>
									</p>
									<xsl:if test="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handläggning/ca:Medhandläggare">
										<p>Medhandläggare: <xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handläggning/ca:Medhandläggare/ca:VisningsNamn"/>
											<xsl:text>, </xsl:text>
											<xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handläggning/ca:Medhandläggare/ca:Titel"/>
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
							<div class="insidediv">
								<h3>Anteckning <xsl:value-of select="ca:Skapad"/>
								</h3>
								<table>
									<tr>
										<td>Händelsedatum</td>
										<td>
											<xsl:value-of select="ca:Händelsedatum"/>
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
				
				<!--Ansökningar-->
				<xsl:for-each select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Ansökningar">
					<div id="ansokningar" class="tabcontent">
						<h2>Ansökningar</h2>
						<xsl:for-each select="ca:Ansökan">
						<div class="insidediv">
							<h3>Ansökan</h3>
							<h4 class="midrubrik">Ansökningshandlingar</h4>
							<hr></hr>
							<table>
								<tbody>
									<tr>
										<th>Skickade</th>
										<td><xsl:value-of select="ca:Ansökningshandlingar/ca:Handling_skickad"/></td>
									</tr>
									<tr>
										<th>Inkom</th>
										<td><xsl:value-of select="ca:Ansökningshandlingar/ca:Handling_inkom"/></td>
									</tr>
									<tr>
										<th>Ansökan gjordes av</th>
										<td><xsl:value-of select="ca:Ansökningshandlingar/ca:Ansökan_gjordes_av"/></td>
									</tr>
									<tr>
										<th>Hur ansökan gjordes</th>
										<td><xsl:value-of select="ca:Ansökningshandlingar/ca:Hur_ansökan_gjordes"/></td>
									</tr>
									<tr>
										<th>Samtycke</th>
										<td><xsl:value-of select="ca:Samtycke/ca:Värde"/></td>
									</tr>
									<tr>
										<th>Datum för samtycke</th>
										<td><xsl:value-of select="ca:Samtycke/ca:Datum"/></td>
									</tr>
								</tbody>
							</table>
							
							<h4>Innehållet i ansökan</h4>
							<p><xsl:value-of select="ca:Innehåll"/></p>
							
							<h4>Övriga noteringar</h4>
							<p><xsl:value-of select="ca:Övrig_notering"/></p>
								
							<xsl:if test="ca:Checklista">
							<xsl:for-each select="ca:Checklista/ca:Checklistedel">
							<fieldset>
							<legend><xsl:value-of select="ca:Rubrik"/></legend>
							<xsl:for-each select="ca:Värde">
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
						<xsl:for-each select="ca:Fortsatt_ansökan">
						<div class="insidediv">
						<h3>Fortsatt ansökan</h3>
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
						<xsl:if test="ca:E-Ansökan">
							
							<h4 class="midrubrik">E-Ansökan</h4>
							<hr></hr>
								<xsl:for-each select="ca:E-Ansökan/ca:Kategori">
								<xsl:choose>
									<xsl:when test="ca:Post">
									<h4><xsl:value-of select="ca:Rubrik"/></h4>
									<xsl:for-each select="ca:Post/ca:Information">
								<table>
									<tbody>
										<tr>
											<th><xsl:value-of select="ca:Rubrik"/></th>
											<td><xsl:value-of select="ca:Värde"/><xsl:value-of select="ca:Text"/></td>
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
											<td><xsl:value-of select="ca:Värde"/><xsl:value-of select="ca:Text"/></td>
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
									<th>Komplettering åter senast</th>
									<td><xsl:value-of select="ca:Komplettering_åter_senast"/></td>
								</tr>
								<tr>
									<th>Begärda kompletteringar</th>
									<td><xsl:value-of select="ca:Begärda_kompletteringar"/></td>
								</tr>
								<tr>
									<th>Förtydligande</th>
									<td><xsl:value-of select="ca:Förtydligande"/></td>
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
				<!--Utredningar -->
				<xsl:for-each select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Utredningar">
					<div id="utredningar" class="tabcontent">
						<h2>Utredningar</h2>
						<xsl:for-each select="ca:Utredning_2">
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
							<div class="insidediv">
								<h3>Insats</h3>
								<h4>Allmän information</h4>
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
								<xsl:if test="ca:Verkställda_perioder/ca:Verkställd_period">
									<h4>Verkställda perioder</h4>
									<xsl:for-each select="ca:Verkställda_perioder/ca:Verkställd_period">
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
									<xsl:for-each select="ca:Innehåll/ca:Tjänst">
										<table>
											<tbody>
												<tr>
													<th>Tjänst</th>
													<td>
														<xsl:value-of select="ca:Namn"/>
													</td>
												</tr>
											</tbody>
										</table>
									</xsl:for-each>
								</xsl:for-each>
								<xsl:for-each select="ca:Beställning">
								<h4>Beställning</h4>
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
											<th>Tjänst</th>
											<td><xsl:value-of select="ca:Innehåll/ca:Tjänst/ca:Namn"/></td>
										</tr>
										<xsl:for-each select="ca:Information">
										<th><xsl:value-of select="ca:Rubrik"/></th>
										<td><xsl:value-of select="ca:Text"/></td>
										
										</xsl:for-each>
										<xsl:for-each select="ca:Vårdplan_uppdrag">
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
								<xsl:for-each select="ca:Insats_verkställd">
								<h4>Insats verkställd</h4>
								<table>
									<tr>
										<th>Verkställd</th>
										<th>Verkställd period</th>
										<th>Verkställd av</th>
									</tr>
									<tr>
										<td><xsl:value-of select="ca:Verkställd"/></td>
										<td><xsl:value-of select="ca:Verkställd_period"/></td>
										<td><xsl:value-of select="ca:Verkställd_av/ca:VisningsNamn"/>, <xsl:value-of select="ca:Verkställd_av/ca:Titel"/></td>
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
							<div class="insidediv">
								<h4>Bilaga <xsl:number value="position()" format="1"/>. <xsl:value-of select="ca:Namn"/>
								</h4>
								<table>
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
				
<!--Beräkningar -->
				<xsl:for-each select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Beräkningar">
					<div id="berakningar" class="tabcontent">
						<h2>Beräkningar</h2>
						
						<xsl:for-each select="ca:Beräkning">
						<div class="insidediv">
							<h3>Beräkning</h3>
							<table>
								<tbody>
									<tr>
										<th>Period</th>
										<td><xsl:value-of select="ca:Period"/></td>
									</tr>
									<tr>
										<th>Beräkningsdatum</th>
										<td><xsl:value-of select="ca:Beräkningsdatum"/></td>
									</tr>
								</tbody>
							</table>
							<h4 class="midrubrik">Personer som påverkar normen</h4>
							<hr></hr>
							<table>
								<tbody>
									<tr>
										<th>Namn</th>
										<th>Personnummer</th>
										<th>Med i norm</th>
										<th>Dagar</th>
										<th>Hushåll</th>
										<th>Dagis</th>
									</tr>
									<xsl:for-each select="ca:Personer_i_norm/ca:Person">
									<tr>
										<td><xsl:value-of select="ca:Namn"/></td>
										<td><xsl:value-of select="ca:Personnummer"/></td>
										<td><xsl:value-of select="ca:Med_i_norm"/></td>
										<td><xsl:value-of select="ca:Dagar"/></td>
										<td><xsl:value-of select="ca:Med_i_hushåll"/></td>
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
										<th>Godkända</th>
										<th>Anteckningar</th>
									</tr>
									<xsl:for-each select="ca:Utgifter/ca:Post">
									<tr>
										<td><xsl:value-of select="ca:Utgift"/></td>
										<td><xsl:value-of select="ca:Faktisk"/></td>
										<td><xsl:value-of select="ca:Godkänd"/></td>
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
									<xsl:for-each select="ca:Reducering/ca:Post">
									<tr>
										<td><xsl:value-of select="ca:Reducering"/></td>
										<td><xsl:value-of select="ca:Dagar"/></td>
										<td><xsl:value-of select="ca:Belopp"/></td>
										<td><xsl:value-of select="ca:Anteckning"/></td>
									</tr>
									</xsl:for-each>
									<tr>
										<th>Summa</th>
										<td><xsl:value-of select="ca:Reducering/ca:Summa"/></td>	
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
										<th>Gemensamma hushållskostnader</th>
									</tr>
									<xsl:for-each select="ca:Summering/ca:Gemensamma_hushållskostnader">
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
										<th>Beräkning</th>
									</tr>
									<xsl:for-each select="ca:Summering/ca:Beräkning/ca:Poster">
									<tr>
										<td><xsl:value-of select="ca:Post"/></td>
										<td><xsl:value-of select="ca:Belopp"/></td>
									</tr>
									</xsl:for-each>
									<tr>
										<td>Summa (<xsl:value-of select="ca:Summering/ca:Beräkning/ca:Summa/ca:Typ"/>)</td>
										<td><xsl:value-of select="ca:Summering/ca:Beräkning/ca:Summa/ca:Belopp"/></td>
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
										<th>Betalningssätt</th>
										<th>Belopp</th>
										<th>Moms</th>
										<th>Datum tillh.</th>
									</tr>
									<tr>
										<td><xsl:value-of select="ca:Betalningsmottagare"/></td>
										<td><xsl:value-of select="ca:Registrerad_mottagare"/></td>
										<td><xsl:value-of select="ca:Namn"/></td>
										<td><xsl:value-of select="ca:Betalningssätt"/></td>
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
