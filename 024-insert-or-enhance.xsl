<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:marc="http://www.loc.gov/MARC21/slim"
 exclude-result-prefixes="marc">

 <xsl:strip-space elements="*"/>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- <xsl:template match="record[not(marc:datafield[@tag = '024'])]">
    <xsl:text>MATCH NUMBER 1!</xsl:text>
    <xsl:element name="datafield" namespace="http://www.loc.gov/MARC21/slim">
      <xsl:attribute name="tag">024</xsl:attribute>
      <xsl:attribute name="ind1">7</xsl:attribute>
        <xsl:choose>
          <xsl:when test="contains($link, 'doi.org')">
            <xsl:element name="subfield">
              <xsl:attribute name="code">a</xsl:attribute>
              <xsl:value-of select="substring-after($link, 'doi.org/')"/>
            </xsl:element>
            <xsl:element name="subfield">
              <xsl:attribute name="code">2</xsl:attribute>
              <xsl:text>doi</xsl:text>
            </xsl:element>
          </xsl:when>
          <xsl:when test="contains($link, 'handle.net')">
            <xsl:element name="subfield">
              <xsl:attribute name="code">a</xsl:attribute>
              <xsl:value-of select="substring-after($link, 'handle.net/')"/>
            </xsl:element>
            <xsl:element name="subfield">
              <xsl:attribute name="code">2</xsl:attribute>
              <xsl:text>hdl</xsl:text>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>NO MATCH IN </xsl:text>
            <xsl:value-of select="$link"/>
          </xsl:otherwise>
        </xsl:choose>
    </xsl:element>
  </xsl:template> -->

  <xsl:template match="marc:datafield[@tag='024'][not(marc:subfield[@code='2'])]">




          <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="node()"/>
            <xsl:variable name="link">
              <xsl:value-of select="../marc:datafield[@tag='856']/marc:subfield[@code='u']"/>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="contains($link, 'doi.org')">
                <xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
                  <xsl:attribute name="code">2</xsl:attribute>
                  <xsl:text>doi</xsl:text>
                </xsl:element>
              </xsl:when>
              <xsl:when test="contains($link, 'handle.net')">
                <xsl:element name="subfield" namespace="http://www.loc.gov/MARC21/slim">
                  <xsl:attribute name="code">2</xsl:attribute>
                  <xsl:text>hdl</xsl:text>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>NO MATCH IN </xsl:text>
                <xsl:value-of select="$link"/>
              </xsl:otherwise>
          </xsl:choose>
        </xsl:copy>






  </xsl:template>

</xsl:stylesheet>