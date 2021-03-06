#IFDEF TOTVS
	#INCLUDE 'TOTVS.CH'
#ELSE
	#INCLUDE 'PROTHEUS.CH'
#ENDIF


/*北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐�
北篜rograma  � EnvMovimento 篈utor  矱dilson Mendes � Data �  14/09/19    罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋esc.     � Classe para a geracao do LOG dos registros processados     罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篜ropried. � cEnvDest  - Endereco dos destinatarios para envio do email.罕�
北�          � cEnvCopia - Endereco dos destinatarios em copia do email.  罕�
北�          � cAssunto  - Descricao da informacao do email enviado.      罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篗etodos   � ::New            - Cria o objeto.                          罕�
北�          � ::AddErro        - Adiciona a informacao de Erro.          罕�
北�          � ::Send           - Realiza a montagem do Html e efetua o   罕�
北�          �                  - envio por email.                        罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � P12                                                        罕�
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�*/
CLASS EnvMovimento

	// Declaracao das propriedades da Classe
	DATA cNumOp
	DATA cEnvDest
	DATA cEnvCopia
	DATA cAssunto
	DATA aHeader
	DATA aConteudo
	DATA aDados
	
	// Declara玢o dos M閠odos da Classe
	METHOD New() CONSTRUCTOR
	METHOD AddHeader( cHeader ) 
	METHOD AddConteudo( cTag, xConteudo )
	METHOD ConteudoCommmit()
	METHOD Send()
	
ENDCLASS

METHOD New() CLASS EnvMovimento
	::cNumOp    := ""
	::cEnvDest  := ""
	::cEnvCopia := ""
	::cAssunto  := ""
	::aHeader   := {}
	::aDados 	:= {}
Return Self

METHOD AddHeader( cHeader ) CLASS EnvMovimento
	if ValType( cHeader ) == "C"
		Aadd( ::aHeader, { UPPER(ALLTRIM(cHeader)), } )
	endif
Return ::aHeader

METHOD AddConteudo( cTag, xConteudo ) CLASS EnvMovimento

local nPointer

DEFAULT cTag      := ""
DEFAULT xConteudo := ""

	if .not. empty(cTag)
		
		if ( nPointer := ASCAN( ::aHeader, { |xItem| xItem[1] == UPPER( ALLTRIM( cTag ) ) } ) ) > 0
			::aHeader[ nPointer ][2] := alltrim(xConteudo) 
		endif
		
	endif

Return Self

METHOD ConteudoCommmit() CLASS EnvMovimento

local nPos

	if len( ::aHeader ) > 0

		AADD( ::aDados, Array( len( ::aHeader ) ) )	

		for nPos := 1 TO len( ::aHeader )
			ATail(::aDados)[ nPos ] := ::aHeader[ nPos ][2]
		next

		// Limpa o conteudo do vetor[2] aHeader
		for nPos := 1 TO len( ::aHeader )
			::aHeader[ nPos][2] := Nil
		next
				
	endif

Return Self

METHOD Send() CLASS EnvMovimento

Local cHtml
Local nPos
Local nCount
Local aTemp := {}

	if len( ::aHeader ) > 0 .and. len( ::aDados ) > 0
		
		BEGIN SEQUENCE
		
			cHtml := '<html>'
			cHtml += '	<head>'
			cHtml += '		<meta name="Komfort House" content="Apontamento">'
			cHtml += '		<style>'
			cHtml += '			Body {FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10pt}'
			cHtml += '			Div {FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10pt}'
			cHtml += '			Table {FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10pt}'
			cHtml += '			Td {FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10pt}'
			cHtml += '			.TableRowBlueTitleMedium {BACKGROUND-COLOR: #e4e4e4; COLOR: #FFCC00; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 28px; VERTICAL-ALIGN: top ; FONT-WEIGHT: bold}'
			cHtml += '			.TableRowBlueDarkMini {BACKGROUND-COLOR: #e4e4e4; COLOR: #FFCC00; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10px; VERTICAL-ALIGN: top}'
			cHtml += '			.style1 {color: #19167D}'
			cHtml += '			.style2 {color: #000000}'
			cHtml += '		</Style>'
			cHtml += '	</head>'
			cHtml += '	<body>'
			cHtml += '		<table width=650 height="48">'
			cHtml += '		  <tr><th bgcolor="#87CEEB" colspan=' + alltrim(str(len( ::aHeader ))) + ' class="TableRowBlueTitleMedium" ><p align="center" class="style1">' + ::cAssunto + '</p></th></td>'
			cHtml += '		  <tr bgcolor="#87CEEB">'
            for nPos := 1 to len( ::aHeader )
				cHtml += '		  	<td width="10%%" class="TableRowBlueDarkMini" align="center" height="14" ><span class="style1"><b>' + ::aHeader[ nPos ][1] + '</b></span></td>'
            next
			cHtml += '		  </tr>'
			For nPos := 1 to len( ::aDados )
				cHtml += '	  <tr bgcolor=' + iif( empty(::aDados[ nPos ][1]), "#87CEEB", "#EB050C"  ) + '>'
				for nCount := 1 to len( ::aDados[ nPos ] )
						cHtml += '	  	<td> ' + ::aDados[ nPos ][ nCount ] + '</td>'
				next
				cHtml += '	  </tr>'
			Next
			cHtml += '		  </tr>'
			cHtml += '		</table>'
			cHtml += '	</body>'
			cHtml += '</html>'
			
			Aadd( aTemp, cHtml )
			
			U_MailNotify( ::cEnvDest, ::cEnvCopia , ::cAssunto, aTemp, {}, .T.)

			::aHeader := {}
			::aDados  := {}
		
		END SEQUENCE
		
	Endif

Return Self
