<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:output method="html" encoding="UTF-8" />

    <xsl:template match="guiao">
        <html>
            <head>
                <title>Trabalho 2 - PDE</title>  
                <link rel="stylesheet" type="text/css" href="style.css"/>              
            </head>
            <body>
    			<xsl:variable name="autor" select="count(/guiao/cabecalho/autor)"/>
				<xsl:variable name="data" select="count(/guiao/cabecalho/dataPublicacao)"/>
				<xsl:variable name="pers" select="count(/guiao/cabecalho/personagens)"/>
				<xsl:variable name="cabTitulo" select="count(/guiao/cabecalho/titulo)"/>
                <xsl:variable name="tempor" select="count(/guiao/cenas/temporada)" />
				<xsl:variable name="epis" select="count(/guiao/cenas/episodio)" />
				<xsl:variable name="partes" select="count(/guiao/cenas/partes)" />
				<xsl:variable name="cena" select="count(/guiao/cenas/cena)" />

				<xsl:choose>
                    <xsl:when test="$autor &lt; 0 and $data &lt; 0 and $pers &lt; 0 and $cabTitulo &lt; 0">
                        <xsl:message terminate="no">
                            Erro: Cabeçalho do guião mal construído!
                        </xsl:message>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:apply-templates select="cabecalho"/>
                        
                        <xsl:choose>
                            <xsl:when test="$tempor &lt; 0 and $epis &lt; 0 and $partes &lt; 0 and $cena &lt; 0">
                                <xsl:message terminate="no">
                                    Erro: Corpo do guião mal construído!
                                </xsl:message>
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:apply-templates select="cenas"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="cabecalho">
        <div id="cabecalho">
            <h2>
                <xsl:value-of select="titulo"/>
            </h2>

            <div id="data">
                <p>
                    <b>Data: </b>
                    <p><xsl:value-of select="dataPublicacao/dia"/>/
                    <xsl:value-of select="dataPublicacao/mes"/>/
                    <xsl:value-of select="dataPublicacao/ano"/>
                    </p>
                </p>
            </div>
            
            <div id="autores">
                <p>
                    <b> Autor(es): </b>
                </p>
                <xsl:apply-templates select="autor"/>
            </div>

            <xsl:if test="personagens">
                <p>Personagens: </p>
                <xsl:apply-templates select="personagens"/>
            </xsl:if>

        </div>
    </xsl:template>
    
    <xsl:template match="autor">
        <xsl:for-each select=".">
            <ul>
                <li>
                    <xsl:value-of select="." />
                </li>
            </ul>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="sinopse">
        <div id="sinopse">
            <p>
                <xsl:value-of select="." />
            </p>
        </div>
    </xsl:template>

    <xsl:template match="personagens">
        <div id="personagens">
            <table style="width:100%">
                <tr>
                    <th>Nome</th>
                    <th>Descriçao</th>
                </tr>
                
                <xsl:for-each select="personagem">
                    <tr>
                        <td>
                            <xsl:value-of select="./nome" />
                        </td>
                        <td>
                            <xsl:value-of select="./descricao" />
                        </td>
                    </tr>
                </xsl:for-each>
            </table>
        </div>
    </xsl:template>
    
    <xsl:template match="cenas">
        <div id="navegacao">
            <xsl:if test="temporada">
                <xsl:apply-templates select="temporada" mode="indice" />
            </xsl:if>
            
            <xsl:if test="episodio">
                <xsl:apply-templates select="episodio" mode="indice" />
            </xsl:if>
            
            <xsl:if test="partes">
                <xsl:apply-templates select="partes" mode="indice" />
            </xsl:if>
            
            <xsl:if test="cena">
                <xsl:apply-templates select="cena" mode="indice" />
            </xsl:if>
        </div>
        
        <div id="conteudo">
            <xsl:if test="temporada">
                <xsl:apply-templates select="temporada" mode="conteudo" />
            </xsl:if>
            <br></br>
            <xsl:if test="episodio">
                <xsl:apply-templates select="episodio" mode="conteudo" />
            </xsl:if>
            <br></br>
            <xsl:if test="partes">
                <xsl:apply-templates select="partes" mode="conteudo" />
            </xsl:if>
            <br></br>
            <xsl:if test="cena">
                <xsl:apply-templates select="partes" mode="conteudo" />
            </xsl:if>
            
        </div>        
    </xsl:template>
    
    <xsl:template match="temporada" mode="indice">
        <LI>
            <A HREF="#{generate-id()}">
                <xsl:number format="1" />
                . Temporada
                -
                <xsl:value-of select="titulo" />
            </A>
            <ul>
                <xsl:apply-templates select="episodio" mode="indice" />
            </ul>
        </LI>
    </xsl:template>
    
    <xsl:template match="episodio" mode="indice">
        <LI>
            <A href="#{generate-id()}">
                <xsl:number format="1." />
                .Episódio -
                <xsl:value-of select="titulo" />
            </A>
            <ul>
                <xsl:apply-templates select="cena" mode="indice" />
            </ul>
        </LI>
    </xsl:template>

    <xsl:template match="partes" mode="indice">
        <LI>
            <A href="#{generate-id()}">
                <xsl:number format="1." />
                Parte -
                <xsl:value-of select="titulo" />
            </A>
            <ul>
                <xsl:apply-templates select="cena" mode="indice" />
            </ul>
        </LI>
    </xsl:template>
    
    <xsl:template match="cena" mode="indice">
        <LI>
            <A href="#{generate-id()}">
                <xsl:number format="1." />
                Cena -
                <xsl:value-of select="@contexto" />
            </A>
        </LI>
    </xsl:template>
    
    <xsl:template match="temporada" mode="conteudo">
        <xsl:for-each select=".">
            <div id="temporada">
                <h2>
                    <a name="{generate-id()}">
                        <xsl:value-of select="titulo" />
                    </a>
                </h2>
            
                <xsl:if test="personagens">
                    <p>Personagens: </p>
                    <xsl:apply-templates select="personagens" />
                </xsl:if>
                <xsl:if test="sinopse">
                    <xsl:apply-templates select="sinopse" />
                </xsl:if>
                <xsl:apply-templates select="episodio" mode="conteudo" />
            </div>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="episodio" mode="conteudo">
        <xsl:for-each select=".">
            <div id="episodio">
                <h2>
                    <a name="{generate-id()}">
                        <xsl:value-of select="titulo" />
                    </a>
                </h2>

                <xsl:if test="personagens">
                    <p>Personagens: </p>
                    <xsl:apply-templates select="personagens" />
                </xsl:if>

                <xsl:if test="sinopse">
                    <xsl:apply-templates select="sinopse" />
                </xsl:if>

                <xsl:apply-templates select="cena" mode="conteudo" />
            </div>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="partes" mode="conteudo">
        <xsl:for-each select=".">
            <div id="partes">
                <h2>
                    <a name="{generate-id()}">
                        <xsl:value-of select="titulo" />
                    </a>
                </h2>
                
                <xsl:if test="personagens">
                    <p>Personagens: </p>
                    <xsl:apply-templates select="personagens" />
                </xsl:if>

                <xsl:if test="sinopse">
                    <xsl:apply-templates select="sinopse" />
                </xsl:if>
                <xsl:apply-templates select="cena" mode="conteudo" />
            </div>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="cena" mode="conteudo">
        <xsl:for-each select=".">
            <div id="cena">
                <h2>
                    <a name="{generate-id()}">
                        <xsl:value-of select="@contexto" />
                    </a>
                </h2>
                <p>Lista de conteúdos da cena</p>

                <div id="listaPersonagens">
                    <xsl:for-each select="fala">
                        <ul>
                            <li>
                                <xsl:value-of select="@p" />
                            </li>
                        </ul>
                    </xsl:for-each>
                </div>

                <div id="listaAderecos">
                    <xsl:for-each select="adereco">
                        <ul>
                            <li>
                                <xsl:value-of select="." />
                            </li>
                        </ul>
                    </xsl:for-each>
                </div>

                <xsl:apply-templates select="fala" />
                <xsl:apply-templates select="refere" />
                <xsl:apply-templates select="adereco" />
                <p>
                    <b>Comentários: </b>
                </p>
                <xsl:apply-templates select="comentario"/>
            </div>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="fala">
        <p id="person">
            <xsl:value-of select="@p" />
            :
        </p>
        <p>
            <xsl:value-of select="text()" />
            <xsl:if test="comentario">
                <xsl:apply-templates select="comentario" />
            </xsl:if>
        </p>
    </xsl:template>
    
    <xsl:template match="comentario">
        <i>
            <p>(<xsl:value-of select="."/>) </p>
        </i>
    </xsl:template>
    
    <xsl:template match="refere">
        <p class="upperCase">
            Referencia:
            <xsl:value-of select="@p" />
        </p>
    </xsl:template>
    
    <xsl:template match="adereco">
        <p>
            <b>Adereço: </b>
            <xsl:value-of select="." />
        </p>
    </xsl:template>
</xsl:stylesheet>