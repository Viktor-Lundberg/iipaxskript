<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:ii="http://www.idainfront.se/xslt" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:ns0="https://journal.prorenata.se/static/xml/journal_archive/1.0.3/patients" exclude-result-prefixes="xs fn ns0">
	<xsl:output indent="yes" media-type="text/xml" encoding="ISO-8859-1"/>


	<!-- v. 1.0 = Skriptet upprättat
		 v. 1.1 = Skriptet tar med xml-filen vid inläsning
		 v. 1.2 = Fixat så att national_identity_number läggs till för att möjliggöra sökning i Mitt arkiv 
		 v. 1.3 = Lagt till information om instrumentsekretess för vissa bilagor i psykologjournal
		 v. 1.4 = Skriptet tar med elevfoton vid inläsning.
		 v. 1.5 = Lagt till translate för att hantera strängar som innehåller éèáàü etc.
	-->
	
	<!-- Scriptet letar efter filer i adapterns utpekade documentLocation  -->
	
	<xsl:param name="documentLocation"/>
	
<!-- Börja i rotnoden i xml-filen -->
	
	<xsl:template match="/">

		<!-- Varje gång elementet JournalArchive återfinns i filen gör scriptet nedanstående  -->
		
		<xsl:for-each select="//ns0:JournalArchive">

		<!-- Skapar en variabel som medför att varje gång vi skriver $pnr så hämtar scriptet värdet i personal_id  -->

			<xsl:variable name="pnr" select="normalize-space(ns0:objects/ns0:patients/ns0:patient/ns0:personal_id)"/>
			
<!-- Skapar variabler för elevens förnamn, efternamn och skoltillhörighet--> 			
<xsl:variable name="fornamn" select="ns0:objects/ns0:patients/ns0:patient/ns0:first_name"></xsl:variable>
<xsl:variable name="efternamn" select="ns0:objects/ns0:patients/ns0:patient/ns0:last_name"></xsl:variable>
<xsl:variable name="skola" select="ns0:objects/ns0:organization_units/ns0:organizationunit/ns0:name"></xsl:variable>

<!-- Skapar variabel som hämtar filnamnet på xml-filen och tar bort filändelsen för att skapa uri till den personliga mappen där filerna finns-->
<xsl:variable name="filename"><xsl:value-of select="$pnr"/></xsl:variable>

<!--Skapar variabel som genererar namnet på elevens xml-fil -->
<xsl:variable name="xmlfil"><xsl:value-of select="$pnr"/><xsl:text> </xsl:text><xsl:value-of select="fn:lower-case(fn:translate($fornamn,' åäöÅÄÖéèáàüêëñ','-aaoaaoeeaaueen'))"/><xsl:text>-</xsl:text><xsl:value-of select="fn:lower-case(fn:translate($efternamn,' åäöÅÄÖéèáàüêëñ','-aaoaaoeeaaueen'))"/><xsl:text>, </xsl:text><xsl:value-of select="fn:lower-case(fn:translate($skola,' åäöÅÄÖ','-aaoaao'))"/>.xml</xsl:variable>

			
<!-- Skapa en kopia av hela xml-filen och ger den ett filnamn baserat på personal_id -->
			<ii:output ii:fileName="{$pnr}/doc/original.xml">
				<xsl:copy-of select="."/>
			</ii:output>
			
			<!-- Skapar en mapp på servern -->
				
			<ii:output ii:indent="2" ii:fileName="{$pnr}/Archive.xml">

				<!-- Skapar iipaxSIP, system och producent -->
				
				<ArchiveSip system="Prorenata" producer="Borås Stads elevhälsa" xmlns:ns2="http://www.idainfront.se/schema/archive-2.0-custom" xmlns="http://www.idainfront.se/schema/archive-2.2">
					
					<ArchiveObject>
						
					<!-- Skapar display_name enligt principen YYYYMMDD Förnamn Efternamn, Skola-->
					<xsl:analyze-string select="$pnr" regex="(.{{8}})(.{{4}})">
						<xsl:matching-substring>
							<DisplayName><xsl:value-of select="regex-group(1)"/><xsl:text> </xsl:text><xsl:value-of select="$fornamn"/><xsl:text> </xsl:text><xsl:value-of select="$efternamn"/><xsl:text>, </xsl:text><xsl:value-of select="$skola"/></DisplayName>
						</xsl:matching-substring>
					</xsl:analyze-string>
						
						<ObjectType>prnelev</ObjectType>
					
					<!-- Anger elevens personnummer och gör om formatet till YYYYMMDD-XXXX-->
						
						<xsl:analyze-string regex="(.{{8}})(.{{4}})" select="$pnr">
								<xsl:matching-substring>
										<Attribute name="personnummer">
											<Value>
												<xsl:value-of select="regex-group(1)"/>-<xsl:value-of select="regex-group(2)"/>
											</Value>
										</Attribute>	
								</xsl:matching-substring>
						</xsl:analyze-string>

						<!-- Anger elevens förnamn -->
						<xsl:if test="normalize-space(ns0:objects/ns0:patients/ns0:patient/ns0:first_name) != ''">
							<Attribute name="fornamn">
								<Value>
									<xsl:value-of select="normalize-space(ns0:objects/ns0:patients/ns0:patient/ns0:first_name)"/>
								</Value>
							</Attribute>
						</xsl:if>
						
						<!-- Anger elevens efternamn -->
						<xsl:if test="normalize-space(ns0:objects/ns0:patients/ns0:patient/ns0:last_name) != ''">
							<Attribute name="efternamn">
								<Value>
									<xsl:value-of select="normalize-space(ns0:objects/ns0:patients/ns0:patient/ns0:last_name)"/>
								</Value>
							</Attribute>
						</xsl:if>
						
						<!-- Anger elevens kön i klartext genom choose -->
						<xsl:if test="normalize-space(ns0:objects/ns0:patients/ns0:patient/ns0:sex) != ''">
							<Attribute name="kon">
								<Value>
									<xsl:choose>
									<xsl:when test="ns0:objects/ns0:patients/ns0:patient/ns0:sex/text()='M'">Man</xsl:when>
									<xsl:when test="ns0:objects/ns0:patients/ns0:patient/ns0:sex/text()='F'">Kvinna</xsl:when>
									<xsl:otherwise>Okänd</xsl:otherwise>
									</xsl:choose>
								</Value>
							</Attribute>
						</xsl:if>
						
						<!-- Anger elevens skola -->
						<xsl:if test="normalize-space(ns0:objects/ns0:organization_units/ns0:organizationunit/ns0:name) != ''">
							<Attribute name="skola">
								<Value>
									<xsl:value-of select="normalize-space(ns0:objects/ns0:organization_units/ns0:organizationunit/ns0:name)"/>
								</Value>
							</Attribute>
						</xsl:if>
						
						
							<Attribute name="national_identity_nr">
								<Value>
									<xsl:value-of select="$pnr"/>
								</Value>
							</Attribute>
												
						
						

						<!-- Sekretess -->
						<Attribute name="secrecy">
							<Value>10</Value>
						</Attribute>
						
						
						<!-- Sekretess info -->
						<Attribute name="sekretess_lagrum">
							<Value>OBS! Kan finnas instrumentsekretess enligt OSL 17:4 bland psykologhandlingarna. Materialet får inte lämnas ut till andra än behöriga testanvändare.</Value>
						</Attribute>

						<!-- PUL -->
						<Attribute name="pul_personal_secrecy">
							<Value>20</Value>
						</Attribute>

						<!-- Övrigt skydd -->
						<Attribute name="other_secrecy">
							<Value>20</Value>
						</Attribute>

<xsl:for-each select="ns0:objects/ns0:admissions/ns0:admission/ns0:pdf_archive_path[fn:starts-with(.,'medicinsk-elevhalsa')]">							
						<!-- Skapar ett Document som heter Medicinsk elevhälsa, vilket blir DisplayName -->
						<Document>
							<DisplayName>
							<xsl:text>Medicinsk elevhälsa</xsl:text>
							</DisplayName>
							<ObjectType>prnelev_handling</ObjectType>

							<!-- Sekretess -->
							<Attribute name="secrecy"><Value>10</Value>
							</Attribute>
						
							

							<!-- PUL -->
							<Attribute name="pul_personal_secrecy"><Value>20</Value>
							</Attribute>

							<!-- Övrigt skydd -->
							<Attribute name="other_secrecy"><Value>20</Value>
							</Attribute>

								
							<!-- Hämtar filer som är en del av den medicinska elevhälsans journal.-->
							<File>

								<DisplayName>
								<xsl:text>EMI.pdf</xsl:text>	
									</DisplayName>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								
								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Här pekar vi ut den bifogade filen -->
								<Content>

									<URI>	
										<xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(self::ns0:pdf_archive_path)"/>
										
									</URI>
								</Content>

								
							</File>
							
								<File>

								<DisplayName>
								<xsl:text>Tillväxtkurva.pdf</xsl:text>	
									</DisplayName>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								
								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Här pekar vi ut den bifogade filen-->
								<Content>

									<URI>	
										<xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(parent::ns0:admission/ns0:growth_curve_archive_path)"/>
										
									</URI>
								</Content>

								
							</File>
						<File>

								<DisplayName>
								<xsl:text>Vaccinationskort.pdf</xsl:text>	
									</DisplayName>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								
								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Här pekar vi ut den bifogade filen-->
								<Content>

									<URI>	
										<xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(parent::ns0:admission/ns0:vaccination_card_archive_path)"/>
										
									</URI>
								</Content>

								
							</File>
						
						</Document>
</xsl:for-each>

<!-- Hämtar filer som är en del av Elevakt -->	
<xsl:for-each select="ns0:objects/ns0:admissions/ns0:admission/ns0:pdf_archive_path[fn:starts-with(.,'elevakt')]">		
	<Document>
							<DisplayName>
							<xsl:text>Elevakt</xsl:text>
							</DisplayName>
							<ObjectType>prnelev_handling</ObjectType>

							<!-- Sekretess -->
							<Attribute name="secrecy"><Value>10</Value>
							</Attribute>

							<!-- PUL -->
							<Attribute name="pul_personal_secrecy"><Value>20</Value>
							</Attribute>

							<!-- Övrigt skydd -->
							<Attribute name="other_secrecy"><Value>20</Value>
							</Attribute>

								
							<!-- Här går vi ner till nivån för filen -->
							<File>

								<DisplayName>
								<xsl:text>Elevakt.pdf</xsl:text>	
									</DisplayName>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								
								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Här pekar vi ut den bifogade filen-->
								<Content>

									<URI>	
										<xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(.)"/>
										
									</URI>
								</Content>

								
							</File>
							
							
							</Document>
</xsl:for-each>

<!-- Bilagor till Kuratorsjournalen -->	
<xsl:for-each select="ns0:objects/ns0:admissions/ns0:admission/ns0:pdf_archive_path[fn:starts-with(.,'kurator')]">	
<Document>
							<DisplayName>
							<xsl:text>Kurator</xsl:text>
							</DisplayName>
							<ObjectType>prnelev_handling</ObjectType>

							<!-- Sekretess -->
							<Attribute name="secrecy"><Value>10</Value>
							</Attribute>

							<!-- PUL -->
							<Attribute name="pul_personal_secrecy"><Value>20</Value>
							</Attribute>

							<!-- Övrigt skydd -->
							<Attribute name="other_secrecy"><Value>20</Value>
							</Attribute>

								
							<!-- Här går vi ner till nivån för filen -->
							<File>

								<DisplayName>
								<xsl:text>Kurator.pdf</xsl:text>	
									</DisplayName>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								
								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Här pekar vi ut den bifogade filen-->
								<Content>

									<URI>	
										<xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(.)"/>
										
									</URI>
								</Content>

								
							</File>
							</Document>
</xsl:for-each>

<!-- Hämtar psykologjournalen -->	
<xsl:for-each select="ns0:objects/ns0:admissions/ns0:admission/ns0:pdf_archive_path[fn:starts-with(.,'psykolog')]">	
<Document>
							<DisplayName>
							<xsl:text>Psykolog</xsl:text>
							</DisplayName>
							<ObjectType>prnelev_handling</ObjectType>

							<!-- Sekretess -->
							<Attribute name="secrecy"><Value>10</Value>
							</Attribute>
							
							<!-- Sekretess info -->
						<Attribute name="sekretess_lagrum">
							<Value>OBS! Kan finnas instrumentsekretess enligt OSL 17:4 bland psykologhandlingarna. Materialet får inte lämnas ut till andra än behöriga testanvändare.</Value>
						
						</Attribute>


							<!-- PUL -->
							<Attribute name="pul_personal_secrecy"><Value>20</Value>
							</Attribute>

							<!-- Övrigt skydd -->
							<Attribute name="other_secrecy"><Value>20</Value>
							</Attribute>

								
							<!-- Här går vi ner till nivån för filen -->
							<File>

								<DisplayName>
								<xsl:text>Psykologjournal.pdf</xsl:text>	
									</DisplayName>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>
								
								
								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								
								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Här pekar vi ut den bifogade filen-->
								<Content>

									<URI>	
										<xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(.)"/>
										
									</URI>
								</Content>

								
							</File>
							</Document>
</xsl:for-each>

<!-- Hämtar specialpedagogjournalen -->	
<xsl:for-each select="ns0:objects/ns0:admissions/ns0:admission/ns0:pdf_archive_path[fn:starts-with(.,'specialpedagog')]">	
<Document>
							<DisplayName>
							<xsl:text>Specialpedagog</xsl:text>
							</DisplayName>
							<ObjectType>prnelev_handling</ObjectType>

							<!-- Sekretess -->
							<Attribute name="secrecy"><Value>10</Value>
							</Attribute>

							<!-- PUL -->
							<Attribute name="pul_personal_secrecy"><Value>20</Value>
							</Attribute>

							<!-- Övrigt skydd -->
							<Attribute name="other_secrecy"><Value>20</Value>
							</Attribute>

								
							<!-- Här går vi ner till nivån för filen -->
							<File>

								<DisplayName>
								<xsl:text>Specialpedagog.pdf</xsl:text>	
									</DisplayName>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								
								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Här pekar vi ut den bifogade filen-->
								<Content>

									<URI>	
										<xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(.)"/>
										
									</URI>
								</Content>

								
							</File>	
</Document>	
</xsl:for-each>

<!-- Hämtar skolledningsdokumentationen -->			
<xsl:for-each select="ns0:objects/ns0:admissions/ns0:admission/ns0:pdf_archive_path[fn:starts-with(.,'skolledning')]">	
<Document>
							<DisplayName>
							<xsl:text>Skolledning</xsl:text>
							</DisplayName>
							<ObjectType>prnelev_handling</ObjectType>

							<!-- Sekretess -->
							<Attribute name="secrecy"><Value>10</Value>
							</Attribute>

							<!-- PUL -->
							<Attribute name="pul_personal_secrecy"><Value>20</Value>
							</Attribute>

							<!-- Övrigt skydd -->
							<Attribute name="other_secrecy"><Value>20</Value>
							</Attribute>

								
							<!-- Här går vi ner till nivån för filen -->
							<File>

								<DisplayName>
								<xsl:text>Skolledning.pdf</xsl:text>	
									</DisplayName>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								
								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Här pekar vi ut den bifogade filen-->
								<Content>

									<URI>	
										<xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(.)"/>
										
									</URI>
								</Content>

								
							</File>				
</Document>
</xsl:for-each>

<!-- Hämtar SYV-journalen -->	
<xsl:for-each select="ns0:objects/ns0:admissions/ns0:admission/ns0:pdf_archive_path[fn:starts-with(.,'syv')]">		
<Document>
							<DisplayName>
							<xsl:text>SYV</xsl:text>
							</DisplayName>
							<ObjectType>prnelev_handling</ObjectType>

							<!-- Sekretess -->
							<Attribute name="secrecy"><Value>10</Value>
							</Attribute>

							<!-- PUL -->
							<Attribute name="pul_personal_secrecy"><Value>20</Value>
							</Attribute>

							<!-- Övrigt skydd -->
							<Attribute name="other_secrecy"><Value>20</Value>
							</Attribute>

								
							<!-- Här går vi ner till nivån för filen -->
							<File>

								<DisplayName>
								<xsl:text>Syv.pdf</xsl:text>	
									</DisplayName>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								
								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Här pekar vi ut den bifogade filen-->
								<Content>

									<URI>	
										<xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(.)"/>
										
									</URI>
								</Content>

								
							</File>				
</Document>	
</xsl:for-each>

<!-- Hämtar logopedjournalen -->	
<xsl:for-each select="ns0:objects/ns0:admissions/ns0:admission/ns0:pdf_archive_path[fn:starts-with(.,'logoped')]">	
<Document>
							<DisplayName>
							<xsl:text>Logoped</xsl:text>
							</DisplayName>
							<ObjectType>prnelev_handling</ObjectType>

							<!-- Sekretess -->
							<Attribute name="secrecy"><Value>10</Value>
							</Attribute>

							<!-- PUL -->
							<Attribute name="pul_personal_secrecy"><Value>20</Value>
							</Attribute>

							<!-- Övrigt skydd -->
							<Attribute name="other_secrecy"><Value>20</Value>
							</Attribute>

								
							<!-- Här går vi ner till nivån för filen -->
							<File>

								<DisplayName>
								<xsl:text>Logoped.pdf</xsl:text>	
									</DisplayName>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								
								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Här pekar vi ut den bifogade filen-->
								<Content>

									<URI>	
										<xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(.)"/>
										
									</URI>
								</Content>

								
							</File>				
</Document>	
</xsl:for-each>

<!-- Hämtar tilläggsbelopp -->	
<xsl:for-each select="ns0:objects/ns0:admissions/ns0:admission/ns0:pdf_archive_path[fn:starts-with(.,'tillaggsbelopp')]">	
<Document>
							<DisplayName>
							<xsl:text>Tilläggsbelopp</xsl:text>
							</DisplayName>
							<ObjectType>prnelev_handling</ObjectType>

							<!-- Sekretess -->
							<Attribute name="secrecy"><Value>10</Value>
							</Attribute>

							<!-- PUL -->
							<Attribute name="pul_personal_secrecy"><Value>20</Value>
							</Attribute>

							<!-- Övrigt skydd -->
							<Attribute name="other_secrecy"><Value>20</Value>
							</Attribute>

								
							<!-- Här går vi ner till nivån för filen -->
							<File>

								<DisplayName>
								<xsl:text>Tilläggsbelopp.pdf</xsl:text>	
									</DisplayName>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								
								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Här pekar vi ut den bifogade filen-->
								<Content>

									<URI>	
										<xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(.)"/>
										
									</URI>
								</Content>

								
							</File>				
</Document>
</xsl:for-each>

<!-- Hämtar överlämningsdokumentationen -->	
<xsl:for-each select="ns0:objects/ns0:admissions/ns0:admission/ns0:pdf_archive_path[fn:starts-with(.,'overlamning')]">
<Document>
							<DisplayName>
							<xsl:text>Överlämning</xsl:text>
							</DisplayName>
							<ObjectType>prnelev_handling</ObjectType>

							<!-- Sekretess -->
							<Attribute name="secrecy"><Value>10</Value>
							</Attribute>

							<!-- PUL -->
							<Attribute name="pul_personal_secrecy"><Value>20</Value>
							</Attribute>

							<!-- Övrigt skydd -->
							<Attribute name="other_secrecy"><Value>20</Value>
							</Attribute>

								
							<!-- Här går vi ner till nivån för filen -->
							<File>

								<DisplayName>
								<xsl:text>Överlämning.pdf</xsl:text>	
									</DisplayName>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								
								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Här pekar vi ut den bifogade filen-->
								<Content>

									<URI>	
										<xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(.)"/>
										
									</URI>
								</Content>

								
							</File>				
</Document>	
</xsl:for-each>




<!-- HÄR BÖRJAR BILAGORNA !!! -->




<!--BILAGOR FÖR ELEVAKT-->

<xsl:if test="ns0:objects/ns0:entries/ns0:journalentry/ns0:attachments/ns0:journalentrys3attachment/ns0:archive_path[starts-with(.,'elevakt')]">
<Document>
							<DisplayName><xsl:text>Elevakt - Bilagor</xsl:text></DisplayName>

							<ObjectType>prnelev_handling</ObjectType>

							<!-- Sekretess -->
							<Attribute name="secrecy"><Value>10</Value>
							</Attribute>

							<!-- PUL -->
							<Attribute name="pul_personal_secrecy"><Value>20</Value>
							</Attribute>

							<!-- Övrigt skydd -->
							<Attribute name="other_secrecy"><Value>20</Value>
							</Attribute>

<xsl:for-each select="ns0:objects/ns0:entries/ns0:journalentry/ns0:attachments/ns0:journalentrys3attachment/ns0:archive_path[starts-with(.,'elevakt')]">

							<File>
								<DisplayName><xsl:number value="position()" format="1"/><xsl:text> - </xsl:text><xsl:value-of select="parent::ns0:journalentrys3attachment/ns0:filename"/></DisplayName>
								<Content>

									<URI><xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(parent::ns0:journalentrys3attachment/ns0:archive_path)"/></URI>

								</Content>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

							</File>
							<File>
							<xsl:variable name="nummer"><xsl:number value="position()" format="1"/></xsl:variable>
							<xsl:analyze-string regex="([\w|\s|_]+\..*$)" select="parent::ns0:journalentrys3attachment/ns0:archive_pdfa_path">
<xsl:matching-substring>
								
								<DisplayName><xsl:value-of select="($nummer)"></xsl:value-of><xsl:text>b - </xsl:text><xsl:value-of select="regex-group(1)"/></DisplayName></xsl:matching-substring>
</xsl:analyze-string>
								<Content>

									<URI><xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(parent::ns0:journalentrys3attachment/ns0:archive_pdfa_path)"/></URI>

								</Content>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

							</File>
							

</xsl:for-each>						
</Document>
</xsl:if>

<!--BILAGOR FÖR SHV -->

<xsl:if test="ns0:objects/ns0:entries/ns0:journalentry/ns0:attachments/ns0:journalentrys3attachment/ns0:archive_path[starts-with(.,'medicinsk-elevhalsa')]">
<Document>
							<DisplayName><xsl:text>Medicinsk elevhälsa - Bilagor</xsl:text></DisplayName>

							<ObjectType>prnelev_handling</ObjectType>

							<!-- Sekretess -->
							<Attribute name="secrecy"><Value>10</Value>
							</Attribute>

							<!-- PUL -->
							<Attribute name="pul_personal_secrecy"><Value>20</Value>
							</Attribute>

							<!-- Övrigt skydd -->
							<Attribute name="other_secrecy"><Value>20</Value>
							</Attribute>

<xsl:for-each select="ns0:objects/ns0:entries/ns0:journalentry/ns0:attachments/ns0:journalentrys3attachment/ns0:archive_path[starts-with(.,'medicinsk-elevhalsa')]">

							<File>
								<DisplayName><xsl:number value="position()" format="1"/><xsl:text> - </xsl:text><xsl:value-of select="parent::ns0:journalentrys3attachment/ns0:filename"/></DisplayName>
								<Content>

									<URI><xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(parent::ns0:journalentrys3attachment/ns0:archive_path)"/></URI>

								</Content>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

							</File>
							<File>
							<xsl:variable name="nummer"><xsl:number value="position()" format="1"/></xsl:variable>
							<xsl:analyze-string regex="([\w|\s|_]+\..*$)" select="parent::ns0:journalentrys3attachment/ns0:archive_pdfa_path">
<xsl:matching-substring>
								
								<DisplayName><xsl:value-of select="($nummer)"></xsl:value-of><xsl:text>b - </xsl:text><xsl:value-of select="regex-group(1)"/></DisplayName></xsl:matching-substring>
</xsl:analyze-string>
								<Content>

									<URI><xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(parent::ns0:journalentrys3attachment/ns0:archive_pdfa_path)"/></URI>

								</Content>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

							</File>
							

</xsl:for-each>						
</Document>
</xsl:if>

<!-- BILAGOR FÖR KURATOR -->

<xsl:if test="ns0:objects/ns0:entries/ns0:journalentry/ns0:attachments/ns0:journalentrys3attachment/ns0:archive_path[starts-with(.,'kurator')]">
<Document>
							<DisplayName><xsl:text>Kurator - Bilagor</xsl:text></DisplayName>

							<ObjectType>prnelev_handling</ObjectType>

							<!-- Sekretess -->
							<Attribute name="secrecy"><Value>10</Value>
							</Attribute>

							<!-- PUL -->
							<Attribute name="pul_personal_secrecy"><Value>20</Value>
							</Attribute>

							<!-- Övrigt skydd -->
							<Attribute name="other_secrecy"><Value>20</Value>
							</Attribute>

<xsl:for-each select="ns0:objects/ns0:entries/ns0:journalentry/ns0:attachments/ns0:journalentrys3attachment/ns0:archive_path[starts-with(.,'kurator')]">

							<File>
								<DisplayName><xsl:number value="position()" format="1"/><xsl:text> - </xsl:text><xsl:value-of select="parent::ns0:journalentrys3attachment/ns0:filename"/></DisplayName>
								<Content>

									<URI><xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(parent::ns0:journalentrys3attachment/ns0:archive_path)"/></URI>

								</Content>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

							</File>
							<File>
							<xsl:variable name="nummer"><xsl:number value="position()" format="1"/></xsl:variable>
							<xsl:analyze-string regex="([\w|\s|_]+\..*$)" select="parent::ns0:journalentrys3attachment/ns0:archive_pdfa_path">
<xsl:matching-substring>
								
								<DisplayName><xsl:value-of select="($nummer)"></xsl:value-of><xsl:text>b - </xsl:text><xsl:value-of select="regex-group(1)"/></DisplayName></xsl:matching-substring>
</xsl:analyze-string>
								<Content>

									<URI><xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(parent::ns0:journalentrys3attachment/ns0:archive_pdfa_path)"/></URI>

								</Content>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

							</File>
							

</xsl:for-each>						
</Document>
</xsl:if>

<!-- Bilagor för Psykolog -->

<xsl:if test="ns0:objects/ns0:entries/ns0:journalentry/ns0:attachments/ns0:journalentrys3attachment/ns0:archive_path[starts-with(.,'psykolog')]">
<Document>
							<DisplayName><xsl:text>Psykolog - Bilagor</xsl:text></DisplayName>

							<ObjectType>prnelev_handling</ObjectType>

							<!-- Sekretess -->
							<Attribute name="secrecy"><Value>10</Value>
							</Attribute>
							
							
							<!-- Sekretessmarkering -->
							<Attribute name="sekretess_lagrum">
							<Value>OBS! Kan finnas instrumentsekretess enligt OSL 17:4 bland psykologhandlingarna. Materialet får inte lämnas ut till andra än behöriga testanvändare.</Value>
						
							</Attribute>

							<!-- PUL -->
							<Attribute name="pul_personal_secrecy"><Value>20</Value>
							</Attribute>

							<!-- Övrigt skydd -->
							<Attribute name="other_secrecy"><Value>20</Value>
							</Attribute>

<xsl:for-each select="ns0:objects/ns0:entries/ns0:journalentry/ns0:attachments/ns0:journalentrys3attachment/ns0:archive_path[starts-with(.,'psykolog')]">

							<File>
								<DisplayName><xsl:number value="position()" format="1"/><xsl:text> - </xsl:text><xsl:value-of select="parent::ns0:journalentrys3attachment/ns0:filename"/></DisplayName>
								<Content>

									<URI><xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(parent::ns0:journalentrys3attachment/ns0:archive_path)"/></URI>

								</Content>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

							</File>
							<File>
							<xsl:variable name="nummer"><xsl:number value="position()" format="1"/></xsl:variable>
							<xsl:analyze-string regex="([\w|\s|_]+\..*$)" select="parent::ns0:journalentrys3attachment/ns0:archive_pdfa_path">
<xsl:matching-substring>
								
								<DisplayName><xsl:value-of select="($nummer)"></xsl:value-of><xsl:text>b - </xsl:text><xsl:value-of select="regex-group(1)"/></DisplayName></xsl:matching-substring>
</xsl:analyze-string>
								<Content>

									<URI><xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(parent::ns0:journalentrys3attachment/ns0:archive_pdfa_path)"/></URI>

								</Content>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

							</File>
							

</xsl:for-each>						
</Document>
</xsl:if>

<!-- Bilagor Specialpedagog -->

<xsl:if test="ns0:objects/ns0:entries/ns0:journalentry/ns0:attachments/ns0:journalentrys3attachment/ns0:archive_path[starts-with(.,'specialpedagog')]">
<Document>
							<DisplayName><xsl:text>Specialpedagog - Bilagor</xsl:text></DisplayName>

							<ObjectType>prnelev_handling</ObjectType>

							<!-- Sekretess -->
							<Attribute name="secrecy"><Value>10</Value>
							</Attribute>

							<!-- PUL -->
							<Attribute name="pul_personal_secrecy"><Value>20</Value>
							</Attribute>

							<!-- Övrigt skydd -->
							<Attribute name="other_secrecy"><Value>20</Value>
							</Attribute>

<xsl:for-each select="ns0:objects/ns0:entries/ns0:journalentry/ns0:attachments/ns0:journalentrys3attachment/ns0:archive_path[starts-with(.,'specialpedagog')]">

							<File>
								<DisplayName><xsl:number value="position()" format="1"/><xsl:text> - </xsl:text><xsl:value-of select="parent::ns0:journalentrys3attachment/ns0:filename"/></DisplayName>
								<Content>

									<URI><xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(parent::ns0:journalentrys3attachment/ns0:archive_path)"/></URI>

								</Content>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

							</File>
							<File>
							<xsl:variable name="nummer"><xsl:number value="position()" format="1"/></xsl:variable>
							<xsl:analyze-string regex="([\w|\s|_]+\..*$)" select="parent::ns0:journalentrys3attachment/ns0:archive_pdfa_path">
<xsl:matching-substring>
								
								<DisplayName><xsl:value-of select="($nummer)"></xsl:value-of><xsl:text>b - </xsl:text><xsl:value-of select="regex-group(1)"/></DisplayName></xsl:matching-substring>
</xsl:analyze-string>
								<Content>

									<URI><xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(parent::ns0:journalentrys3attachment/ns0:archive_pdfa_path)"/></URI>

								</Content>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

							</File>
							

</xsl:for-each>						
</Document>
</xsl:if>

<!-- Bilagor Skolledning -->

<xsl:if test="ns0:objects/ns0:entries/ns0:journalentry/ns0:attachments/ns0:journalentrys3attachment/ns0:archive_path[starts-with(.,'skolledning')]">
<Document>
							<DisplayName><xsl:text>Skolledning - Bilagor</xsl:text></DisplayName>

							<ObjectType>prnelev_handling</ObjectType>

							<!-- Sekretess -->
							<Attribute name="secrecy"><Value>10</Value>
							</Attribute>

							<!-- PUL -->
							<Attribute name="pul_personal_secrecy"><Value>20</Value>
							</Attribute>

							<!-- Övrigt skydd -->
							<Attribute name="other_secrecy"><Value>20</Value>
							</Attribute>

<xsl:for-each select="ns0:objects/ns0:entries/ns0:journalentry/ns0:attachments/ns0:journalentrys3attachment/ns0:archive_path[starts-with(.,'skolledning')]">

							<File>
								<DisplayName><xsl:number value="position()" format="1"/><xsl:text> - </xsl:text><xsl:value-of select="parent::ns0:journalentrys3attachment/ns0:filename"/></DisplayName>
								<Content>

									<URI><xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(parent::ns0:journalentrys3attachment/ns0:archive_path)"/></URI>

								</Content>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

							</File>
							<File>
							<xsl:variable name="nummer"><xsl:number value="position()" format="1"/></xsl:variable>
							<xsl:analyze-string regex="([\w|\s|_]+\..*$)" select="parent::ns0:journalentrys3attachment/ns0:archive_pdfa_path">
<xsl:matching-substring>
								
								<DisplayName><xsl:value-of select="($nummer)"></xsl:value-of><xsl:text>b - </xsl:text><xsl:value-of select="regex-group(1)"/></DisplayName></xsl:matching-substring>
</xsl:analyze-string>
								<Content>

									<URI><xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(parent::ns0:journalentrys3attachment/ns0:archive_pdfa_path)"/></URI>

								</Content>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

							</File>
							

</xsl:for-each>						
</Document>
</xsl:if>

<!-- Bilagor SYV -->

<xsl:if test="ns0:objects/ns0:entries/ns0:journalentry/ns0:attachments/ns0:journalentrys3attachment/ns0:archive_path[starts-with(.,'syv')]">
<Document>
							<DisplayName><xsl:text>SYV - Bilagor</xsl:text></DisplayName>

							<ObjectType>prnelev_handling</ObjectType>

							<!-- Sekretess -->
							<Attribute name="secrecy"><Value>10</Value>
							</Attribute>

							<!-- PUL -->
							<Attribute name="pul_personal_secrecy"><Value>20</Value>
							</Attribute>

							<!-- Övrigt skydd -->
							<Attribute name="other_secrecy"><Value>20</Value>
							</Attribute>

<xsl:for-each select="ns0:objects/ns0:entries/ns0:journalentry/ns0:attachments/ns0:journalentrys3attachment/ns0:archive_path[starts-with(.,'syv')]">

							<File>
								<DisplayName><xsl:number value="position()" format="1"/><xsl:text> - </xsl:text><xsl:value-of select="parent::ns0:journalentrys3attachment/ns0:filename"/></DisplayName>
								<Content>

									<URI><xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(parent::ns0:journalentrys3attachment/ns0:archive_path)"/></URI>

								</Content>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

							</File>
							<File>
							<xsl:variable name="nummer"><xsl:number value="position()" format="1"/></xsl:variable>
							<xsl:analyze-string regex="([\w|\s|_]+\..*$)" select="parent::ns0:journalentrys3attachment/ns0:archive_pdfa_path">
<xsl:matching-substring>
								
								<DisplayName><xsl:value-of select="($nummer)"></xsl:value-of><xsl:text>b - </xsl:text><xsl:value-of select="regex-group(1)"/></DisplayName></xsl:matching-substring>
</xsl:analyze-string>
								<Content>

									<URI><xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(parent::ns0:journalentrys3attachment/ns0:archive_pdfa_path)"/></URI>

								</Content>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

							</File>
							

</xsl:for-each>						
</Document>
</xsl:if>

<!-- Bilagor Logoped -->

<xsl:if test="ns0:objects/ns0:entries/ns0:journalentry/ns0:attachments/ns0:journalentrys3attachment/ns0:archive_path[starts-with(.,'logoped')]">
<Document>
							<DisplayName><xsl:text>Logoped - Bilagor</xsl:text></DisplayName>

							<ObjectType>prnelev_handling</ObjectType>

							<!-- Sekretess -->
							<Attribute name="secrecy"><Value>10</Value>
							</Attribute>

							<!-- PUL -->
							<Attribute name="pul_personal_secrecy"><Value>20</Value>
							</Attribute>

							<!-- Övrigt skydd -->
							<Attribute name="other_secrecy"><Value>20</Value>
							</Attribute>

<xsl:for-each select="ns0:objects/ns0:entries/ns0:journalentry/ns0:attachments/ns0:journalentrys3attachment/ns0:archive_path[starts-with(.,'logoped')]">

							<File>
								<DisplayName><xsl:number value="position()" format="1"/><xsl:text> - </xsl:text><xsl:value-of select="parent::ns0:journalentrys3attachment/ns0:filename"/></DisplayName>
								<Content>

									<URI><xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(parent::ns0:journalentrys3attachment/ns0:archive_path)"/></URI>

								</Content>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

							</File>
							<File>
							<xsl:variable name="nummer"><xsl:number value="position()" format="1"/></xsl:variable>
							<xsl:analyze-string regex="([\w|\s|_]+\..*$)" select="parent::ns0:journalentrys3attachment/ns0:archive_pdfa_path">
<xsl:matching-substring>
								
								<DisplayName><xsl:value-of select="($nummer)"></xsl:value-of><xsl:text>b - </xsl:text><xsl:value-of select="regex-group(1)"/></DisplayName></xsl:matching-substring>
</xsl:analyze-string>
								<Content>

									<URI><xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(parent::ns0:journalentrys3attachment/ns0:archive_pdfa_path)"/></URI>

								</Content>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

							</File>
							

</xsl:for-each>						
</Document>
</xsl:if>

<!-- Bilagor tilläggsbelopp -->
<xsl:if test="ns0:objects/ns0:entries/ns0:journalentry/ns0:attachments/ns0:journalentrys3attachment/ns0:archive_path[starts-with(.,'tillaggsbelopp')]">
<Document>
							<DisplayName><xsl:text>Tilläggsbelopp - Bilagor</xsl:text></DisplayName>

							<ObjectType>prnelev_handling</ObjectType>

							<!-- Sekretess -->
							<Attribute name="secrecy"><Value>10</Value>
							</Attribute>

							<!-- PUL -->
							<Attribute name="pul_personal_secrecy"><Value>20</Value>
							</Attribute>

							<!-- Övrigt skydd -->
							<Attribute name="other_secrecy"><Value>20</Value>
							</Attribute>

<xsl:for-each select="ns0:objects/ns0:entries/ns0:journalentry/ns0:attachments/ns0:journalentrys3attachment/ns0:archive_path[starts-with(.,'tillaggsbelopp')]">

							<File>
								<DisplayName><xsl:number value="position()" format="1"/><xsl:text> - </xsl:text><xsl:value-of select="parent::ns0:journalentrys3attachment/ns0:filename"/></DisplayName>
								<Content>

									<URI><xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(parent::ns0:journalentrys3attachment/ns0:archive_path)"/></URI>

								</Content>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

							</File>
							<File>
							<xsl:variable name="nummer"><xsl:number value="position()" format="1"/></xsl:variable>
							<xsl:analyze-string regex="([\w|\s|_]+\..*$)" select="parent::ns0:journalentrys3attachment/ns0:archive_pdfa_path">
<xsl:matching-substring>
								
								<DisplayName><xsl:value-of select="($nummer)"></xsl:value-of><xsl:text>b - </xsl:text><xsl:value-of select="regex-group(1)"/></DisplayName></xsl:matching-substring>
</xsl:analyze-string>
								<Content>

									<URI><xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(parent::ns0:journalentrys3attachment/ns0:archive_pdfa_path)"/></URI>

								</Content>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

							</File>
							

</xsl:for-each>						
</Document>
</xsl:if>

<!-- Bilagor Överlämning -->

<xsl:if test="ns0:objects/ns0:entries/ns0:journalentry/ns0:attachments/ns0:journalentrys3attachment/ns0:archive_path[starts-with(.,'overlamning')]">
<Document>
							<DisplayName><xsl:text>Överlämning - Bilagor</xsl:text></DisplayName>

							<ObjectType>prnelev_handling</ObjectType>

							<!-- Sekretess -->
							<Attribute name="secrecy"><Value>10</Value>
							</Attribute>

							<!-- PUL -->
							<Attribute name="pul_personal_secrecy"><Value>20</Value>
							</Attribute>

							<!-- Övrigt skydd -->
							<Attribute name="other_secrecy"><Value>20</Value>
							</Attribute>

<xsl:for-each select="ns0:objects/ns0:entries/ns0:journalentry/ns0:attachments/ns0:journalentrys3attachment/ns0:archive_path[starts-with(.,'overlamning')]">

							<File>
								<DisplayName><xsl:number value="position()" format="1"/><xsl:text> - </xsl:text><xsl:value-of select="parent::ns0:journalentrys3attachment/ns0:filename"/></DisplayName>
								<Content>

									<URI><xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(parent::ns0:journalentrys3attachment/ns0:archive_path)"/></URI>

								</Content>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

							</File>
							<File>
							<xsl:variable name="nummer"><xsl:number value="position()" format="1"/></xsl:variable>
							<xsl:analyze-string regex="([\w|\s|_]+\..*$)" select="parent::ns0:journalentrys3attachment/ns0:archive_pdfa_path">
<xsl:matching-substring>
								
								<DisplayName><xsl:value-of select="($nummer)"></xsl:value-of><xsl:text>b - </xsl:text><xsl:value-of select="regex-group(1)"/></DisplayName></xsl:matching-substring>
</xsl:analyze-string>
								<Content>

									<URI><xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(parent::ns0:journalentrys3attachment/ns0:archive_pdfa_path)"/></URI>

								</Content>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

							</File>
							

</xsl:for-each>						
</Document>
</xsl:if>

<xsl:if test="ns0:objects/ns0:patient_images/node()">
<Document>
							<DisplayName><xsl:text>Elevfoton</xsl:text></DisplayName>

							<ObjectType>prnelev_handling</ObjectType>

							<!-- Sekretess -->
							<Attribute name="secrecy"><Value>10</Value>
							</Attribute>

							<!-- PUL -->
							<Attribute name="pul_personal_secrecy"><Value>20</Value>
							</Attribute>

							<!-- Övrigt skydd -->
							<Attribute name="other_secrecy"><Value>20</Value>
							</Attribute>

	<xsl:for-each select="ns0:objects/ns0:patient_images/ns0:patientimage">
	<File>
								<DisplayName><xsl:number value="position()" format="1"/><xsl:text> - </xsl:text><xsl:value-of select="ns0:archive_path"/></DisplayName>
								<Content>

									<URI><xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(ns0:archive_path)"/></URI>

								</Content>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

							</File>
							<File>
							<DisplayName><xsl:number value="position()" format="1"/><xsl:text>b - </xsl:text><xsl:value-of select="ns0:archive_pdfa_path"/></DisplayName>
								<Content>

									<URI><xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri(ns0:archive_pdfa_path)"/></URI>

								</Content>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

							
							
							</File>
	
	
	
	
	
	</xsl:for-each>


</Document>

</xsl:if>


					<!-- All data från ursprungssystemet lagras i original.xml-->
					
	<Document>

							<DisplayName>XML</DisplayName>

							<ObjectType>xml_document</ObjectType>

							<!-- Sekretess -->
							<Attribute name="secrecy"><Value>10</Value>
							</Attribute>

							<!-- PUL -->
							<Attribute name="pul_personal_secrecy"><Value>20</Value>
							</Attribute>

							<!-- Övrigt skydd -->
							<Attribute name="other_secrecy"><Value>20</Value>
							</Attribute>

							<File>

								<DisplayName>original.xml</DisplayName>
								
								
								<Content>

									<URI>./doc/original.xml</URI>

								</Content>

								<Attribute name="stylesheet">
							  <Value>ProRenata</Value>
							</Attribute>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

							</File>
							
							<File>

								<DisplayName><xsl:value-of select="$xmlfil"/></DisplayName>
								
								
								<Content>

									<URI><xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($filename)"/>/<xsl:value-of select="fn:encode-for-uri($xmlfil)"/></URI>

								</Content>

								<Attribute name="stylesheet">
							  <Value>ProRenata</Value>
							</Attribute>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>10</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

							</File>

						</Document>
					</ArchiveObject>

				</ArchiveSip>

			</ii:output>

		</xsl:for-each>

	</xsl:template>
</xsl:stylesheet>
