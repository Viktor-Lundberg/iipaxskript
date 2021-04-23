<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:fgs="eARDERMS" xmlns:ii="http://www.idainfront.se/xslt" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"  exclude-result-prefixes="xs fn fgs">
	
	<xsl:output indent="yes" media-type="text/xml" encoding="ISO-8859-1"/>
		
		<!-- 
		v. 1.0 = Skriptet upprättat
		v. 1.1 = Tagit bort choose på "riktning" då nya e-arkivkonfigurationen nu tar alla värden som systemet genererar.
		-->
	
	
	<xsl:param name="documentLocation"/>
	

	
	<xsl:template match="/">

		
		
		<xsl:for-each select="//fgs:ArkivobjektArende">

		<xsl:variable name="dnr">
		<xsl:analyze-string regex="\w+/(\d{{4}})(\d{{5}})" select="fgs:ArkivobjektID">
		<xsl:matching-substring><xsl:value-of select="regex-group(1)"/>-<xsl:value-of select="regex-group(2)"/>
		</xsl:matching-substring>
		<xsl:non-matching-substring>
		<xsl:text>ERROR RETURNED EMPTY STRING</xsl:text>
		</xsl:non-matching-substring>
		
		</xsl:analyze-string></xsl:variable>

			<xsl:variable name="identifier" select="normalize-space(fgs:ArkivobjektID)"/>
	
			

			<ii:output ii:fileName="{$dnr}/doc/original.xml">
				<xsl:copy-of select="."/>
			</ii:output>
			
			
				
			<ii:output ii:indent="2" ii:fileName="{$dnr}/Archive.xml">

				
				
				<ArchiveSip system="Ciceron" producer="Kommunstyrelsen" xmlns:ns2="http://www.idainfront.se/schema/archive-2.0-custom" xmlns="http://www.idainfront.se/schema/archive-2.2">
					
					<ArchiveObject>
						
					
					
							<DisplayName><xsl:value-of select="$dnr"/><xsl:text> </xsl:text><xsl:value-of select="fgs:Arendemening"/></DisplayName>
					
					
						
						<ObjectType>ciceron_arende</ObjectType>
				
				<Attribute name="diarienummer">
					<Value><xsl:value-of select="$dnr"/></Value>				
				</Attribute>
				
				<Attribute name="diarieplanbeteckning">
					<Value><xsl:value-of select="fn:normalize-space(fn:substring-after(fgs:Klass,','))"/></Value>				
				</Attribute>
				
				<Attribute name="arendemening">
					<Value><xsl:value-of select="fn:normalize-space(fgs:Arendemening)"/></Value>				
				</Attribute>
				
				<Attribute name="arendestart_datum">
					<Value><xsl:value-of select="fgs:Inkommen"/></Value>
				</Attribute>
				
				<Attribute name="arandetyp">
					<Value><xsl:value-of select="fn:normalize-space(fn:substring-after(fgs:ArendeTyp,','))"/></Value>
				</Attribute>
				
				<xsl:for-each select="fgs:Motpart/fgs:Namn">
				<xsl:if test="normalize-space(fgs:Motpart/fgs:Namn) != ''">
					<Attribute name="motpart">
						<Value><xsl:value-of select="normalize-space(fgs:Motpart/fgs:Namn)"/></Value>
					</Attribute>
				</xsl:if>
				</xsl:for-each>
				
				<xsl:for-each select="fgs:EgnaElement/fgs:EgetElement[@Namn='Motpart diarienummer']">
					<xsl:if test="fgs:Varde !=''">
						<Attribute name="motpart_diarienummer">
							<Value><xsl:value-of select="normalize-space(fgs:Varde)"/></Value>
						</Attribute>
					</xsl:if>
				</xsl:for-each>
				
				<xsl:for-each select="fgs:EgnaElement/fgs:EgetElement[@Namn='Enhet']">
					<xsl:if test="fgs:Varde !=''">
						<Attribute name="enhet">
							<Value><xsl:value-of select="normalize-space(fgs:Varde)"/></Value>
						</Attribute>
					</xsl:if>
				</xsl:for-each>
				
				<xsl:for-each select="fgs:EgnaElement/fgs:EgetElement[@Namn='Programområde']">
					<xsl:if test="fgs:Varde !=''">
						<Attribute name="huvudobjekt">
							<Value><xsl:value-of select="normalize-space(fgs:Varde)"/></Value>
						</Attribute>
					</xsl:if>
				</xsl:for-each>
				
				<xsl:for-each select="fgs:EgnaElement/fgs:EgetElement[@Namn='Samband']">
					<xsl:if test="fgs:Varde !=''">
						<Attribute name="Samband">
							<Value><xsl:value-of select="normalize-space(fgs:Varde)"/></Value>
						</Attribute>
					</xsl:if>
				</xsl:for-each>
				
				
				<xsl:for-each select="fgs:EgnaElement/fgs:EgetElement[@Namn='Förvaringsplats']">
					<xsl:if test="fgs:Varde !=''">
						<Attribute name="forvaringsplats">
							<Value><xsl:value-of select="normalize-space(fgs:Varde)"/></Value>
						</Attribute>
					</xsl:if>
				</xsl:for-each>
				
				<xsl:for-each select="fgs:EgnaElement/fgs:EgetElement[@Namn='Avslutsorsak']">
					<xsl:if test="fgs:Varde !=''">
						<Attribute name="avslutat_orsak">
							<Value><xsl:value-of select="normalize-space(fgs:Varde)"/></Value>
						</Attribute>
					</xsl:if>
				</xsl:for-each>
				
				<xsl:for-each select="fgs:EgnaElement/fgs:EgetElement[@Namn='Makulering']">
					<xsl:if test="fgs:Varde !=''">
						<Attribute name="makulerad">
							<Value><xsl:value-of select="normalize-space(fgs:Varde)"/></Value>
						</Attribute>
					</xsl:if>
				</xsl:for-each>
				
				<xsl:if test="fgs:Avslutat[text()]">
				<Attribute name="avslutat_datum">
					<Value><xsl:value-of select="fgs:Avslutat"/></Value>
				</Attribute>
				</xsl:if>
				
				<xsl:for-each select="fgs:Agent/fgs:Roll[fn:contains(.,'Registrator')]">
						<Attribute name="registrerat_av">
							<Value><xsl:value-of select="normalize-space(following-sibling::fgs:Namn)"/></Value>
						</Attribute>
				</xsl:for-each>
				
				
				<xsl:if test="fgs:Skapad[text()]">
				<Attribute name="registrerat_datum">
					<Value><xsl:value-of select="fgs:Skapad"/></Value>
				</Attribute>
				</xsl:if>
				
			
				<xsl:for-each select="fgs:Agent/fgs:Roll[fn:contains(.,'Handläggare')]">
					<Attribute name="roll_handlaggare">
					<Value><xsl:value-of select="normalize-space(following-sibling::fgs:Namn)"/></Value>
					</Attribute>
				</xsl:for-each>
				
				
				<Attribute name="secrecy">
								<Value>
									<xsl:choose>
									<xsl:when test="fgs:Restriktion/attribute(Typ)='Sekretess'">10</xsl:when>
									<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</Value>
				</Attribute>	
				
				
				<xsl:if test="fgs:Restriktion/fgs:Lagrum !=''">
				<Attribute name="sekretess_lagrum">
				<Value><xsl:value-of select="fgs:Restriktion/fgs:Lagrum"/></Value>
				</Attribute>
				</xsl:if>
				
				<Attribute name="pul_personal_secrecy">
				<Value>0</Value>
				</Attribute>
				
				<Attribute name="other_secrecy">
									<Value>0</Value>
								</Attribute>
				
				
				
		
		<xsl:for-each select="fgs:ArkivobjektListaHandlingar/fgs:ArkivobjektHandling">
		
	<Document>
		
		<ObjectType>Ciceron_handling</ObjectType>
		
		<xsl:variable name="lopnummer"><xsl:value-of select="fgs:Lopnummer"/></xsl:variable>
		<xsl:choose>
			
		
		<xsl:when test="fgs:StatusHandling[fn:contains(.,'Inkommen')]">
			<xsl:analyze-string regex="(^\d{{1,3}}?\.)(.*)" select="fgs:Beskrivning">
				<xsl:matching-substring>
					<DisplayName><xsl:value-of select="$lopnummer"/><xsl:text>. </xsl:text><xsl:value-of select="normalize-space(regex-group(2))"/></DisplayName>
		
		
				</xsl:matching-substring>
		
		
			<xsl:non-matching-substring>
				<DisplayName><xsl:value-of select="$lopnummer"/><xsl:text>. </xsl:text><xsl:value-of select="normalize-space(.)"/></DisplayName>
	
			</xsl:non-matching-substring>
							

			</xsl:analyze-string>		
		
		</xsl:when>
		
		<xsl:otherwise>
		
		<DisplayName><xsl:value-of select="$lopnummer"/><xsl:text>. </xsl:text><xsl:value-of select="normalize-space(fgs:Beskrivning)"/></DisplayName>
		</xsl:otherwise>
		
		</xsl:choose>
		
		
		
		<Attribute name="riktning">
				<Value><xsl:value-of select="normalize-space(fgs:StatusHandling)"/></Value>				
		</Attribute>
		
		<Attribute name="registrerat_datum">
				<Value><xsl:value-of select="fgs:Skapad"/></Value>
		</Attribute>
		
		<xsl:for-each select="fgs:Agent/fgs:Roll[fn:contains(.,'Registrator')]">
						<Attribute name="registrerat_av">
							<Value><xsl:value-of select="normalize-space(following-sibling::fgs:Namn)"/></Value>
						</Attribute>
		</xsl:for-each>
		
		<xsl:if test="fgs:Avsandare[element()]">
			<Attribute name="avsandare">
				<Value><xsl:value-of select="fgs:Avsandare/fgs:Namn"/></Value>
			</Attribute>
		</xsl:if>
		
		<xsl:if test="fgs:Mottagare[element()]">
			<Attribute name="mottagare">
				<Value><xsl:value-of select="fgs:Mottagare/fgs:Namn"/></Value>
			</Attribute>
		</xsl:if>
		
		
		<!-- FINNS ALLTID? VARFÖR -->
		<xsl:if test="fgs:Inkommen[text()]">
			<Attribute name="inkom">
				<Value><xsl:value-of select="fgs:Inkommen"/></Value>
			</Attribute>
		</xsl:if>
		
		<xsl:for-each select="fgs:Agent/fgs:Roll[fn:contains(.,'Handläggare')]">
			<Attribute name="roll_handlaggare">
				<Value><xsl:value-of select="normalize-space(following-sibling::fgs:Namn)"/></Value>
			</Attribute>
		</xsl:for-each>
		
		
		<Attribute name="handling_typ">
				<Value><xsl:value-of select="normalize-space(fn:substring-after(fgs:Handlingstyp, ','))"/></Value>
		</Attribute>
		
		<Attribute name="lopnummer">
				<Value><xsl:value-of select="normalize-space($lopnummer)"/></Value>
		</Attribute>
		
		<Attribute name="secrecy">
								<Value>
									<xsl:choose>
									<xsl:when test="fgs:Restriktion/attribute(Typ)='Sekretess'">10</xsl:when>
									<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</Value>
		</Attribute>		
		
		<xsl:if test="fgs:Restriktion/attribute(Typ)='Sekretess'">
		<Attribute name="sekretess_lagrum">
			<Value><xsl:value-of select="fgs:Restriktion/fgs:Lagrum"/></Value>
		</Attribute>
		</xsl:if>				
				
				
		<Attribute name="pul_personal_secrecy">
								<Value>
									<xsl:choose>
									<xsl:when test="fgs:Mottagare/fgs:SkyddadIdentitet = true()">20</xsl:when>
									<xsl:when test="fgs:Avsandare/fgs:SkyddadIdentitet = true()">20</xsl:when>
									<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</Value>
		</Attribute>		
			<!--	
				<Attribute name="pul_personal_secrecy">
				<Value>0</Value>
				</Attribute>
				-->
				<Attribute name="other_secrecy">
									<Value>0</Value>
								</Attribute>
				
				
				
		<xsl:for-each select="fgs:Bilaga">
			
			<xsl:variable name="realfile">
				<xsl:analyze-string regex="([\w|\s|_]+\..*$)" select="@Lank">
					<xsl:matching-substring><xsl:value-of select="regex-group(1)"/></xsl:matching-substring>
				</xsl:analyze-string>
			</xsl:variable>
							
				<File>
					<DisplayName><xsl:number value="position()" format="1"/><xsl:text>. </xsl:text><xsl:value-of select="$realfile"/></DisplayName>
								
						<Content>
							<URI><xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri(@Lank)"/></URI>
						</Content>

					<Attribute name="secrecy">
						<Value>0</Value>
					</Attribute>

					<Attribute name="pul_personal_secrecy">
						<Value>0</Value>
					</Attribute>
					
					<Attribute name="other_secrecy">
									<Value>0</Value>
								</Attribute>

					

				</File>
		
		
		
		</xsl:for-each>		
		
		
	</Document>
	
	
		
		</xsl:for-each>
		<Document>

							<DisplayName>original.xml</DisplayName>

							<ObjectType>xml_document</ObjectType>

							<!-- Sekretess -->
							<Attribute name="secrecy">
								<Value>0</Value>
							</Attribute>

							<!-- PUL -->
							<Attribute name="pul_personal_secrecy">
								<Value>0</Value>
							</Attribute>
					
							
							<Attribute name="other_secrecy">
									<Value>0</Value>
								</Attribute> 
							

							<File>

								<DisplayName>original.xml</DisplayName>
								
								
								<Content>

									<URI>./doc/original.xml</URI>

								</Content>

								<Attribute name="stylesheet">
							  <Value></Value>
							</Attribute>

								<!-- Sekretess -->
								<Attribute name="secrecy">
									<Value>0</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy">
									<Value>0</Value>
								</Attribute>

								<Attribute name="other_secrecy">
									<Value>0</Value>
								</Attribute>
								
							</File>

						</Document>
				

					</ArchiveObject>

				</ArchiveSip>

			</ii:output>

		</xsl:for-each>

	</xsl:template>
</xsl:stylesheet>
