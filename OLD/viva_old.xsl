<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:ii="http://www.idainfront.se/xslt" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:ra="http://xml.ra.se/e-arkiv/FGS-ERMS" xmlns:ca="Cambio" exclude-result-prefixes="xs fn ra fo ca">
	<xsl:output indent="yes" media-type="text/xml" encoding="ISO-8859-1"/>
	<xsl:param name="documentLocation"/>
	
		<!-- v.1.0 Uppdaterat med mappning mot rätt konfiguration.-->
	
	<xsl:template match="/">
		<xsl:for-each select="/ra:Leveransobjekt/ra:ArkivobjektListaArenden/ra:ArkivobjektArende">
			<xsl:variable name="nr">
				<xsl:value-of select="ra:ArkivobjektID"/>
			</xsl:variable>
			<ii:output ii:fileName="{$nr}/doc/original.xml">
				<xsl:copy-of select="."/>
			</ii:output>
			<ii:output ii:indent="2" ii:fileName="{$nr}/Archive.xml">
				<ArchiveSip system="Viva" producer="Borås socialtjänst" xmlns:ns2="http://www.idainfront.se/schema/archive-2.0-custom" xmlns="http://www.idainfront.se/schema/archive-2.2">
					<ArchiveObject>
						
						<!-- DISPLAYNAME -->
						<DisplayName>
							<xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:ExtraID"/>
						</DisplayName>
						<ObjectType>viva_journal</ObjectType>
						
						<!-- Personnummer REGEX? format YYYYMMDD-NNNN -->
						<Attribute name="personnummer">
							<xsl:analyze-string select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Personnummer" regex="(\d{{8}})(\D?|TF)(\d{{4}}|\d{{2}})">
							<xsl:matching-substring>
							
							<Value>
								<xsl:value-of select="regex-group(1)"/><xsl:text>-</xsl:text><xsl:value-of select="regex-group(3)"/>
							</Value>
							
							</xsl:matching-substring>
							
							</xsl:analyze-string>
						</Attribute>
						
						<!-- National IDnr för e-tjänst format YYYYDDMMNNNN-->
						<Attribute name="national_identity_nr">
							<xsl:analyze-string select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Personnummer" regex="(\d{{8}})(\D?|TF)(\d{{4}}|\d{{2}})">
							<xsl:matching-substring>
							
							<Value>
								<xsl:value-of select="regex-group(1)"/><xsl:value-of select="regex-group(3)"/>
							</Value>
							
							</xsl:matching-substring>
							</xsl:analyze-string>					
						</Attribute>
						

						<!-- Förnamn -->
						<Attribute name="fornamn">
							<Value>
								<xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Förnamn"/>
							</Value>
						</Attribute>
						
						<!-- Efternamn -->
						<Attribute name="efternamn">
							<Value>
								<xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Efternamn"/>
							</Value>
						</Attribute>
						
						<!-- Ärendenummer -->
						<Attribute name="diarienummer">
							<Value>
								<xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:ExtraID"/>
							</Value>
						</Attribute>
						
						<!-- Ärendemening -->
						<Attribute name="arendemening">
							<Value>
								<xsl:value-of select="ra:Arendemening"/>
							</Value>
						</Attribute>
						
						<!-- Ärendetyp -->
						<Attribute name="arendetyp">
							<Value>
								<xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Arendetyp"/>
							</Value>
						</Attribute>

						<!-- Handläggare -->
						<Attribute name="roll_handlaggare">
							<Value>
								<xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handläggning/ca:Handläggare/ca:VisningsNamn"/>
							</Value>
						</Attribute>
						
						<!-- Enhet -->
						<Attribute name="enhet">
							<Value>
								<xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handläggning/ca:Enhet"/>
							</Value>
						</Attribute>
						
						<!-- TEAM -->
						<Attribute name="grupp">
							<Value>
								<xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handläggning/ca:Team"/>
							</Value>
						</Attribute>

						<!-- Registreringsdatum -->
						<Attribute name="registrerat_datum">
							<Value>
								<xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Skapad"/>
							</Value>
						</Attribute>
						
						<!-- Ärendestart -->
						<Attribute name="arendestart_datum">
							<Value>
								<xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Öppnad"/>
							</Value>
						</Attribute>
						
						<!-- Förvaringsplats -->
						<Attribute name="forvaringsplats">
							<xsl:choose>
								<xsl:when test="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Pappersakt">
									<Value>
										<xsl:text>Analog/digital</xsl:text>
									</Value>
								</xsl:when>
								
								<xsl:otherwise>
								<Value>
										<xsl:text>Digital</xsl:text>
								</Value>
								
								</xsl:otherwise>
							</xsl:choose>
						</Attribute>

						<!-- Sekretess -->
						<Attribute name="secrecy">
							<Value>20</Value>
						</Attribute>
						
						<!-- Personuppgiftsklassning -->
						<Attribute name="pul_personal_secrecy">
							<Value>20</Value>
						</Attribute>
						
						<!-- Övrigt skydd -->
						<Attribute name="other_secrecy">
							<Value>20</Value>
						</Attribute>
						
						<xsl:for-each select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Bilagor/ca:Bilaga">
							<Document>
								<!-- Displayname + numrering för att undvika problem med liknande filnamn -->
								<DisplayName>
									<xsl:number value="position()" format="1"/>
									<xsl:text>. </xsl:text>
									<xsl:value-of select="ca:Namn"/>
								</DisplayName>
								<ObjectType>viva_handling</ObjectType>
								
								<!-- Registreringsdatum -->
								<Attribute name="registrerat_datum">
									<Value>
										<xsl:value-of select="ca:Skapad"/>
									</Value>
								</Attribute>

								<!-- Registrerat av-->
								<Attribute name="registrerat_av">
									<Value>
										<xsl:value-of select="ca:Skapad_av/ca:VisningsNamn"/>
									</Value>
								</Attribute>
								
								<!-- Handlingstyp-->
								<Attribute name="handling_typ">
									<Value>
										<xsl:value-of select="ca:Referenser/ca:Referens/ca:Typ"/>
									</Value>
								</Attribute>
								

								<!-- Sekretess -->
								<Attribute name="secrecy">
									<Value>20</Value>
								</Attribute>
								<!-- Personuppgiftsklassning -->
								<Attribute name="pul_personal_secrecy">
									<Value>20</Value>
								</Attribute>
								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy">
									<Value>20</Value>
								</Attribute>
								<File>
									<DisplayName>
										<xsl:value-of select="ca:Filnamn"/>
									</DisplayName>
									<Content>
										<xsl:variable name="removews">
											<xsl:value-of select="fn:normalize-space(ca:Länk)"/>
										</xsl:variable>
										<URI>
											<xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($removews)"/>
										</URI>
									</Content>
									<!-- Sekretess -->
									<Attribute name="secrecy">
										<Value>20</Value>
									</Attribute>
									<!-- Personuppgiftsklassning -->
									<Attribute name="pul_personal_secrecy">
										<Value>20</Value>
									</Attribute>
									<!-- Övrigt skydd -->
									<Attribute name="other_secrecy">
										<Value>20</Value>
									</Attribute>
								</File>
							</Document>
						</xsl:for-each>
						<Document>
							<DisplayName>original.xml</DisplayName>
							<ObjectType>xml_document</ObjectType>
							<!-- Sekretess -->
							<Attribute name="secrecy">
								<Value>20</Value>
							</Attribute>
							<!-- Personuppgiftsklassning -->
							<Attribute name="pul_personal_secrecy">
								<Value>20</Value>
							</Attribute>
							<!-- Övrigt skydd -->
							<Attribute name="other_secrecy">
								<Value>20</Value>
							</Attribute>
							<File>
								<DisplayName>original.xml</DisplayName>
								<Content>
									<URI>./doc/original.xml</URI>
								</Content>
								<Attribute name="stylesheet">
									<Value>VIVA</Value>
								</Attribute>
								<!-- Sekretess -->
								<Attribute name="secrecy">
									<Value>20</Value>
								</Attribute>
								<!-- Personuppgiftsklassning -->
								<Attribute name="pul_personal_secrecy">
									<Value>20</Value>
								</Attribute>
								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy">
									<Value>20</Value>
								</Attribute>
							</File>
						</Document>
					</ArchiveObject>
				</ArchiveSip>
			</ii:output>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
