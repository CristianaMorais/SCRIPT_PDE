<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE rdf:RDF [
 <!ENTITY rdf  "http://www.w3.org/1999/02/22-rdf-syntax-ns#">
 <!ENTITY rdfs "http://www.w3.org/2000/01/rdf-schema#">
]>

<xsl:stylesheet	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:foaf="http://xmlns.com/foaf/0.1/"
	xmlns:g="http://www.dcc.fc.up.pt/~zp/guiao/"
	version="1.0">

	<xsl:output method="xml" indent="yes"/>
	
	<xsl:template match="guiao">
		<rdf:RDF>
			<rdf:Description rdf:about="http://www.example.com/xml">
				<xsl:apply-templates/>
			</rdf:Description>
		</rdf:RDF>
	</xsl:template>


	<xsl:template match="cabecalho">
		<dc:title>
			<xsl:value-of select="titulo"/>
		</dc:title>
		<dc:date>
			<xsl:value-of select="dataPublicacao/dia"/>-<xsl:value-of select="dataPublicacao/mes"/>-<xsl:value-of select="dataPublicacao/ano"/>
		</dc:date>

		<xsl:apply-templates select="autor"/>
		<g:characters>
			<xsl:if test="personagens">
				<xsl:apply-templates select="personagens"/>
			</xsl:if>
		</g:characters>

		<xsl:if test="sinopse">
			<xsl:apply-templates select="sinopse"/>
		</xsl:if>

	</xsl:template>

	<xsl:template match="autor">
		<xsl:for-each select=".">
			<dc:creator>
				<xsl:value-of select="."/>
			</dc:creator>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="personagens">
		<rdf:Bag>
			<xsl:for-each select="personagem">
				<foaf:name>
					<xsl:value-of select="./nome"/>
				</foaf:name>
				<dc:description>
					<xsl:value-of select="./descricao"/>
				</dc:description>
			</xsl:for-each>
		</rdf:Bag>
	</xsl:template>

	<xsl:template match="sinopse">
		<dc:description>
			<xsl:value-of select="."/>
		</dc:description>
	</xsl:template>

	<xsl:template match="cenas">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="temporada">
		<g:Temporada>
			<rdfs:Class rdf:about="temporada({@id})">
				<rdfs:subClassOf rdf:resource="guiao"/>
				<dc:title>
					<xsl:value-of select="titulo"/>
				</dc:title>
				<xsl:apply-templates select="episodio"/>
				<xsl:apply-templates select="partes"/>
				<xsl:apply-templates select="cena"/>
			</rdfs:Class>
		</g:Temporada>
	</xsl:template>

	<xsl:template match="episodio">
		<g:episodio>
			<rdfs:Class rdf:about="episodio({@id})">
				<rdfs:subClassOf rdf:resource="temporada"/>
				<dc:title>
					<xsl:value-of select="titulo" />
				</dc:title>
				<xsl:apply-templates select="cena"/>
			</rdfs:Class>
		</g:episodio>
	</xsl:template>

	<xsl:template match="partes">
		<g:partes>
			<rdfs:Class rdf:about="partes({@id})">
				<rdfs:subClassOf rdf:resource="guiao"/>
				<dc:title>
					<xsl:value-of select="titulo"/>
				</dc:title>
				<xsl:apply-templates select="cena"/>
			</rdfs:Class>
		</g:partes>
	</xsl:template>

	<xsl:template match="cena">
		<foaf:name>
			<xsl:value-of select="@contexto"/>
		</foaf:name>
	</xsl:template>
</xsl:stylesheet>