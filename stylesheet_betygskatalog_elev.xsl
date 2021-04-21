<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">

<xsl:output method="html" indent="yes" encoding="UTF-8"/>
    <xsl:template match="/">
            <html>
                <meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/>
                <head>
                    <style>
                    body {
  background: gray;
}
#elevinformation {
  font-family:courier;
  font-size:large;
  padding-bottom: 1%;
} 
.paper {
  background: #fff;
  margin-left: 15%;
  margin-right: 15%;
  box-shadow:
    0 1px 1px rgba(0,0,0,0.15),
    0 10px 0 -5px #eee,
    0 10px 1px -4px rgba(0,0,0,0.15),
    0 20px 0 -10px #eee,
    0 20px 1px -9px rgba(0,0,0,0.15);
    padding: 30px;
}

table {
  width: 100%;
  empty-cells: show;
  table-layout: fixed;
}
th {
  height: 30px;
  text-align: left;
  word-wrap: break-word;
}
td {
  height: 20px;
  vertical-align: bottom;
  border-bottom: 1px solid black;
  font-family:courier;
  font-size:small;
  word-wrap: break-word;
}

.smal {
	width: 5%;
}

.medium {
	width: 8%;
}

.big {width: 25%;

}



tr:hover {background-color: #f5f5f5;}

#pdffinns {
	font-family:courier;
	font-weight: bold;
	margin-left: 30%;
	}
                    
                    
                    </style>
                </head>
                <body>
                <div class="paper">
  <h1>Betygskatalog</h1>
  <xsl:for-each select="//elev">
  <p id="elevinformation"><xsl:value-of select="//elevinformation/fornamn"/><xsl:text> </xsl:text><xsl:value-of select="//elevinformation/efternamn"/><xsl:text>, </xsl:text><xsl:value-of select="//elevinformation/personnummer"/></p>
  <h2>Kurser</h2>
<table>
  <th class="big">Kurs</th>
				<th class="smal">Poäng</th>
				<th class="smal">Betyg</th>
				<th>Betygsdatum</th>
				<th>Kurskod</th>
				<th>Kursgrupp</th>
				<th>Ämne</th>
				<th>Ämneskod</th>
				<th class="smal">Prövn/korr.</th>
				<th class="medium">Datum</th>
 <xsl:for-each select="//kurser/kurs">
  <tr>
    <td><xsl:value-of select="kursnamn"/></td>
    <td><xsl:value-of select="poang"/></td>
    <td><xsl:value-of select="betyg"/></td>
    <td><xsl:value-of select="betygsdatum"/></td>
    <td><xsl:value-of select="kurskod"/></td>
    <td><xsl:value-of select="kursgrupp"/></td>
    <td><xsl:value-of select="amne"/></td>
    <td><xsl:value-of select="amneskod"/></td>
    <td><xsl:value-of select="betyg_provning_korrigering"/></td>
    <td><xsl:value-of select="betygsdatum_provning_korrigering"/></td>
  </tr>
  </xsl:for-each>
  </table>
  
  <xsl:if test="//betygskatalog_utdrag_pdf">
  <xsl:variable name="fil"><xsl:value-of select="betygskatalog_utdrag_pdf"/></xsl:variable>
 
  <br></br><a id="pdffinns" href="../{$fil}/{$fil}">Ytterligare utrag ur betygskatalog finns som pdf.</a>  
  
  </xsl:if>
  </xsl:for-each>  
  </div>

                </body>
             </html>
    </xsl:template>




</xsl:stylesheet>
