<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
version="2.0">

	<xsl:template match="/">
		<!--<xsl:for-each select="distinct-values(//author | //editor)">-->
			 <xsl:apply-templates select="//author | //editor"/> <!-- On saut au template definit ci-dessous -->
		<!--</xsl:for-each>-->
	</xsl:template>  

<xsl:template match="//author | //editor">
	
	<xsl:variable name="all_name" select="."/>
	<xsl:variable name="last_name" select="tokenize($all_name, ' ')[last()]"/>
	<xsl:variable name="first_name" select="replace($all_name, concat(' ',$last_name), '')"/>
	<!-- on replace les caracteres speciaux pas = et les espaces par _ -->
	<xsl:variable name="last_name" select="replace($last_name, '[^a-zA-Z0-9]', '=')" />
	<xsl:variable name="first_name" select="replace($first_name, ' ', '_')" />
	<xsl:variable name="first_name" select="replace($first_name, '[^a-zA-Z0-9-_]', '=')" />
	
	<!-- premiere lettre : substring($last_name,1,1) -->
	<xsl:result-document href="a-tree/{substring($last_name,1,1)}/{$last_name}.{$first_name}.html">
		<html>
		  <head> <title>Publication of <xsl:value-of select="$last_name"/> <xsl:value-of select="$first_name"/></title> </head>
		  <body>
				<h1><xsl:value-of select="$last_name"/> <xsl:value-of select="$first_name"/></h1>
		  </body>
		</html>

	</xsl:result-document>
</xsl:template>
	
</xsl:stylesheet>
