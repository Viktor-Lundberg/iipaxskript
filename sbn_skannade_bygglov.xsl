<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:ii="http://www.idainfront.se/xslt" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output indent="yes" media-type="text/xml" encoding="ISO-8859-1"/>

	<!-- Scriptet letar efter filer i adapterns utpekade documentLocation  -->
	
	<xsl:param name="documentLocation"/>
	
<!-- Börja i rotnoden i xml-filen -->
	
	<xsl:template match="/">

		<!-- Splittar varje elev till en egen SIP -->
		
		<xsl:for-each select="//bygglov">

		<!-- Skapar en variabel som medför att varje gång vi skriver $pnr så hämtar scriptet värdet i personnummer -->

			<xsl:variable name="pnr" select="normalize-space(ID)"/>
		
			
			<!-- Skapar en mapp på servern -->
				
			<ii:output ii:indent="2" ii:fileName="{$pnr}/Archive.xml">

				<!-- Skapar iipaxSIP, system och producent -->
				
				<ArchiveSip system="Inskannat material" producer="Samhällsbyggnadsnämnden" xmlns:ns2="http://www.idainfront.se/schema/archive-2.0-custom" xmlns="http://www.idainfront.se/schema/archive-2.2">
					
					<ArchiveObject>
						
					<!-- Använder ID som displayname-->
						
						<DisplayName><xsl:value-of select="displayname"/></DisplayName>
									
								
						
						<ObjectType>skannade_bygglov</ObjectType>

						
						<xsl:if test="normalize-space(arendemening) != ''">
							<Attribute name="arendemening">
								<Value>
									<xsl:value-of select="normalize-space(arendemening)"/>
								</Value>
							</Attribute>
						</xsl:if>
						
						
						<xsl:if test="normalize-space(arendestart) != ''">
							<Attribute name="arendestart_datum">
								<Value>
									<xsl:value-of select="normalize-space(arendestart)"/>
								</Value>
							</Attribute>
						</xsl:if>
					
						
						<xsl:if test="normalize-space(arendeslut) != ''">
							<Attribute name="avslutat_datum">
								<Value>
									<xsl:value-of select="normalize-space(arendeslut)"/>
								</Value>
							</Attribute>
						</xsl:if>
						
						<!-- Anger elevens Skola -->
						<xsl:if test="normalize-space(beslutsdatum) != ''">
							<Attribute name="beslutsdatum">
								<Value>
									<xsl:value-of select="normalize-space(beslutsdatum)"/>
								</Value>
							</Attribute>
						</xsl:if>
						
						<!-- Anger huvudmannaskap för skolan -->
						<xsl:if test="normalize-space(beslutsnummer) != ''">
							<Attribute name="beslutsnummer">
								<Value>
									<xsl:value-of select="normalize-space(beslutsnummer)"/>
								</Value>
							</Attribute>
						</xsl:if>
						
						
							<Attribute name="anteckningar">
								<Value>
									<xsl:text>Ankomstdatum har vid arkiveringen satts till år för beslutsdatum följt av -01-01 och ärendeavslut har satts till året för ärendestart följt av -12-31.</xsl:text>
								</Value>
							</Attribute>
					
						<Attribute name="fastighetsbeteckning">			
							<xsl:for-each select="fastigheter/fastighet">
								<Value><xsl:value-of select="."/></Value>
							</xsl:for-each>	
						</Attribute>						
						
						<xsl:for-each select="fastighetsinformation_ovrig">
							<xsl:if test= "normalize-space(rad[1]) != ''">
								<Attribute name="fastighetsinformation">
									<xsl:for-each select="rad">
										<Value><xsl:value-of select="."/></Value>
									</xsl:for-each>
								</Attribute>
							</xsl:if>
						</xsl:for-each>
							
						
						<Attribute name="secrecy">
							<Value>0</Value>
						</Attribute>

						<!-- PUL -->
						<Attribute name="pul_personal_secrecy">
							<Value>0</Value>
						</Attribute>

						<!-- Övrigt skydd -->
						<Attribute name="other_secrecy">
							<Value>0</Value>
						</Attribute>

<xsl:for-each select="handlingar/handling">							
						<!-- Skapar ett Document som heter Slutbetyg vilket blir DisplayName -->
						<Document>
							<DisplayName>
							<xsl:value-of select="displayname"/>
							</DisplayName>
							<ObjectType>skannade_bygglov_handling</ObjectType>
						
						<!-- Typ av handling -->
						<xsl:if test="normalize-space(handlingstyp) != ''">
							<Attribute name="handling_typ">
								<Value>
									<xsl:value-of select="normalize-space(handlingstyp)"/>
								</Value>
							</Attribute>
						</xsl:if>
						

							<!-- Sekretess -->
							<Attribute name="secrecy">
								<Value>0</Value>
							</Attribute>

							<!-- PUL -->
							<Attribute name="pul_personal_secrecy">
								<Value><xsl:value-of select="personuppgiftsklassning"/></Value>
							</Attribute>

							<!-- Övrigt skydd -->
							<Attribute name="other_secrecy">
								<Value>0</Value>
							</Attribute>

								
							<!-- Hämtar filer som är en del av den medicinska elevhälsans journal.-->
							<File>

								<DisplayName><xsl:value-of select="filnamn"/></DisplayName>

								<!-- Sekretess -->
								<Attribute name="secrecy">
									<Value>0</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy">
									<Value>0</Value>
								</Attribute>

								
								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy">
									<Value>0</Value>
								</Attribute>

								<!-- Här pekar vi ut den bifogade filen -->
								<Content>

									<URI>	
										<xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri(filnamn)"/>
										
									</URI>
								</Content>

								
							</File>
							
							</Document>	
</xsl:for-each>
											</ArchiveObject>

				</ArchiveSip>

			</ii:output>

		</xsl:for-each>

	</xsl:template>
</xsl:stylesheet>
