<?xml version="1.0" encoding="utf-8"?>
<xsl:transform xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:date="http://exslt.org/dates-and-times" xmlns:doc="http://exslt.org/common" version="1.0" xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd" extension-element-prefixes="date doc">
  <xsl:output method="xml" encoding="utf-8" omit-xml-declaration="yes" indent="yes"/>
  <xsl:strip-space elements="*"/>
<!-- ############# -->
<!-- root -->
  <xsl:template match="marc:collection">
    <xsl:apply-templates select="marc:record"/>
  </xsl:template>
<!-- ####################################### -->
<!-- records -->
  <xsl:template match="marc:record">
<!-- the marc xml is ever-changing, so this is deprecated: -->
    <xsl:for-each select="marc:datafield[@tag=035]/marc:subfield[@code='a']">
      <xsl:variable name="idno">
<!--     lc the idno and rm the (dli) -->
        <xsl:value-of select="translate(translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'(dli)','')"/>
      </xsl:variable>
      <xsl:if test="starts-with($idno,'heb')">
        <xsl:element name="HEADER">
          <FILEDESC>
            <TITLESTMT>
<!-- pass title sort character if not 0 -->
              <xsl:apply-templates select="../../marc:datafield[@tag=245]">
                <xsl:with-param name="sortchar">
<!-- substring seems to start at zero, so add 1 -->
                  <xsl:value-of select="(../../marc:datafield[@tag=245]/@ind2) +1"/>
                </xsl:with-param>
                <xsl:with-param name="maintitle">yes</xsl:with-param>
              </xsl:apply-templates>
<!-- Get all authors, main and alt -->
              <xsl:apply-templates select="../../marc:datafield[@tag=100]"/>
              <xsl:for-each select="../../marc:datafield[@tag=700]">
                <xsl:apply-templates select="."/>
              </xsl:for-each>
              <xsl:apply-templates select="../../marc:datafield[@tag=110]"/>
            </TITLESTMT>
<!-- NOTE!  Downstream processing for level-4 items will replace this with something more apppropriate. -->
            <EXTENT>600dpi TIFF G4 page images</EXTENT>
            <PUBLICATIONSTMT>
              <PUBLISHER>MPublishing, University of Michigan Library</PUBLISHER>
              <PUBPLACE>Ann Arbor, Michigan</PUBPLACE>
              <xsl:element name="IDNO">
                <xsl:attribute name="TYPE">heb</xsl:attribute>
<!-- rm hyphens and lower case -->
                <xsl:value-of select="$idno"/>
              </xsl:element>
              <AVAILABILITY>
                <P>Permission must be received for any subsequent distribution in print or electronically. Please contact info@hebook.org for more information.</P>
              </AVAILABILITY>
            </PUBLICATIONSTMT>
<!-- SERIESSTMT -->
<!-- After much back and forth: get the series statements from multiple locations. Don't worry about duplicates, just put everything in the header to be worried about downstream -->
            <SERIESSTMT>
              <xsl:for-each select="../../marc:datafield[@tag=533]/marc:subfield[@code='f']">
                <xsl:apply-templates select="."/>
              </xsl:for-each>
              <xsl:for-each select="../../marc:datafield[@tag=830]/marc:subfield[@code='a']">
                <xsl:apply-templates select="." />
              </xsl:for-each>
              <xsl:for-each select="../../marc:datafield[@tag=440]/marc:subfield[@code='a']">
                <xsl:apply-templates select="." />
		<!-- Ensure this is here in the header. Required for item to appear in non-series searches in DLXS -->
		<TITLE>ACLS Humanities E-Book</TITLE>
              </xsl:for-each>
            </SERIESSTMT>
            <SOURCEDESC>
              <BIBLFULL>
                <TITLESTMT>
                  <xsl:apply-templates select="../../marc:datafield[@tag=245]">
                    <xsl:with-param name="maintitle">no</xsl:with-param>
                  </xsl:apply-templates>
                  <xsl:apply-templates select="../../marc:datafield[@tag=240]"/>
                  <xsl:apply-templates select="../../marc:datafield[@tag=246]"/>
                  <xsl:apply-templates select="../../marc:datafield[@tag=100]"/>
                  <xsl:for-each select="../../marc:datafield[@tag=700]">
                    <xsl:apply-templates select="."/>
                  </xsl:for-each>
                  <xsl:apply-templates select="../../marc:datafield[@tag=110]"/>
                </TITLESTMT>
                <EXTENT>
                  <xsl:apply-templates select="../../marc:datafield[@tag=310]"/>
                  <xsl:apply-templates select="../../marc:datafield[@tag=362]"/>
                </EXTENT>
                <PUBLICATIONSTMT>
                  <xsl:apply-templates select="../../marc:datafield[@tag=260]"/>
                </PUBLICATIONSTMT>
                <NOTESSTMT>
                  <xsl:apply-templates select="../../marc:datafield[@tag=500]/marc:subfield"/>
                  <xsl:apply-templates select="../../marc:datafield[@tag=856]">
<!--     pass the idno as new parameter 'pidno' -->
                    <xsl:with-param name="pidno">
                      <xsl:value-of select="$idno"/>
                    </xsl:with-param>
                  </xsl:apply-templates>
                  <xsl:apply-templates select="../../marc:datafield[@tag=776]/marc:subfield[@code='z']"/>
                </NOTESSTMT>
              </BIBLFULL>
            </SOURCEDESC>
          </FILEDESC>
          <ENCODINGDESC>
            <PROJECTDESC>
              <P>Header created via MARC-to-XML-to-TEI transformation on <xsl:text/> 
       <!-- <xsl:value-of select="substring-before(date:date(),':')" /> -->
       <xsl:value-of select="substring(date:date(),1,10)"/>
     </P>
            </PROJECTDESC>
<!-- NOTE!  Downstream processing for level-4 items will replace this with something more apppropriate. -->
            <EDITORIALDECL N="2">
              <P>This electronic text file was created by Optical Character Recognition (OCR). No corrections have been made to the OCR-ed text and no editing has been done to the content of the original document. Encoding has been done through automated and manual processes using the recommendations for Level 2 of the TEI in Libraries Guidelines. Digital page images are linked to the text file.</P>
            </EDITORIALDECL>
          </ENCODINGDESC>
          <PROFILEDESC>
            <TEXTCLASS>
              <KEYWORDS>
                <xsl:apply-templates select="../../marc:datafield[@tag=600]"/>
                <xsl:apply-templates select="../../marc:datafield[@tag=610]"/>
                <xsl:apply-templates select="../../marc:datafield[@tag=611]"/>
                <xsl:apply-templates select="../../marc:datafield[@tag=630]"/>
                <xsl:apply-templates select="../../marc:datafield[@tag=648]"/>
                <xsl:apply-templates select="../../marc:datafield[@tag=650]"/>
                <xsl:apply-templates select="../../marc:datafield[@tag=651]"/>
                <xsl:apply-templates select="../../marc:datafield[@tag=652]"/>
                <xsl:apply-templates select="../../marc:datafield[@tag=654]"/>
              </KEYWORDS>
            </TEXTCLASS>
          </PROFILEDESC>
        </xsl:element>
      </xsl:if>
      <xsl:text>
</xsl:text>
<!-- end for each 037 -->
<!--   </doc:document> -->
    </xsl:for-each>
  </xsl:template>
<!-- ############# -->
<!-- end header -->
<!-- ####################################### -->
  <xsl:template match="marc:datafield[@tag=037]/marc:subfield[@code='a']">
    <xsl:value-of select="translate(translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'-','')"/>
  </xsl:template>
<!-- ############# -->
  <xsl:template match="marc:datafield[@tag=037]/marc:subfield[@code='b']"/>
  <xsl:template match="marc:datafield[@tag=500]/marc:subfield">
    <NOTE>
      <P>
        <xsl:value-of select="."/>
      </P>
    </NOTE>
  </xsl:template>
<!-- ############# -->
  <xsl:template match="marc:datafield[@tag=610] | marc:datafield[@tag=600] | marc:datafield[@tag=611] | marc:datafield[@tag=630] | marc:datafield[@tag=648] | marc:datafield[@tag=650] | marc:datafield[@tag=651] | marc:datafield[@tag=652]  | marc:datafield[@tag=654]">
    <TERM>
      <xsl:for-each select="./marc:subfield">
        <xsl:value-of select="."/>
        <xsl:if test="not(position()=last())">
          <xsl:text> -- </xsl:text>
        </xsl:if>
      </xsl:for-each>
    </TERM>
  </xsl:template>
<!-- ############# -->
  <xsl:template match="marc:datafield[@tag=856]">
    <NOTE TYPE="url">
      <xsl:value-of select="marc:subfield[@code='u']"/>
    </NOTE>
    <NOTE>
      <P>
        <xsl:value-of select="marc:subfield[@code='z']"/>
      </P>
    </NOTE>
  </xsl:template>
<!-- ############# -->
  <xsl:template match="marc:datafield[@tag=260]">
    <PUBPLACE>
      <xsl:value-of select="marc:subfield[@code='a']"/>
    </PUBPLACE>
    <PUBLISHER>
      <xsl:value-of select="marc:subfield[@code='b']"/>
    </PUBLISHER>
    <DATE>
      <xsl:value-of select="marc:subfield[@code='c']"/>
    </DATE>
  </xsl:template>
<!-- ############# -->
  <xsl:template match="marc:datafield[@tag=310]">
    <xsl:for-each select="./marc:subfield">
      <xsl:value-of select="."/>
      <xsl:text>; </xsl:text>
    </xsl:for-each>
  </xsl:template>
<!-- ############# -->
  <xsl:template match="marc:datafield[@tag=362]">
    <xsl:for-each select="./marc:subfield">
      <xsl:value-of select="."/>
      <xsl:if test="not(position()=last())">
        <xsl:text>; </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
<!-- ############# -->
  <xsl:template match="marc:datafield[@tag=240]">
    <TITLE TYPE="alt">
      <xsl:for-each select="marc:subfield">
        <xsl:value-of select="."/>
        <xsl:if test="not(position()=last())">
          <xsl:text> </xsl:text>
        </xsl:if>
      </xsl:for-each>
    </TITLE>
  </xsl:template>
<!-- ############# -->
<!-- 
     245 Subfield Codes
     $a - Title (NR)
     $b - Remainder of title (NR)
     $c - Statement of responsibility, etc. (NR)
     $d - Designation of section (SE) [OBSOLETE]
     $e - Name of part/section (SE) [OBSOLETE]
     $f - Inclusive dates (NR)
     $g - Bulk dates (NR)
     $h - Medium (NR)
     $k - Form (R)
     $n - Number of part/section of a work (R)
     $p - Name of part/section of a work (R)
     $s - Version (NR)
     $6 - Linkage (NR)
     $8 - Field link and s
     -->
  <xsl:template match="marc:datafield[@tag=245]">
    <xsl:param name="sortchar"/>
    <xsl:param name="maintitle"/>
    <xsl:choose>
      <xsl:when test="$maintitle = 'yes'">
        <TITLE TYPE="245">
          <xsl:choose>
<!-- strip the occasional trailing colon -->
            <xsl:when test="contains(marc:subfield[@code='a'], ':')">
              <xsl:value-of select="substring-before(marc:subfield[@code='a'], ':')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="marc:subfield[@code='a']"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="marc:subfield[@code='b']">
            <xsl:text>: </xsl:text>
            <xsl:value-of select="marc:subfield[@code='b']"/>
          </xsl:if>
        </TITLE>
        <TITLE TYPE="sort">
          <xsl:variable name="titleStr">
            <xsl:choose>
<!-- strip the occasional trailing colon -->
              <xsl:when test="contains(marc:subfield[@code='a'], ':')">
                <xsl:value-of select="substring-before(marc:subfield[@code='a'], ':')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="marc:subfield[@code='a']"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
<!-- strip leading nonsorting characters -->
          <xsl:value-of select="substring($titleStr,$sortchar)"/>
          <xsl:if test="marc:subfield[@code='b']">
            <xsl:text>: </xsl:text>
            <xsl:value-of select="marc:subfield[@code='b']"/>
          </xsl:if>
        </TITLE>
      </xsl:when>
      <xsl:otherwise>
        <TITLE TYPE="245">
          <xsl:for-each select="marc:subfield">
            <xsl:if test="current()/@code!='h'">
              <xsl:value-of select="."/>
              <xsl:if test="not(position()=last())">
                <xsl:text> </xsl:text>
              </xsl:if>
            </xsl:if>
            <xsl:if test="current()/@code='h' and not(position()=last())">
              <xsl:text>: </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </TITLE>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
<!-- ############# -->
  <xsl:template match="marc:datafield[@tag=246]">
    <xsl:choose>
      <xsl:when test="starts-with(descendant::*,'Cited')">
        <TITLE TYPE="alt">
          <xsl:for-each select="marc:subfield">
            <xsl:value-of select="."/>
            <xsl:if test="not(position()=last())">
              <xsl:text> </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </TITLE>
      </xsl:when>
      <xsl:otherwise>
        <TITLE TYPE="alt">
          <xsl:for-each select="marc:subfield">
            <xsl:value-of select="."/>
            <xsl:if test="not(position()=last())">
              <xsl:text> </xsl:text>
            </xsl:if>
          </xsl:for-each>
        </TITLE>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
<!-- ############# -->
  <xsl:template match="marc:datafield[@tag=110]">
    <AUTHOR>
      <xsl:for-each select="marc:subfield">
        <xsl:value-of select="."/>
        <xsl:if test="not(position()=last())">
          <xsl:text> </xsl:text>
        </xsl:if>
      </xsl:for-each>
    </AUTHOR>
  </xsl:template>
<!-- ############# -->
  <xsl:template match="marc:datafield[@tag=100]">
    <AUTHOR>
      <xsl:for-each select="marc:subfield">
        <xsl:value-of select="."/>
        <xsl:if test="not(position()=last())">
          <xsl:text> </xsl:text>
        </xsl:if>
      </xsl:for-each>
    </AUTHOR>
  </xsl:template>
<!-- ############# -->
  <xsl:template match="marc:datafield[@tag=700]">
    <AUTHOR TYPE="alt">
      <xsl:for-each select="marc:subfield">
        <xsl:value-of select="."/>
        <xsl:if test="not(position()=last())">
          <xsl:text> </xsl:text>
        </xsl:if>
      </xsl:for-each>
    </AUTHOR>
  </xsl:template>
<!-- ############# -->
  <xsl:template match="marc:datafield[@tag=776]/marc:subfield[@code='z']">
    <NOTE TYPE="ISBN">
      <xsl:value-of select="."/>
    </NOTE>
  </xsl:template>
<!--############# Series in 440, 533 and 830-->
  <xsl:template match="marc:datafield[@tag=440]/marc:subfield[@code='a']">
   <xsl:variable name="normalized" select="normalize-space(translate(., ';,.',''))"/>
    <TITLE>
      <xsl:value-of select='translate($normalized, "ABCDEFGHIJKLMNOPQRSTUVWXYZ’[]()","abcdefghijklmnopqrstuvwxyz&apos;")' />
    </TITLE>
  </xsl:template>
  <xsl:template match="marc:datafield[@tag=533]/marc:subfield[@code='f']">
   <xsl:variable name="normalized" select="normalize-space(translate(., ';,.',''))"/>
    <TITLE>
      <xsl:value-of select='translate($normalized, "ABCDEFGHIJKLMNOPQRSTUVWXYZ’[]()","abcdefghijklmnopqrstuvwxyz&apos;")' />
    </TITLE>
  </xsl:template>
  <xsl:template match="marc:datafield[@tag=830]/marc:subfield[@code='a']">
    <xsl:variable name="normalized" select="normalize-space(translate(., ';,.',''))"/>
    <TITLE>
      <xsl:value-of select='translate($normalized, "ABCDEFGHIJKLMNOPQRSTUVWXYZ’[]()","abcdefghijklmnopqrstuvwxyz&apos;")' />
    </TITLE>
  </xsl:template>
<!-- ####################################### -->
<!-- ####################################### -->
<!-- disposable elements:  -->
  <xsl:template match="marc:datafield[@tag=001]"/>
  <xsl:template match="marc:datafield[@tag=003]"/>
  <xsl:template match="marc:datafield[@tag=005]"/>
  <xsl:template match="marc:datafield[@tag=006]"/>
  <xsl:template match="marc:datafield[@tag=007]"/>
  <xsl:template match="marc:datafield[@tag=008]"/>
  <xsl:template match="marc:datafield[@tag=009]"/>
  <xsl:template match="marc:datafield[@tag=010]"/>
  <xsl:template match="marc:datafield[@tag=011]"/>
  <xsl:template match="marc:datafield[@tag=013]"/>
  <xsl:template match="marc:datafield[@tag=015]"/>
  <xsl:template match="marc:datafield[@tag=016]"/>
  <xsl:template match="marc:datafield[@tag=017]"/>
  <xsl:template match="marc:datafield[@tag=018]"/>
  <xsl:template match="marc:datafield[@tag=020]"/>
  <xsl:template match="marc:datafield[@tag=022]"/>
  <xsl:template match="marc:datafield[@tag=024]"/>
  <xsl:template match="marc:datafield[@tag=025]"/>
  <xsl:template match="marc:datafield[@tag=026]"/>
  <xsl:template match="marc:datafield[@tag=027]"/>
  <xsl:template match="marc:datafield[@tag=028]"/>
  <xsl:template match="marc:datafield[@tag=030]"/>
  <xsl:template match="marc:datafield[@tag=032]"/>
  <xsl:template match="marc:datafield[@tag=033]"/>
  <xsl:template match="marc:datafield[@tag=034]"/>
  <xsl:template match="marc:datafield[@tag=035]"/>
  <xsl:template match="marc:datafield[@tag=036]"/>
  <xsl:template match="marc:datafield[@tag=038]"/>
  <xsl:template match="marc:datafield[@tag=040]"/>
  <xsl:template match="marc:datafield[@tag=041]"/>
  <xsl:template match="marc:datafield[@tag=042]"/>
  <xsl:template match="marc:datafield[@tag=043]"/>
  <xsl:template match="marc:datafield[@tag=044]"/>
  <xsl:template match="marc:datafield[@tag=045]"/>
  <xsl:template match="marc:datafield[@tag=046]"/>
  <xsl:template match="marc:datafield[@tag=047]"/>
  <xsl:template match="marc:datafield[@tag=048]"/>
  <xsl:template match="marc:datafield[@tag=050]"/>
  <xsl:template match="marc:datafield[@tag=051]"/>
  <xsl:template match="marc:datafield[@tag=052]"/>
  <xsl:template match="marc:datafield[@tag=055]"/>
  <xsl:template match="marc:datafield[@tag=060]"/>
  <xsl:template match="marc:datafield[@tag=061]"/>
  <xsl:template match="marc:datafield[@tag=066]"/>
  <xsl:template match="marc:datafield[@tag=070]"/>
  <xsl:template match="marc:datafield[@tag=071]"/>
  <xsl:template match="marc:datafield[@tag=072]"/>
  <xsl:template match="marc:datafield[@tag=074]"/>
  <xsl:template match="marc:datafield[@tag=080]"/>
  <xsl:template match="marc:datafield[@tag=082]"/>
  <xsl:template match="marc:datafield[@tag=084]"/>
  <xsl:template match="marc:datafield[@tag=086]"/>
  <xsl:template match="marc:datafield[@tag=088]"/>
  <xsl:template match="marc:datafield[@tag=090]"/>
  <xsl:template match="marc:datafield[@tag=091]"/>
  <xsl:template match="marc:datafield[@tag=111]"/>
  <xsl:template match="marc:datafield[@tag=130]"/>
  <xsl:template match="marc:datafield[@tag=210]"/>
  <xsl:template match="marc:datafield[@tag=211]"/>
  <xsl:template match="marc:datafield[@tag=212]"/>
  <xsl:template match="marc:datafield[@tag=214]"/>
  <xsl:template match="marc:datafield[@tag=222]"/>
  <xsl:template match="marc:datafield[@tag=241]"/>
  <xsl:template match="marc:datafield[@tag=242]"/>
  <xsl:template match="marc:datafield[@tag=243]"/>
  <xsl:template match="marc:datafield[@tag=247]"/>
  <xsl:template match="marc:datafield[@tag=250]"/>
  <xsl:template match="marc:datafield[@tag=254]"/>
  <xsl:template match="marc:datafield[@tag=255]"/>
  <xsl:template match="marc:datafield[@tag=256]"/>
  <xsl:template match="marc:datafield[@tag=257]"/>
  <xsl:template match="marc:datafield[@tag=261]"/>
  <xsl:template match="marc:datafield[@tag=262]"/>
  <xsl:template match="marc:datafield[@tag=263]"/>
  <xsl:template match="marc:datafield[@tag=265]"/>
  <xsl:template match="marc:datafield[@tag=270]"/>
  <xsl:template match="marc:datafield[@tag=300]"/>
  <xsl:template match="marc:datafield[@tag=301]"/>
  <xsl:template match="marc:datafield[@tag=302]"/>
  <xsl:template match="marc:datafield[@tag=303]"/>
  <xsl:template match="marc:datafield[@tag=304]"/>
  <xsl:template match="marc:datafield[@tag=305]"/>
  <xsl:template match="marc:datafield[@tag=306]"/>
  <xsl:template match="marc:datafield[@tag=307]"/>
  <xsl:template match="marc:datafield[@tag=308]"/>
  <xsl:template match="marc:datafield[@tag=315]"/>
  <xsl:template match="marc:datafield[@tag=321]"/>
  <xsl:template match="marc:datafield[@tag=340]"/>
  <xsl:template match="marc:datafield[@tag=342]"/>
  <xsl:template match="marc:datafield[@tag=343]"/>
  <xsl:template match="marc:datafield[@tag=350]"/>
  <xsl:template match="marc:datafield[@tag=351]"/>
  <xsl:template match="marc:datafield[@tag=352]"/>
  <xsl:template match="marc:datafield[@tag=355]"/>
  <xsl:template match="marc:datafield[@tag=357]"/>
  <xsl:template match="marc:datafield[@tag=359]"/>
  <xsl:template match="marc:datafield[@tag=365]"/>
  <xsl:template match="marc:datafield[@tag=366]"/>
  <xsl:template match="marc:datafield[@tag=400]"/>
  <xsl:template match="marc:datafield[@tag=410]"/>
  <xsl:template match="marc:datafield[@tag=411]"/>
  <xsl:template match="marc:datafield[@tag=490]"/>
  <xsl:template match="marc:datafield[@tag=501]"/>
  <xsl:template match="marc:datafield[@tag=502]"/>
  <xsl:template match="marc:datafield[@tag=503]"/>
  <xsl:template match="marc:datafield[@tag=504]"/>
  <xsl:template match="marc:datafield[@tag=505]"/>
  <xsl:template match="marc:datafield[@tag=506]"/>
  <xsl:template match="marc:datafield[@tag=507]"/>
  <xsl:template match="marc:datafield[@tag=508]"/>
  <xsl:template match="marc:datafield[@tag=510]"/>
  <xsl:template match="marc:datafield[@tag=511]"/>
  <xsl:template match="marc:datafield[@tag=512]"/>
  <xsl:template match="marc:datafield[@tag=513]"/>
  <xsl:template match="marc:datafield[@tag=514]"/>
  <xsl:template match="marc:datafield[@tag=515]"/>
  <xsl:template match="marc:datafield[@tag=516]"/>
  <xsl:template match="marc:datafield[@tag=517]"/>
  <xsl:template match="marc:datafield[@tag=518]"/>
  <xsl:template match="marc:datafield[@tag=520]"/>
  <xsl:template match="marc:datafield[@tag=521]"/>
  <xsl:template match="marc:datafield[@tag=522]"/>
  <xsl:template match="marc:datafield[@tag=523]"/>
  <xsl:template match="marc:datafield[@tag=524]"/>
  <xsl:template match="marc:datafield[@tag=525]"/>
  <xsl:template match="marc:datafield[@tag=526]"/>
  <xsl:template match="marc:datafield[@tag=527]"/>
  <xsl:template match="marc:datafield[@tag=530]"/>
  <xsl:template match="marc:datafield[@tag=534]"/>
  <xsl:template match="marc:datafield[@tag=535]"/>
  <xsl:template match="marc:datafield[@tag=536]"/>
  <xsl:template match="marc:datafield[@tag=537]"/>
  <xsl:template match="marc:datafield[@tag=538]"/>
  <xsl:template match="marc:datafield[@tag=540]"/>
  <xsl:template match="marc:datafield[@tag=541]"/>
  <xsl:template match="marc:datafield[@tag=543]"/>
  <xsl:template match="marc:datafield[@tag=544]"/>
  <xsl:template match="marc:datafield[@tag=545]"/>
  <xsl:template match="marc:datafield[@tag=546]"/>
  <xsl:template match="marc:datafield[@tag=547]"/>
  <xsl:template match="marc:datafield[@tag=550]"/>
  <xsl:template match="marc:datafield[@tag=552]"/>
  <xsl:template match="marc:datafield[@tag=555]"/>
  <xsl:template match="marc:datafield[@tag=556]"/>
  <xsl:template match="marc:datafield[@tag=561]"/>
  <xsl:template match="marc:datafield[@tag=562]"/>
  <xsl:template match="marc:datafield[@tag=563]"/>
  <xsl:template match="marc:datafield[@tag=565]"/>
  <xsl:template match="marc:datafield[@tag=567]"/>
  <xsl:template match="marc:datafield[@tag=570]"/>
  <xsl:template match="marc:datafield[@tag=580]"/>
  <xsl:template match="marc:datafield[@tag=581]"/>
  <xsl:template match="marc:datafield[@tag=582]"/>
  <xsl:template match="marc:datafield[@tag=583]"/>
  <xsl:template match="marc:datafield[@tag=584]"/>
  <xsl:template match="marc:datafield[@tag=585]"/>
  <xsl:template match="marc:datafield[@tag=586]"/>
  <xsl:template match="marc:datafield[@tag=590]"/>
  <xsl:template match="marc:datafield[@tag=653]"/>
  <xsl:template match="marc:datafield[@tag=655]"/>
  <xsl:template match="marc:datafield[@tag=656]"/>
  <xsl:template match="marc:datafield[@tag=657]"/>
  <xsl:template match="marc:datafield[@tag=658]"/>
  <xsl:template match="marc:datafield[@tag=705]"/>
  <xsl:template match="marc:datafield[@tag=710]"/>
  <xsl:template match="marc:datafield[@tag=711]"/>
  <xsl:template match="marc:datafield[@tag=715]"/>
  <xsl:template match="marc:datafield[@tag=720]"/>
  <xsl:template match="marc:datafield[@tag=730]"/>
  <xsl:template match="marc:datafield[@tag=740]"/>
  <xsl:template match="marc:datafield[@tag=752]"/>
  <xsl:template match="marc:datafield[@tag=753]"/>
  <xsl:template match="marc:datafield[@tag=754]"/>
  <xsl:template match="marc:datafield[@tag=755]"/>
  <xsl:template match="marc:datafield[@tag=760]"/>
  <xsl:template match="marc:datafield[@tag=762]"/>
  <xsl:template match="marc:datafield[@tag=765]"/>
  <xsl:template match="marc:datafield[@tag=767]"/>
  <xsl:template match="marc:datafield[@tag=770]"/>
  <xsl:template match="marc:datafield[@tag=772]"/>
  <xsl:template match="marc:datafield[@tag=773]"/>
  <xsl:template match="marc:datafield[@tag=774]"/>
  <xsl:template match="marc:datafield[@tag=775]"/>
  <xsl:template match="marc:datafield[@tag=776]"/>
  <xsl:template match="marc:datafield[@tag=777]"/>
  <xsl:template match="marc:datafield[@tag=780]"/>
  <xsl:template match="marc:datafield[@tag=785]"/>
  <xsl:template match="marc:datafield[@tag=786]"/>
  <xsl:template match="marc:datafield[@tag=787]"/>
  <xsl:template match="marc:datafield[@tag=800]"/>
  <xsl:template match="marc:datafield[@tag=810]"/>
  <xsl:template match="marc:datafield[@tag=811]"/>
  <xsl:template match="marc:datafield[@tag=840]"/>
  <xsl:template match="marc:datafield[@tag=841]"/>
  <xsl:template match="marc:datafield[@tag=842]"/>
  <xsl:template match="marc:datafield[@tag=843]"/>
  <xsl:template match="marc:datafield[@tag=844]"/>
  <xsl:template match="marc:datafield[@tag=845]"/>
  <xsl:template match="marc:datafield[@tag=850]"/>
  <xsl:template match="marc:datafield[@tag=851]"/>
  <xsl:template match="marc:datafield[@tag=852]"/>
  <xsl:template match="marc:datafield[@tag=853]"/>
  <xsl:template match="marc:datafield[@tag=854]"/>
  <xsl:template match="marc:datafield[@tag=855]"/>
  <xsl:template match="marc:datafield[@tag=863]"/>
  <xsl:template match="marc:datafield[@tag=864]"/>
  <xsl:template match="marc:datafield[@tag=865]"/>
  <xsl:template match="marc:datafield[@tag=866]"/>
  <xsl:template match="marc:datafield[@tag=867]"/>
  <xsl:template match="marc:datafield[@tag=868]"/>
  <xsl:template match="marc:datafield[@tag=870]"/>
  <xsl:template match="marc:datafield[@tag=871]"/>
  <xsl:template match="marc:datafield[@tag=872]"/>
  <xsl:template match="marc:datafield[@tag=873]"/>
  <xsl:template match="marc:datafield[@tag=876]"/>
  <xsl:template match="marc:datafield[@tag=877]"/>
  <xsl:template match="marc:datafield[@tag=878]"/>
  <xsl:template match="marc:datafield[@tag=880]"/>
  <xsl:template match="marc:datafield[@tag=886]"/>
  <xsl:template match="marc:datafield[@tag=887]"/>
<!-- ############# -->
</xsl:transform>
