<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:ii="http://www.idainfront.se/xslt" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output indent="yes" media-type="text/xml" encoding="ISO-8859-1"/>

	<!-- Scriptet letar efter filer i adapterns utpekade documentLocation  -->
	
	<xsl:param name="documentLocation"/>
	
<!-- Börja i rotnoden i xml-filen -->
	
	<xsl:template match="/">

		<!-- Splittar varje elev till en egen SIP -->
		
		<xsl:for-each select="//betygskatalog">

		<!-- Skapar en variabel som medför att varje gång vi skriver $pnr så hämtar scriptet värdet i personnummer -->
				
		

			<xsl:variable name="pnr" select="normalize-space(tid)"/>
			
			<ii:output ii:fileName="{$pnr}/doc/original.xml">
			<xsl:copy-of select="."/>
						
			</ii:output>
		
			
			<!-- Skapar en mapp på servern -->
				
			<ii:output ii:indent="2" ii:fileName="{$pnr}/Archive.xml">

				<!-- Skapar iipaxSIP, system och producent -->
				
				<ArchiveSip system="Betygskatalog" producer="JB Gymnasiet i Borås" xmlns:ns2="http://www.idainfront.se/schema/archive-2.0-custom" xmlns="http://www.idainfront.se/schema/archive-2.2">
					
					<ArchiveObject>
						
					<!-- Använder ID som displayname-->
						
						<DisplayName><xsl:value-of select="handlingstyp"/><xsl:text> </xsl:text><xsl:value-of select="$pnr"/>, <xsl:value-of select="skola"/></DisplayName>
									
								
						
						<ObjectType>betygskatalog_fil</ObjectType>

						
						<xsl:if test="normalize-space(handlingstyp) != ''">
							<Attribute name="handling_typ">
								<Value>
									<xsl:value-of select="normalize-space(handlingstyp)"/>
								</Value>
							</Attribute>
						</xsl:if>
						
						
						<xsl:if test="normalize-space(skola) != ''">
							<Attribute name="skola">
								<Value>
									<xsl:value-of select="normalize-space(skola)"/>
								</Value>
							</Attribute>
						</xsl:if>
					
						
						<xsl:if test="normalize-space(huvudmannaskap) != ''">
							<Attribute name="huvudmannaskap">
								<Value>
									<xsl:value-of select="normalize-space(huvudmannaskap)"/>
								</Value>
							</Attribute>
						</xsl:if>
						
						<!-- Anger elevens Skola -->
						<xsl:if test="normalize-space(utbildningsniva) != ''">
							<Attribute name="utbildningsniva">
								<Value>
									<xsl:value-of select="normalize-space(utbildningsniva)"/>
								</Value>
							</Attribute>
						</xsl:if>
						
						<!-- Anger huvudmannaskap för skolan -->
						<xsl:if test="normalize-space(tid) != ''">
							<Attribute name="tid">
								<Value>
									<xsl:value-of select="normalize-space(tid)"/>
								</Value>
							</Attribute>
						</xsl:if>
						
						
							<Attribute name="anteckningar">
								<Value>
									
								</Value>
							</Attribute>
					
						
							
						
						<Attribute name="secrecy">
							<Value>0</Value>
						</Attribute>

						<!-- PUL -->
						<Attribute name="pul_personal_secrecy">
							<Value>10</Value>
						</Attribute>

						<!-- Övrigt skydd -->
						<Attribute name="other_secrecy">
							<Value>20</Value>
						</Attribute>


								
							<!-- Hämtar filer som är en del av den medicinska elevhälsans journal.-->
							<File>

								<DisplayName><xsl:value-of select="fil"/></DisplayName>

								<!-- Sekretess -->
								<Attribute name="secrecy">
									<Value>0</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy">
									<Value>10</Value>
								</Attribute>

								
								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy">
									<Value>20</Value>
								</Attribute>

								<!-- Här pekar vi ut den bifogade filen -->
								<Content>

									<URI>	
										<xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri(fil)"/>
										
									</URI>
								</Content>

								
							</File>
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
									<Value>10</Value>
								</Attribute>

								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy">
									<Value>20</Value>
								</Attribute>

							</File>

							
											</ArchiveObject>

				</ArchiveSip>

			</ii:output>

		</xsl:for-each>

	</xsl:template>
</xsl:stylesheet>
