<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ii="http://www.idainfront.se/xslt">
	<xsl:output method="xml" indent="yes" encoding="ISO-8859-1"/>

	<!-- Anger var adapterytan ska leta efter filerna -->
	<xsl:param name="documentLocation"/>  

	<!-- Startar från rootnooden i XML-filen -->
	<xsl:template match="/">

		<!-- Här börjar skriptet i XML-filen-->

		<xsl:for-each select="//PATIENT">

			<!-- Hämta personnummer för varje Patient. Varje gång vi skriver variabeln dnr i skriptet så menar vi värdet som står i PAT_ID -->

			<xsl:variable name="dnr" select="normalize-space(PAT_ID)"/>

			<!-- Skapa en kopia av XML:n för just denna del och ger den ett filnamn baserat på patientens personnummer -->
			<ii:output ii:fileName="{$dnr}/doc/{$dnr}.xml">
				<xsl:copy-of select="."/>
			</ii:output>
			
			<!-- Skapar en mapp på servern och lägger informationen i en archive.xml -->

			<ii:output ii:indent="2" ii:fileName="{$dnr}/Archive.xml">


				<!-- Ska bara vara med. Viktigt att producent och system finns med och överensstämmer med uppgifterna i inlämningskontraktet -->

				<ArchiveSip system="TEAM-FHV" producer="Borås Stads kommunhälsa" xmlns:ns2="http://www.idainfront.se/schema/archive-2.0-custom" xmlns="http://www.idainfront.se/schema/archive-2.2">
					<ArchiveObject>
						<!-- Skapar displayName på arkivobjektet utifrån personnummer och lägger till sekelsiffran 19-->
						<DisplayName>
							<xsl:text>19</xsl:text><xsl:value-of select="normalize-space(PAT_ID)"/>
						</DisplayName>
						<!-- Mappningen i scriptet sker mot nedanstående objektsspecifikation-->
						<ObjectType>Asynja_journal</ObjectType>

						<!-- Förnamn -->
						<xsl:if test="normalize-space(PAT_FIRSTNAME) != ''">
							<Attribute name="fornamn">
								<Value>
									<xsl:value-of select="normalize-space(PAT_FIRSTNAME)"/>
								</Value>
							</Attribute>
						</xsl:if>

						<!-- Efternamn -->
						<xsl:if test="normalize-space(PAT_LASTNAME) != ''">
							<Attribute name="efternamn">
								<Value>
									<xsl:value-of select="normalize-space(PAT_LASTNAME)"/>
								</Value>
							</Attribute>
						</xsl:if>
						
						<!--Handlingstyp-->
						<Attribute name="handling_typ">
							<Value>HSL-journal</Value>
						</Attribute>
						
						<!--Leveransnummer-->
						<Attribute name="leveransnummer">
						<Value>Inget leveransnummer</Value>
						</Attribute>
						
						<!-- Sekretess -->
						<Attribute name="secrecy">
							<Value>20</Value>
						</Attribute>
						
						<!--Sekretessbeslut-->
						<Attribute name="sekretess_lagrum">
							<Value>25 kap. 1 § offentlighets- och sekretesslagen</Value>
						</Attribute>

						<!-- PUL -->
						<Attribute name="pul_personal_secrecy">
							<Value>20</Value>
						</Attribute>

						<!-- Övrigt skydd -->
						<Attribute name="other_secrecy">
							<Value>20</Value>
						</Attribute>
						
						<!-- Lägg till originalinnehåll till arkivobjektet och ge xml-filen namn efter patientens personnummer -->
						<File>
							<DisplayName><xsl:value-of select="normalize-space(PAT_ID)"/>.xml</DisplayName>
							<Attribute name="stylesheet">
							  <Value>kommunhalsanjournal</Value>
							</Attribute>
							
						<!-- Sekretess -->
						<Attribute name="secrecy">
							<Value>20</Value>
						</Attribute>
						
						<!--Sekretessbeslut-->
						<Attribute name="paragraph">
							<Value>25 kap. 1 § offentlighets- och sekretesslagen</Value>
						</Attribute>

						<!-- PUL -->
						<Attribute name="pul_personal_secrecy">
							<Value>20</Value>
						</Attribute>

						<!-- Övrigt skydd -->
						<Attribute name="other_secrecy">
							<Value>20</Value>
						</Attribute>
							<!-- Sökvägen till xml-filen-->
							<Content>
								<URI>./doc/<xsl:value-of select="normalize-space(PAT_ID)"/>.xml</URI>
							</Content>
						</File>
			  
					</ArchiveObject>
				</ArchiveSip>    		
			</ii:output>

		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>