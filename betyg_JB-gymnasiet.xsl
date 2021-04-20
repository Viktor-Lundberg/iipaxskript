<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:ii="http://www.idainfront.se/xslt" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output indent="yes" media-type="text/xml" encoding="ISO-8859-1"/>

	<!-- Scriptet letar efter filer i adapterns utpekade documentLocation  -->
	
	<xsl:param name="documentLocation"/>
	
<!-- Börja i rotnoden i xml-filen -->
	
	<xsl:template match="/">

		<!-- Splittar varje elev till en egen SIP -->
		
		<xsl:for-each select="//betygsobjekt">

		<!-- Skapar en variabel som medför att varje gång vi skriver $pnr så hämtar scriptet värdet i personnummer -->

			<xsl:variable name="pnr" select="normalize-space(elevinformation/personnummer)"/>
		

			<!-- Skapa en kopia av xml-filen filen för varje elev  -->
			<ii:output ii:fileName="{$pnr}/doc/{$pnr}.xml">
				<xsl:copy-of select="."/>
			</ii:output>
			
			<!-- Skapar en mapp på servern -->
				
			<ii:output ii:indent="2" ii:fileName="{$pnr}/Archive.xml">

				<!-- Skapar iipaxSIP, system och producent -->
				
				<ArchiveSip system="Betyg" producer="JB Gymnasiet i Borås" xmlns:ns2="http://www.idainfront.se/schema/archive-2.0-custom" xmlns="http://www.idainfront.se/schema/archive-2.2">
					
					<ArchiveObject>
						
					<!-- Använder ID som displayname-->
						
									<DisplayName><xsl:value-of select="id"/></DisplayName>
									
								
						
						<ObjectType>betyg_elev</ObjectType>

						<!-- Anger elevens Personnummer -->
						<xsl:if test="normalize-space(elevinformation/personnummer) != ''">
							<Attribute name="personnummer">
								<Value>
									<xsl:value-of select="normalize-space(elevinformation/personnummer)"/>
								</Value>
							</Attribute>
						</xsl:if>
						
						<!-- Anger elevens Förnamn -->
						<xsl:if test="normalize-space(elevinformation/fornamn) != ''">
							<Attribute name="fornamn">
								<Value>
									<xsl:value-of select="normalize-space(elevinformation/fornamn)"/>
								</Value>
							</Attribute>
						</xsl:if>
					
						<!-- Anger elevens Efternamn -->
						<xsl:if test="normalize-space(elevinformation/efternamn) != ''">
							<Attribute name="efternamn">
								<Value>
									<xsl:value-of select="normalize-space(elevinformation/efternamn)"/>
								</Value>
							</Attribute>
						</xsl:if>
						
						<!-- Anger elevens Skola -->
						<xsl:if test="normalize-space(utbildningsinformation/skolnamn) != ''">
							<Attribute name="skola">
								<Value>
									<xsl:value-of select="normalize-space(utbildningsinformation/skolnamn)"/>
								</Value>
							</Attribute>
						</xsl:if>
						
						<!-- Anger huvudmannaskap för skolan -->
						<xsl:if test="normalize-space(utbildningsinformation/huvudmannaskap) != ''">
							<Attribute name="huvudmannaskap">
								<Value>
									<xsl:value-of select="normalize-space(utbildningsinformation/huvudmannaskap)"/>
								</Value>
							</Attribute>
						</xsl:if>
						<!-- Anger utbildningsnivå för skolan -->
						<xsl:if test="normalize-space(utbildningsinformation/utbildningsniva) != ''">
							<Attribute name="utbildningsniva">
								<Value>
									<xsl:value-of select="normalize-space(utbildningsinformation/utbildningsniva)"/>
								</Value>
							</Attribute>
						</xsl:if>					
						<!-- Anger Program/linje -->
						<xsl:if test="normalize-space(utbildningsinformation/program_linje) != ''">
							<Attribute name="program_linje">
								<Value>
									<xsl:value-of select="normalize-space(utbildningsinformation/program_linje)"/>
								</Value>
							</Attribute>
						</xsl:if>		
						<!-- Anger årskurs -->
						<xsl:if test="normalize-space(utbildningsinformation/arskurs) != ''">
							<Attribute name="arskurs">
								<Value>
									<xsl:value-of select="normalize-space(utbildningsinformation/arskurs)"/>
								</Value>
							</Attribute>
						</xsl:if>	
						<!-- Anger Klass -->
						<xsl:if test="normalize-space(utbildningsinformation/klass) != ''">
							<Attribute name="klass">
								<Value>
									<xsl:value-of select="normalize-space(utbildningsinformation/klass)"/>
								</Value>
							</Attribute>
						</xsl:if>
						<!-- Betyget utfärdat år -->
						<xsl:if test="normalize-space(handling/utfardat_ar) != ''">
							<Attribute name="utfardat_ar">
								<Value>
									<xsl:value-of select="normalize-space(handling/utfardat_ar)"/>
								</Value>
							</Attribute>
						</xsl:if>
						
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
							<Value>0</Value>
						</Attribute>

<xsl:for-each select="handling">							
						<!-- Skapar ett Document som heter Slutbetyg vilket blir DisplayName -->
						<Document>
							<DisplayName>
							<xsl:value-of select="handlingstyp"/>
							</DisplayName>
							<ObjectType>betyg_handling</ObjectType>
						
						<!-- Typ av handling -->
						<xsl:if test="normalize-space(handlingstyp) != ''">
							<Attribute name="handling_typ">
								<Value>
									<xsl:value-of select="normalize-space(handlingstyp)"/>
								</Value>
							</Attribute>
						</xsl:if>
						

<!-- Betyget utfärdat år -->
						<xsl:if test="normalize-space(utfardat_ar) != ''">
							<Attribute name="utfardat_ar">
								<Value>
									<xsl:value-of select="normalize-space(utfardat_ar)"/>
								</Value>
							</Attribute>
						</xsl:if>

						<!-- Betyget utfärdat datum -->
						<xsl:if test="normalize-space(utfardat_datum) != ''">
							<Attribute name="utfardat_datum">
								<Value>
									<xsl:value-of select="normalize-space(utfardat_datum)"/>
								</Value>
							</Attribute>
						</xsl:if>

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
								<Value>0</Value>
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
									<Value>0</Value>
								</Attribute>

								<!-- Här pekar vi ut den bifogade filen -->
								<Content>

									<URI>	
										<xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri(fil)"/>
										
									</URI>
								</Content>

								
							</File>
							
							</Document>	
</xsl:for-each>

<!-- All data från ursprungssystemet lagras i original.xml-->

	<Document>

							<DisplayName><xsl:value-of select="$pnr"/><xsl:text>.xml</xsl:text></DisplayName>

							<ObjectType>xml_document</ObjectType>

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
								<Value>0</Value>
							</Attribute>

							<File>

								<DisplayName><xsl:value-of select="$pnr"/><xsl:text>.xml</xsl:text></DisplayName>
								<Content>

									<URI>./doc/<xsl:value-of select="$pnr"/>.xml</URI>

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
