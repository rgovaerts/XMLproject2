<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
version="2.0">

	<xsl:template match="/">
		<xsl:for-each-group select="//author | //editor" group-by="text()"> <!-- group-by the author/editor by their name -->
			<xsl:apply-templates select="."/> <!-- On saut au template definit ci-dessous -->
		</xsl:for-each-group>
	</xsl:template>  

<xsl:template match="//author | //editor">
	<!-- les current text du noeud est retourné avec . -->
	<xsl:variable name="all_name" select="."/>
	<xsl:variable name="last_name" select="tokenize(., ' ')[last()]"/>
	<xsl:variable name="first_name" select="replace(., concat(' ',$last_name), '')"/>
	
	<!-- pour les url on replace les caracteres speciaux pas = et les espaces par _ -->
	<xsl:variable name="last_name_url" select="replace($last_name, '[^a-zA-Z0-9]', '=')" />
	<xsl:variable name="first_name_url" select="replace($first_name, ' ', '_')" />
	<xsl:variable name="first_name_url" select="replace($first_name_url, '[^a-zA-Z0-9-_]', '=')" />
	<!-- premiere lettre : substring($last_name,1,1) -->
	<xsl:result-document href="a-tree/{substring($last_name,1,1)}/{$last_name_url}.{$first_name_url}.html">
		<html>
		  <head> <title>Publication of <xsl:value-of select="$last_name"/> <xsl:value-of select="$first_name"/></title> </head>
		  <body>
				<h1><xsl:value-of select="$last_name"/>&#160;<xsl:value-of select="$first_name"/></h1> <!-- &#160; = espace -->
			  	<table border="1"> 
				<!-- Generate, for each year in which this person has
				publications, a "year row" that groups the publications of
				that year -->
					<!-- get all the same name element (author ou editor) in the database, It go through all the works of the current name's guy 
					<xsl:for-each select="/dblp//author[text()=$all_name]"> -->
					<xsl:for-each select="current-group()">
						<xsl:sort select="../year" order="descending"/> <!-- On trie les travaux par date descendante -->
						<xsl:variable name="title" select="../title"/>
						<xsl:variable name="year" select="../year"/>
						<tr><th colspan="3" bgcolor="#FFFFCC"><xsl:value-of select="$year"/></th></tr>
						<tr>
							<!-- The publication number (the earliest publication is
							publication number 1, the last publication has the highest
							number) -->
							<td align="right" valign="top"><a name="p5"/><xsl:value-of select="position()"/></td>
							<!-- A link to an online version of the publication whose
							  URL is listed in the < ee > element,  if that element is present -->
							<td valign="top">
								<a href="">
								  <img alt="Electronic Edition" title="Electronic Edition"
							  src="http://www.informatik.uni-trier.de/~ley/db/ee.gif"
							  border="0" height="16" width="16"/>
								</a>
							</td>

							<!-- The bibliographic reference itself 
							Note that for each person mentioned in the reference,
							if that person is present in the DBLP file, then a link
							to that person's HTML file should be created.
							Browse the on-line version of DBLP, e.g.,
							http://www.informatik.uni-trier.de/~ley/db/indices/a-tree/m/Maier:David.html
							to see how other publication types should be formatted.
							-->
							<td>
								<!-- on parcourt chaque co-author et associe un lien vers sa paga html -->
								<xsl:for-each select="../author">
									<xsl:variable name="last_name_i" select="tokenize(., ' ')[last()]"/>
									<xsl:variable name="first_name_i" select="replace(., concat(' ',$last_name_i), '')"/>
									<xsl:variable name="last_name_url_i" select="replace($last_name_i, '[^a-zA-Z0-9]', '=')" />
									<xsl:variable name="first_name_url_i" select="replace($first_name_i, ' ', '_')" />
									<xsl:variable name="first_name_url_i" select="replace($first_name_url_i, '[^a-zA-Z0-9-_]', '=')" />
									<a href="../{substring($last_name_i,1,1)}/{$last_name_url_i}.{$first_name_url_i}.html"><xsl:value-of select="."/></a>, 
								</xsl:for-each>
								: <xsl:value-of select="$title"/>&#160;<xsl:value-of select="$year"/>.
							</td>
						</tr>
					</xsl:for-each>
				</table>
		  </body>
		</html>

	</xsl:result-document>
</xsl:template>
	
</xsl:stylesheet>
