<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:ii="http://www.idainfront.se/xslt" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

	<xsl:output indent="yes" media-type="text/xml" encoding="ISO-8859-1"/>

	<!-- Scriptet letar efter filer i adapterns utpekade documentLocation  -->
	
	<xsl:param name="documentLocation"/>

	<!-- Börja i rotnoden i xml-filen -->
	
	<xsl:template match="/">

		<!-- Varje gång elementet SAMMANTRÄDE återfinns i filen gör scriptet nedanstående  -->
		
		<xsl:for-each select="LEVERANS">
		<!-- Skapar en variabler-->

			<xsl:variable name="dnr" select="SAMMANTRADESDATUM"/>
			<xsl:variable name="producent" select="NAMND"/>
			

			<!-- Skapa en kopia av hela xml-filen -->
			<ii:output ii:fileName="{$dnr}/doc/original.xml">
				<xsl:copy-of select="."/>
			</ii:output>
			
			<!-- Skapar en mapp på servern -->
				
			<ii:output ii:indent="2" ii:fileName="{$dnr}/Archive.xml">

				<!-- Skapar iipaxSIP -->
				
				<ArchiveSip system="Webbsändning" producer="{$producent}" xmlns:ns2="http://www.idainfront.se/schema/archive-2.0-custom" xmlns="http://www.idainfront.se/schema/archive-2.2">

					<!-- Hämta huvudobjektet enligt objektkonfigurationen och vad som ska visas i display_name -->
					
					<ArchiveObject>
						<DisplayName><xsl:value-of select="$producent"/><xsl:text>s sammanträde </xsl:text><xsl:value-of select="$dnr"/>
						</DisplayName>
						<ObjectType>webbsandning</ObjectType>

						<!-- Anger vilken nämnd som sammanträdet rör OBS! endast testmappning mot lis_arende -->
						<xsl:if test="normalize-space(NAMND) != ''">
							<Attribute name="namnd">
								<Value>
									<xsl:value-of select="normalize-space(NAMND)"/>
								</Value>
							</Attribute>
						</xsl:if>
						
						<!-- Anger antal besökare sammanträdet rör OBS! endast testmappning mot lis_arende -->
						<xsl:if test="normalize-space(SAMMANTRADESDATUM) != ''">
							<Attribute name="sammantradesdatum">
								<Value>
									<xsl:value-of select="normalize-space(SAMMANTRADESDATUM)"/>
								</Value>
							</Attribute>
						</xsl:if>
						
						<!-- Anger beskrivning OBS! endast testmappning mot lis_arende -->
						<xsl:if test="normalize-space(BESKRIVNING) != ''">
							<Attribute name="beskrivning">
								<Value>
									<xsl:value-of select="normalize-space(BESKRIVNING)"/>
								</Value>
							</Attribute>
						</xsl:if>
						
						<xsl:if test="fn:normalize-space(HANDLINGSTYP)">
						<Attribute name="handling_typ">
							<Value><xsl:value-of select="HANDLINGSTYP"/></Value>
						</Attribute>
						</xsl:if>

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
<xsl:for-each select="OBJEKT">

							
						<!-- Talar om vad den ska mappa mot i objektkonfigurationen och vad som ska stå vid display_name här är det KAPITELNAMN under KAPITEL -->
						<Document>
							
							<xsl:analyze-string select="NAME" regex="(.+)(\..+$)">
							<xsl:matching-substring>
							<DisplayName>
								<xsl:value-of select="regex-group(1)"/>
							</DisplayName>
							</xsl:matching-substring>
							</xsl:analyze-string>
							<ObjectType>webbsandning_avsnitt</ObjectType>

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

								
							<!-- Här går vi ner till nivån för filen och vad som ska stå som display_name, i detta fall filnamnet under FIL -->
							<File>

								<DisplayName>
								<xsl:value-of select="NAME"/>	
									</DisplayName>

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

								<!-- Här pekar vi ut den bifogade filen, den ligger i mappen kommunhfiler samt tar filnamnet från elementet NAME-->
								<Content>

								<xsl:variable name="uri"><xsl:value-of select="URI"/>/<xsl:value-of select="NAME"/></xsl:variable>	
								<URI>	
										<xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($uri)"/>
										
									</URI>
								</Content>

								
							</File>
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

							<!-- Övrigt skydd -->
							<Attribute name="other_secrecy">
								<Value>0</Value>
							</Attribute>

							<File>

								<DisplayName>original.xml</DisplayName>
								<Content>

									<URI>./doc/original.xml</URI>

								</Content>

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

							</File>

						</Document>
					
					</ArchiveObject>

				</ArchiveSip>

			</ii:output>

		</xsl:for-each>

	</xsl:template>
</xsl:stylesheet>
