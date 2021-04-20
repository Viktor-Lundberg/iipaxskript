<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ii="http://www.idainfront.se/xslt">
	<xsl:output method="xml" indent="yes" encoding="ISO-8859-1"/>

	<!-- Var adapterytan ska leta efter filerna -->
	<xsl:param name="documentLocation"/>  

	<!-- Startar från rootnooden i XML-filen -->
	<xsl:template match="/">

		<!-- Här börjar skriptet i XML-filen-->

		<xsl:for-each select="//arende">

			<!-- Skapar en variabel utifrån varje ärendes diarienummer och ersätter / med . för att undvika att iipax får problem med outputens URI -->

			<xsl:variable name="dnr">
					<xsl:value-of select="translate(diarienummer, '/', '.')"/>
			</xsl:variable>

			<!-- Skapa en kopia av XML:n för just denna del -->
			<ii:output ii:fileName="{$dnr}/doc/original.xml">
				<xsl:copy-of select="."/>
			</ii:output>
			
			<!-- Skapar en mapp på servern -->

			<ii:output ii:indent="2" ii:fileName="{$dnr}/Archive.xml">


				<!-- Ska bara vara med. Viktigt att producent och system finns med och överensstämmer med uppgifterna i inlämningskontraktet -->

				<ArchiveSip system="PC Diarium" producer="Kommundelsnämnden Bollebygd" xmlns:ns2="http://www.idainfront.se/schema/archive-2.0-custom" xmlns="http://www.idainfront.se/schema/archive-2.2">
					<ArchiveObject>
						<DisplayName>
							<xsl:value-of select="normalize-space(diarienummer)"/>
						</DisplayName>
						<ObjectType>standardarende</ObjectType>

						<!-- Ärendemening -->
						<xsl:if test="normalize-space(arendemening) != ''">
							<Attribute name="arendemening">
								<Value>
									<xsl:value-of select="normalize-space(arendemening)"/>
								</Value>
							</Attribute>
						</xsl:if>

						<!-- Diarieplan -->
						<xsl:if test="normalize-space(diarieplan) != ''">
							<Attribute name="diarieplanbeteckning">
								<Value>
									<xsl:value-of select="normalize-space(diarieplan)"/>
								</Value>
							</Attribute>
						</xsl:if>

						<!--Ärendestart-->
						<xsl:if test="normalize-space(arendestart) != ''">
							<Attribute name="arendestart_datum">
								<Value>
									<xsl:value-of select="normalize-space(arendestart)"/>
								</Value>
							</Attribute>
						</xsl:if>
						
						<!--Ärendeavslut-->
						<xsl:if test="normalize-space(arendeavslut) != ''">
							<Attribute name="avslutat_datum">
								<Value>
									<xsl:value-of select="normalize-space(arendeavslut)"/>
								</Value>
							</Attribute>
						</xsl:if>
						
						<!--Motpart-->
						<xsl:if test="normalize-space(motpart) != ''">
							<Attribute name="motpart">
								<Value>
									<xsl:value-of select="normalize-space(motpart)"/>
								</Value>
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
							<Value>20</Value>
						</Attribute>
						
						<!-- Lägg till originalinnehåll till arkivobjektet -->
						<File>
							<DisplayName>original.xml</DisplayName>							
							<Content>
								<URI>./doc/original.xml</URI>
							</Content>
						</File>
			  
					</ArchiveObject>
				</ArchiveSip>    		
			</ii:output>

		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>