<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:ii="http://www.idainfront.se/xslt" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:ra="http://xml.ra.se/e-arkiv/FGS-ERMS" xmlns:ca="Cambio" exclude-result-prefixes="xs fn ra fo ca">
<xsl:output indent="yes" media-type="text/xml" encoding="ISO-8859-1"/>

<xsl:param name="documentLocation"/>

<xsl:template match="/">

<xsl:for-each select="/ra:Leveransobjekt/ra:ArkivobjektListaArenden/ra:ArkivobjektArende">

<xsl:variable name="nr"><xsl:value-of select="ra:ArkivobjektID"/></xsl:variable>



<ii:output ii:fileName="{$nr}/doc/original.xml">
				<xsl:copy-of select="."/></ii:output>

<ii:output ii:indent="2" ii:fileName="{$nr}/Archive.xml">


<ArchiveSip system="VIVA" producer="Soc" xmlns:ns2="http://www.idainfront.se/schema/archive-2.0-custom" xmlns="http://www.idainfront.se/schema/archive-2.2">

<ArchiveObject>

<DisplayName><xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Personnummer"/><xsl:text> </xsl:text><xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Namn"/><xsl:text>-</xsl:text><xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:ExtraID"/></DisplayName>

<ObjectType>prnelev</ObjectType>

<Attribute name="personnummer">
											<Value>
												<xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Personnummer"/>
											</Value>
										</Attribute>

<!-- Anger elevens förnamn -->
						
							
							<Attribute name="fornamn">
							
								<Value>
									<xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Förnamn"/>
								</Value>
							</Attribute>
						
						
						<!-- Anger elevens efternamn -->
						
							<Attribute name="efternamn">
								<Value>
									<xsl:value-of select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Efternamn"/>
								</Value>
							</Attribute>
				
						
							<Attribute name="kon">
								<Value>
									<xsl:value-of select="ra:Arendemening"/>
								</Value>
							</Attribute>
						
						
						
							<Attribute name="skola">
								<Value>
									<xsl:value-of select="ra:ArkivobjektID"/>
								</Value>
							</Attribute>
							
							<!-- Sekretess -->
						<Attribute name="secrecy">
							<Value>20</Value>
						</Attribute>

						<!-- PUL -->
						<Attribute name="pul_personal_secrecy">
							<Value>20</Value>
						</Attribute>

						<!-- Övrigt skydd -->
						<Attribute name="other_secrecy">
							<Value>20</Value>
						</Attribute>
						


<xsl:for-each select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Bilagor/ca:Bilaga">





<Document>




							<DisplayName><xsl:number value="position()" format="1"/><xsl:text>.</xsl:text> <xsl:value-of select="ca:Namn"/></DisplayName>

							<ObjectType>prnelev_handling</ObjectType>

							<!-- Sekretess -->
							<Attribute name="secrecy"><Value>20</Value>
							</Attribute>

							<!-- PUL -->
							<Attribute name="pul_personal_secrecy"><Value>20</Value>
							</Attribute>

							<!-- Övrigt skydd -->
							<Attribute name="other_secrecy"><Value>20</Value>
							</Attribute>

							<File>
								
								<DisplayName><xsl:value-of select="ca:Filnamn"/></DisplayName>
								
							
								
								
								<Content>
								<xsl:variable name="removews"><xsl:value-of select="fn:normalize-space(ca:Länk)"/></xsl:variable>

<URI><xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($removews)"/></URI>
								
								
<!-- FUNGERAR! 
<URI><xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri(ca:Lank)"/></URI> -->

<!--
<xsl:analyze-string regex="(D:\\ILAB\\earkiv\\)(.*)" select="ca:Lank">
<xsl:matching-substring>

<URI><xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri(regex-group(2))"/></URI>
</xsl:matching-substring>
</xsl:analyze-string> -->

<!--
<xsl:variable name="FIL">
<xsl:analyze-string regex="(D:\\ILAB\\earkiv\\)(.*)" select="ca:Lank">
<xsl:matching-substring><xsl:value-of select="regex-group(2)"/></xsl:matching-substring>
</xsl:analyze-string>
</xsl:variable>

<URI><xsl:value-of select="$documentLocation"/>/<xsl:value-of select="$FIL"/></URI>-->
								</Content>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>20</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>20</Value>
								</Attribute>

								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>20</Value>
								</Attribute>

							</File>


<!-- GAMMAL SKIT  
<dokumentation>
<xsl:for-each select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Anteckningar/ca:Anteckning">
<xsl:element name="Anteckning">
<xsl:element name="SkapadDatum"><xsl:value-of select="ca:Skapad"/></xsl:element>
<xsl:element name="SkapadAv"><xsl:value-of select="ca:SkapadAv/ca:VisningsNamn"/></xsl:element>

<innehall>
<xsl:for-each select="ca:Dokumentation">
<xsl:element name="Rubrik"><xsl:value-of select="ca:Rubrik"></xsl:value-of></xsl:element>
<xsl:element name="Text"><xsl:value-of select="ca:Text"></xsl:value-of></xsl:element>
</xsl:for-each>
</innehall>
</xsl:element>
</xsl:for-each>



<xsl:for-each select="ra:TillkommandeXMLdata/ca:ArendeInfo/ca:Handlingar/ca:Bilagor">
<Bilagor>
<xsl:for-each select="ca:Bilaga">
<Bilaga>
<Namn><xsl:value-of select="ca:Namn"></xsl:value-of></Namn>
<Fil>
<xsl:analyze-string regex="([\w|\s|_]+\..*$)" select="ca:Lank">
<xsl:matching-substring>
<Filnamn><xsl:value-of select="regex-group(1)"/></Filnamn></xsl:matching-substring>
</xsl:analyze-string>

<xsl:analyze-string regex="(D:\\ILAB\\earkiv\\)(.*)" select="ca:Lank">
<xsl:matching-substring>
<Lank><xsl:value-of select="regex-group(2)"/></Lank></xsl:matching-substring>
</xsl:analyze-string>
</Fil>


</Bilaga>
</xsl:for-each>

</Bilagor>
</xsl:for-each>





</dokumentation>
-->

</Document>
</xsl:for-each>

<Document>

							<DisplayName>original.xml</DisplayName>

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
							  <Value>VIVA</Value>
							</Attribute>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>20</Value>
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
