<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:ii="http://www.idainfront.se/xslt" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:ra="http://xml.ra.se/e-arkiv/FGS-ERMS" exclude-result-prefixes="xs fn ra fo">
<xsl:output indent="yes" media-type="text/xml" encoding="ISO-8859-1"/>

<xsl:param name="documentLocation"/>

<xsl:template match="/">

<xsl:for-each select="/LEVERANS/OBJEKT">

<xsl:variable name="nr"><xsl:value-of select="ID"/></xsl:variable>

<ii:output ii:indent="2" ii:fileName="{$nr}/Archive.xml">

<ArchiveSip system="Magna Cura" producer="IT vård och omsorg" xmlns:ns2="http://www.idainfront.se/schema/archive-2.0-custom" xmlns="http://www.idainfront.se/schema/archive-2.2">

<ArchiveObject>

<DisplayName><xsl:value-of select="ID"/></DisplayName>

<ObjectType>mc</ObjectType>

<Attribute name="personnummer">
<Value><xsl:value-of select="Personnummer"/></Value></Attribute>

<Attribute name="gallring">
<Value><xsl:value-of select="Gallringsar"/></Value></Attribute>

<Attribute name="leveransnummer">
<Value><xsl:text>Saknas</xsl:text></Value></Attribute>



							
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
						


<xsl:for-each select="Fil">



							<File>
								
								<DisplayName><xsl:value-of select="Filnamn"/></DisplayName>
								
<xsl:variable name="referens"><xsl:value-of select="Path"/>/<xsl:value-of select="Filnamn"/></xsl:variable>							
								
								
								<Content>

<URI><xsl:value-of select="$documentLocation"/>/<xsl:value-of select="fn:encode-for-uri($referens)"/></URI>
								
								</Content>

								<!-- Sekretess -->
								<Attribute name="secrecy"><Value>0</Value>
								</Attribute>

								<!-- PUL -->
								<Attribute name="pul_personal_secrecy"><Value>0</Value>
								</Attribute>

								<!-- Övrigt skydd -->
								<Attribute name="other_secrecy"><Value>0</Value>
								</Attribute>

							</File>





</xsl:for-each>




</ArchiveObject>

</ArchiveSip>

</ii:output>
</xsl:for-each>









</xsl:template>










</xsl:stylesheet>
