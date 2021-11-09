<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:fgs="eARDERMS" xmlns:ii="http://www.idainfront.se/xslt" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="xs fn fgs">
	<xsl:output indent="yes" media-type="text/xml" encoding="ISO-8859-1"/>
	<xsl:param name="documentLocation"/>
	
	
	<!--TOPNOD -->
	<xsl:template match="/">
	<xsl:apply-templates select="//fgs:ArkivobjektArende"/>
	</xsl:template>

	<!-- Arkivobjekt -->
	<xsl:template match="fgs:ArkivobjektArende">
		
		<!--Variabel för namn på respektive folder -->
		<xsl:variable name="folder">
			<xsl:value-of select="fn:translate(fgs:ArkivobjektID, ' -', '__')"/>
		</xsl:variable>
		
		<!--Skapar en kopia av ursprungsfilen -->
		<ii:output ii:fileName="{$folder}/doc/original.xml">
			<xsl:copy-of select="."/>
		</ii:output>
		
		<!-- Skapar SIP:en -->
		<ii:output ii:indent="2" ii:fileName="{$folder}/Archive.xml">
			<ArchiveSip system="ByggR" producer="Samhällsbyggnadsnämnden" xmlns:ns2="http://www.idainfront.se/schema/archive-2.0-custom" xmlns="http://www.idainfront.se/schema/archive-2.2">
				<ArchiveObject>
					
					<DisplayName><xsl:value-of select="fgs:ArkivobjektID"/><xsl:text>. </xsl:text><xsl:value-of select="fn:normalize-space(fgs:Arendemening)"/></DisplayName>
					
					<Attribute name="diarienummer">
						<Value><xsl:value-of select="fgs:ArkivobjektID"/></Value>
					</Attribute>
					
					<Attribute name="motpart_diarienummer">
						<Value><xsl:value-of select="fgs:ExtraID"/></Value>
					</Attribute>
					
					<Attribute name="arende_typ">
						<Value><xsl:value-of select="fn:normalize-space(fgs:ArendeTyp)"/></Value>
					</Attribute>
					
					<Attribute name="avslutat_datum">
						<Value><xsl:value-of select="fgs:Avslutat"/></Value>
					</Attribute>
					
					<Attribute name="beskrivning">
						<Value><xsl:value-of select="fn:normalize-space(fgs:Beskrivning)"/></Value>
					</Attribute>
					
					<Attribute name="skapad_datum">
						<Value><xsl:value-of select="fgs:Skapad"/></Value>
					</Attribute>					
					
					<xsl:if test="fgs:Inkommen !=''">
					<Attribute name="inkom">
						<Value><xsl:value-of select="fgs:Inkommen"/></Value>
					</Attribute>
					</xsl:if>
					
					<Attribute name="arendestart_datum">
						<Value><xsl:value-of select="fgs:Upprattad"/></Value>
					</Attribute>
					
					<!--OBS!!! FEL I XML-FILEN FRÅN BYGGR "ARENDE"-->
					<Attribute name="riktning">
						<Value><xsl:value-of select="fgs:StatusArande"/></Value>
					</Attribute>
					
					<xsl:if test="fgs:Expedierad !=''">
					<Attribute name="expedierad_datum">
						<Value><xsl:value-of select="fgs:Expedierad"/></Value>
					</Attribute>
					</xsl:if>
					
					<Attribute name="arendemening">
						<Value><xsl:value-of select="fn:normalize-space(fgs:Arendemening)"/></Value>
					</Attribute>
					
					<xsl:if test="fgs:Notering">
						<Attribute name="anteckningar">
							<Value><xsl:value-of select="fgs:Notering"/></Value>
						</Attribute>
					</xsl:if>
					
					<xsl:if test="fgs:Beslutat">
						<Attribute name="beslutsdatum">
							<Value><xsl:value-of select="fgs:Beslutat"/></Value>
						</Attribute>
					</xsl:if>
					
					<Attribute name="fastighetsbeteckning">
						<Value><xsl:value-of select="fgs:EgnaElement/fgs:EgetElement[@Namn='Fastighetsbeteckning']/fgs:Varde"/></Value>
					</Attribute>
					
					<Attribute name="fastighetsnummer">
						<Value><xsl:value-of select="fgs:EgnaElement/fgs:EgetElement[@Namn='Fastighetsnummer(Fnr)']/fgs:Varde"/></Value>
					</Attribute>
					
					<Attribute name="adress">
						<Value><xsl:value-of select="fgs:EgnaElement/fgs:EgetElement[@Namn='Belagenhetsadress']/fgs:Varde"/></Value>
					</Attribute>
					
					<Attribute name="beslutsinstans">
						<Value><xsl:value-of select="fgs:EgnaElement/fgs:EgetElement[@Namn='BeslutsInstans']/fgs:Varde"/></Value>
					</Attribute>
					
					<Attribute name="beslutsnummer">
						<Value><xsl:value-of select="fgs:EgnaElement/fgs:EgetElement[@Namn='BeslutNr']/fgs:Varde"/></Value>
					</Attribute>
					
					
					<Attribute name="secrecy">
						<Value>0</Value>
					</Attribute>

					<Attribute name="pul_personal_secrecy">
						<Value>0</Value>
					</Attribute>
					
					<Attribute name="other_secrecy">
						<Value>0</Value>
					</Attribute>

					
					<xsl:apply-templates select="fgs:ArkivobjektListaHandlingar/fgs:ArkivobjektHandling"/>
					<xsl:call-template name="xmlfil"/>
				
				</ArchiveObject>
			</ArchiveSip>
		</ii:output>
		
	</xsl:template>
		
	<!--Template för Handlingsnivå -->	
	<xsl:template match="fgs:ArkivobjektListaHandlingar/fgs:ArkivobjektHandling" xmlns:ns2="http://www.idainfront.se/schema/archive-2.0-custom" xmlns="http://www.idainfront.se/schema/archive-2.2">
		<Document>
		<ObjectType>ByggR_handling</ObjectType>
		<DisplayName><xsl:number value="position()" format="1"/><xsl:text>. </xsl:text><xsl:value-of select="fgs:Handlingstyp"/></DisplayName>
		<Attribute name="handling_typ">
			<Value><xsl:value-of select="fgs:Handlingstyp"/></Value>
		</Attribute>
		
		<xsl:if test="fgs:Inkommen">
			<Attribute name="inkom">
				<Value><xsl:value-of select="fgs:Inkommen"/></Value>
			</Attribute>
		</xsl:if>
		
		<xsl:if test="fgs:Expedierad">
			<Attribute name="expedierad">
				<Value><xsl:value-of select="fgs:Expedierad"/></Value>
			</Attribute>
		</xsl:if>
		
		<xsl:if test="fgs:Beskrivning">
			<Attribute name="anteckningar">
				<Value><xsl:value-of select="fgs:Beskrivning"/></Value>
			</Attribute>
		</xsl:if>
		
		<Attribute name="riktning">
			<Value><xsl:value-of select="fgs:StatusHandling"/></Value>
		</Attribute>
				
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
		
		<xsl:apply-templates select="fgs:Bilaga"/>
		</Document>
	</xsl:template>	
	
	
	<!--Template för Filer -->
	<xsl:template match="fgs:Bilaga" xmlns:ns2="http://www.idainfront.se/schema/archive-2.0-custom" xmlns="http://www.idainfront.se/schema/archive-2.2">
		
		<!-- Variabel för att hämta ut filnamnet ur @Lank -->
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
	
	</xsl:template>
	
	<!-- Template för att bifoga ursprungs-xml -->
	<xsl:template name="xmlfil" xmlns:ns2="http://www.idainfront.se/schema/archive-2.0-custom" xmlns="http://www.idainfront.se/schema/archive-2.2">
		<Document>
		<DisplayName>originaldata</DisplayName>
		<ObjectType>xml_document</ObjectType>

		<Attribute name="secrecy">
			<Value>0</Value>
		</Attribute>
							
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
				<Value>ByggR</Value>
			</Attribute>
			
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

		</Document>
	</xsl:template>
	
</xsl:stylesheet>
