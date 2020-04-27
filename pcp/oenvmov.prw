#IFDEF TOTVS
	#INCLUDE 'TOTVS.CH'
#ELSE
	#INCLUDE 'PROTHEUS.CH'
#ENDIF


/*���������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � EnvMovimento �Autor  �Edilson Mendes � Data �  14/09/19    ���
�������������������������������������������������������������������������͹��
���Desc.     � Classe para a geracao do LOG dos registros processados     ���
�������������������������������������������������������������������������͹��
���Propried. � cEnvDest  - Endereco dos destinatarios para envio do email.���
���          � cEnvCopia - Endereco dos destinatarios em copia do email.  ���
���          � cAssunto  - Descricao da informacao do email enviado.      ���
�������������������������������������������������������������������������͹��
���Metodos   � ::New            - Cria o objeto.                          ���
���          � ::AddErro        - Adiciona a informacao de Erro.          ���
���          � ::Send           - Realiza a montagem do Html e efetua o   ���
���          �                  - envio por email.                        ���
�������������������������������������������������������������������������͹��
���Uso       � P12                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
CLASS EnvMovimento

	// Declaracao das propriedades da Classe
	DATA cNumOp
	DATA cEnvDest
	DATA cEnvCopia
	DATA cAssunto
	DATA aHeader
	DATA aConteudo
	DATA aDados
	
	// Declara��o dos M�todos da Classe
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
