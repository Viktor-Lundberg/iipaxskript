<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" indent="yes" encoding="UTF-8"/>
	<xsl:template match="/">
		<html>
			<meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/>
			<head>
				<style>
			.main{
				border: 5px solid #ffe689;
				border-spacing: 2px;
				background-color: #ffe689;
				margin-top: 25px;
				margin-bottom: 60px;
			}			
			table{
				font-family: 'Times New Roman', Times, serif;
				font-size: small;
				
			}
		</style>
			</head>
			<body>
				<!-- Ärende -->
				<xsl:for-each select="/ArkivobjektArende">
					<table style="width: 825px;">
						<tr>
							<td>
								<b>Diarienummer</b>
							</td>
							<td>
								<b>Diarium</b>
							</td>
						</tr>
						<tr>
							<td>
								<xsl:if test="normalize-space(Diarienummer) != ''">
									<xsl:value-of select="normalize-space(Diarienummer)"/>
								</xsl:if>
							</td>
							<td>
								<xsl:value-of select="normalize-space(Modulens_namn)"/>
							</td>
						</tr>
					</table>
					<table class="main" style="width: 825px;">
						<tr>
							<td>
								<p>
									<b>Ärende</b>
								</p>
							</td>
						</tr>
						<tr>
							<td style="width: 20%;" bgcolor="#fdfce8">Diarieplan</td>
							<td bgcolor="#ffffff" style="width: 30%; font-weight:bold;">
								<xsl:choose>
									<xsl:when test="normalize-space(Diarieplansbeteckning_Kod) != '' and normalize-space(Diarieplansbeteckning_Beskrivning) != ''">
										<xsl:value-of select="normalize-space(concat(Diarieplansbeteckning_Kod, ' ', Diarieplansbeteckning_Beskrivning))"/>
									</xsl:when>
									<xsl:otherwise>Auto-genererat: diareplanbeteckning saknas</xsl:otherwise>
								</xsl:choose>
							</td>
							<td style="width: 20%;" bgcolor="#fdfce8">Diarienummer</td>
							<td bgcolor="#ffffff" style="width: 30%; font-weight:bold;">
								<xsl:if test="normalize-space(Diarienummer) != ''">
									<xsl:value-of select="normalize-space(Diarienummer)"/>
								</xsl:if>
							</td>
						</tr>
						<tr>
							<td style="width: 20%;" bgcolor="#fdfce8">Ärendemening</td>
							<td bgcolor="#ffffff" colspan="3" style="font-weight: bold;">
								<xsl:choose>
									<xsl:when test="normalize-space(Arendemening) != ''">
										<xsl:value-of select="normalize-space(Arendemening)"/>
									</xsl:when>
									<xsl:otherwise>Auto-genererat: Ärendemening saknas</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
						<tr>
							<td style="width: 20%;" bgcolor="#fdfce8">Ärendestart</td>
							<td bgcolor="#ffffff" colspan="3" style="font-weight: bold;">
								<xsl:if test="normalize-space(Datum_arende) != ''">
									<xsl:value-of select="normalize-space(Datum_arende)"/>
								</xsl:if>
							</td>
						</tr>
						<tr>
							<td style="width: 20%;" bgcolor="#fdfce8">Registreringsdatum</td>
							<td bgcolor="#ffffff" colspan="3" style="font-weight: bold;">
								<xsl:if test="normalize-space(Registrerat) != ''">
									<xsl:variable name="nums" select="string-length(Registrerat)-string-length(translate(Registrerat,'/',''))"/>
									<xsl:choose>
										<xsl:when test="$nums > 1">
											<xsl:value-of select="concat(substring(Registrerat, 7, 4), '-', substring(Registrerat, 4, 2), '-', substring(Registrerat, 1, 2), ' ', substring(Registrerat, 12))"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="normalize-space(Registrerat)"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</td>
						</tr>
						<tr>
							<td style="width: 20%;" bgcolor="#fdfce8">Registrerat av</td>
							<td bgcolor="#ffffff" colspan="3" style="font-weight: bold;">
								<xsl:if test="normalize-space(Registrerat_av) != ''">
									<xsl:value-of select="normalize-space(Registrerat_av)"/>
								</xsl:if>
							</td>
						</tr>
						<tr>
							<td style="width: 20%;" bgcolor="#fdfce8">Motpart</td>
							<td bgcolor="#ffffff" colspan="3" style="font-weight: bold;">
								<xsl:if test="normalize-space(Inkom_fran) != ''">
									<xsl:value-of select="normalize-space(Inkom_fran)"/>
								</xsl:if>
							</td>
						</tr>
						<tr>
							<td style="width: 20%;" bgcolor="#fdfce8">Personuppgiftsklassning</td>
							<td bgcolor="#ffffff" colspan="3" style="font-weight: bold;">
								<xsl:if test="normalize-space(Dolj_enligt_PUL) = 'Ja'">Skyddad</xsl:if>
							</td>
						</tr>
						<tr>
							<td style="width: 20%;" bgcolor="#fdfce8">Huvudobjekt/programområde</td>
							<td bgcolor="#ffffff" colspan="3" style="font-weight: bold;">
								<xsl:if test="normalize-space(Huvudobjekt) != ''">
									<xsl:value-of select="normalize-space(Huvudobjekt)"/>
								</xsl:if>
							</td>
						</tr>
						<tr>
							<td style="width: 20%;" bgcolor="#fdfce8">Enhet</td>
							<td bgcolor="#ffffff" colspan="3" style="font-weight: bold;">
								<xsl:if test="normalize-space(Handlaggande_enhet) != ''">
									<xsl:value-of select="normalize-space(Handlaggande_enhet)"/>
								</xsl:if>
							</td>
						</tr>
						<tr>
							<td style="width: 20%;" bgcolor="#fdfce8">Handläggare</td>
							<td bgcolor="#ffffff" colspan="3" style="font-weight: bold;">
								<xsl:if test="normalize-space(Handlaggare) != ''">
									<xsl:value-of select="normalize-space(Handlaggare)"/>
								</xsl:if>
							</td>
						</tr>
						<tr>
							<td style="width: 20%;" bgcolor="#fdfce8">Avslutsdatum</td>
							<td bgcolor="#ffffff" colspan="3" style="font-weight: bold;">
								<xsl:if test="normalize-space(Avslutad) != ''">
									<xsl:value-of select="normalize-space(Avslutad)"/>
								</xsl:if>
							</td>
						</tr>
						<tr>
							<td style="width: 20%;" bgcolor="#fdfce8">Avslutat av</td>
							<td bgcolor="#ffffff" colspan="3" style="font-weight: bold;">
								<xsl:if test="normalize-space(Avslutad_av) != ''">
									<xsl:value-of select="normalize-space(Avslutad_av)"/>
								</xsl:if>
							</td>
						</tr>
						<tr>
							<td style="width: 20%;" bgcolor="#fdfce8">Avslutsorsak</td>
							<td bgcolor="#ffffff" colspan="3" style="font-weight: bold;">
								<xsl:if test="normalize-space(Avslutad_orsak) != ''">
									<xsl:value-of select="normalize-space(Avslutad_orsak)"/>
								</xsl:if>
							</td>
						</tr>
						<tr>
							<td style="width: 20%;" bgcolor="#fdfce8">Anteckningar</td>
							<td bgcolor="#ffffff" colspan="3" style="font-weight: bold;">
								<xsl:if test="normalize-space(Anteckningar) != ''">
									<xsl:value-of select="normalize-space(Anteckningar)"/>
								</xsl:if>
							</td>
						</tr>
						<tr>
							<td/>
						</tr>
					</table>
				</xsl:for-each>
				<!-- Handling -->
				<xsl:for-each select="/ArkivobjektArende/ArkivobjektListaHandlingar/Arkivobjekthandling">
					<table class="main" style="width: 825px;">
							<tr>
								<td>
									<p>
										<b>Händelse</b>
									</p>
								</td>
							</tr>
							<tr>
								<td style="width: 20%;" bgcolor="#fdfce8">Händelsetext</td>
								<td bgcolor="#ffffff" colspan="3" style="font-weight: bold;">
									<xsl:if test="normalize-space(Beskrivning) != ''">
										<xsl:value-of select="normalize-space(Beskrivning)"/>
									</xsl:if>
								</td>
							</tr>
							<tr>
								<td style="width: 20%;" bgcolor="#fdfce8">Handlingsdatum</td>
								<td bgcolor="#ffffff" colspan="3" style="font-weight: bold;">
									<xsl:if test="normalize-space(Inkom) != '' and not(contains(normalize-space(Inkom), 'Incorrect data type'))">
										<xsl:value-of select="normalize-space(Inkom)"/>
									</xsl:if>
								</td>
							</tr>
							<tr>
								<td style="width: 20%;" bgcolor="#fdfce8">Riktning</td>
								<td bgcolor="#ffffff" style="width: 30%;">
									<xsl:if test="normalize-space(Riktning) != ''">
										<xsl:value-of select="normalize-space(Riktning)"/>
									</xsl:if>
								</td>
								<td style="width: 20%;" bgcolor="#fdfce8">Handlingstyp</td>
								<td bgcolor="#ffffff" style="width: 30%; font-weight: bold;">
									<xsl:if test="normalize-space(Typ_av_handling) != ''">
										<xsl:value-of select="normalize-space(Typ_av_handling)"/>
									</xsl:if>
								</td>
							</tr>
							<tr>
								<td style="width: 20%;" bgcolor="#fdfce8">Avsändare</td>
								<td bgcolor="#ffffff" colspan="3" style="font-weight: bold;">
									<xsl:if test="normalize-space(Avsandare) != ''">
										<xsl:value-of select="normalize-space(Avsandare)"/>
									</xsl:if>
								</td>
							</tr>
							<tr>
								<td style="width: 20%;" bgcolor="#fdfce8">Sekretess</td>
								<td bgcolor="#ffffff" colspan="3" style="font-weight: bold;">
								<xsl:choose>
									<xsl:when test="normalize-space(Sekretess) = 'Yes' "><input style="transform: scale(0.8);" type="radio" checked="checked" readonly="readonly"/>Ja <input style="transform: scale(0.8);" type="radio"  disabled="disabled"/>Nej</xsl:when>
									<xsl:otherwise><input style="transform: scale(0.8);" type="radio" readonly="readonly" disabled="disabled"/>Ja <input style="transform: scale(0.8);" type="radio" checked="checked"/>Nej
									</xsl:otherwise>
								</xsl:choose>
									
									
								</td>
							</tr>
							<tr>
								<td style="width: 20%;" bgcolor="#fdfce8">Sekretessbeslut</td>
								<td bgcolor="#ffffff" colspan="3" style="font-weight: bold;">
									<xsl:if test="normalize-space(Sekretessbeslut) != ''">
										<xsl:value-of select="normalize-space(Sekretessbeslut)"/>
									</xsl:if>
								</td>
							</tr>
							<tr>
								<td style="width: 20%;" bgcolor="#fdfce8">Personuppgiftsklassning</td>
								<td bgcolor="#ffffff" colspan="3" style="font-weight: bold;">
									<xsl:if test="normalize-space(Dolj_enligt_PUL) = 'Ja'">Skyddad</xsl:if>
								</td>
							</tr>
							<tr>
								<td style="width: 20%;" bgcolor="#fdfce8">Handläggare</td>
								<td bgcolor="#ffffff" colspan="3" style="font-weight: bold;">
									<xsl:if test="normalize-space(Handlaggare) != ''">
										<xsl:value-of select="normalize-space(Handlaggare)"/>
									</xsl:if>
								</td>
							</tr>
							<tr>
								<td style="width: 20%;" bgcolor="#fdfce8">Övrig text</td>
								<td bgcolor="#ffffff" colspan="3">
									<xsl:if test="normalize-space(Ovrig_text) != ''">
										<xsl:value-of select="normalize-space(Ovrig_text)" disable-output-escaping="yes"/>
									</xsl:if>
								</td>
							</tr>
							<tr>
								<td style="width: 20%;" bgcolor="#fdfce8">Anteckningar</td>
								<td bgcolor="#ffffff" colspan="3" style="font-weight: bold;">
									<xsl:if test="normalize-space(Noteringar) != ''">
										<xsl:value-of select="normalize-space(Noteringar)"/>
									</xsl:if>
								</td>
							</tr>
							<tr>
								<td/>
							</tr>
							<xsl:if test="count(Filer/Fil) &gt; 0">
								<tr>
									<td>
										<p>
											<b>Ingående filer</b>
										</p>
									</td>
								</tr>
								<xsl:for-each select="Filer/Fil">
									<tr>
										<td colspan="4">
											<table class="second" style="margin-left:5px; width: 100%;">
												<tr>
													<td style="width: 20%;" bgcolor="#fdfce8">FIL</td>
													<td bgcolor="#ffffff" colspan="3" style="font-weight: bold;">
														<xsl:value-of select="text()"/>
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</xsl:for-each>
							</xsl:if>
						</table>
				</xsl:for-each>					
				
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
