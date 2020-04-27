#IFDEF TOTVS
	#INCLUDE 'TOTVS.CH'
#ELSE
	#INCLUDE 'PROTHEUS.CH'
#ENDIF
#INCLUDE "FWBROWSE.CH"

// Constante para Array de Arquivos
#define F_NAME          1       /* Nome */
#define F_SIZE          2       /* Tamanho */
#define F_DATE          3       /* Date */
#define F_TIME          4       /* Hora */
#define F_ATTR          5       /* Atributos */

STATIC aFileLog

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³  ReadTXT  ³ Autor ³ Edilson Mendes       ³ Data ³ 11/03/20 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rotina para checar e criar o diretorio caso nao exista.    ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³ Paramet  ³                                                            ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MA010BUT()

Local aButtons := {}

	if .not. INCLUI
		aAdd( aButtons, { 'NOTE', {|| ProdLog() }, 'Log Alteracao', 'Log Alteracao' } )
	endif

return( aButtons )


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³  ProdLog  ³ Autor ³ Edilson Mendes       ³ Data ³ 11/03/20 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rotina para checar e criar o diretorio caso nao exista.    ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³ Paramet  ³                                                            ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC PROCEDURE ProdLog()

local oPanel
Local oDlg
local oBrowse
local oColumn

local aItens := {}

	 begin sequence

		// Inicia o processamento da rotina
		RptStatus({|| aItens := LoadLog( M->B1_COD ) }, "Aguarde...", "Carregando informacoes..." )

	 end sequence

	if len( aItens ) > 0

		DEFINE MSDIALOG oDlg                                      ;
		       TITLE    "Log de Produtos"                         ;
		       FROM     0, 0 TO 300,1300                          ;
			   PIXEL

		oPanel := tPanel():New( 0, 0,, oDlg,,,,,,100, 26)
		oPanel:Align := CONTROL_ALIGN_TOP

		DEFINE FWBROWSE oBrowse                                   ;
		       DATA     ARRAY                                     ;
			   ARRAY    aItens                                    ;
			   NO       CONFIG                                    ;
			   NO       REPORT                                    ;
			   NO       LOCATE                                    ;
			   OF       oDlg

		ADD COLUMN      oColumn                                   ;
		    DATA        { ||  aItens[ oBrowse:At(), 1] }          ;
			TITLE       "Codigo"                                  ;
			SIZE        13                                        ;
			HEADERCLICK { || .T.}                                 ;
			DOUBLECLICK { || MsgInfo( aItens[ oBrowse:At(), 1])}  ;
			OF          oBrowse

		ADD COLUMN      oColumn                                   ;
		    DATA        { ||  aItens[ oBrowse:At(), 2] }          ;
			TITLE       "Descricao"                               ;
			SIZE        20                                        ;
			HEADERCLICK { || .T.}                                 ;
			DOUBLECLICK { || MsgInfo( aItens[ oBrowse:At(), 2])}  ;
			OF          oBrowse

		ADD COLUMN      oColumn                                   ;
		    DATA        { ||  aItens[ oBrowse:At(), 3] }          ;
			TITLE       "UM"                                      ;
			SIZE         4                                        ;
			HEADERCLICK { || .T.}                                 ;
			DOUBLECLICK { || MsgInfo( aItens[ oBrowse:At(), 3])}  ;
			OF          oBrowse

		ADD COLUMN      oColumn                                   ;
		    DATA        { ||  aItens[ oBrowse:At(), 4] }          ;
			TITLE       "2UM"                                     ;
			SIZE         4                                        ;
			HEADERCLICK { || .T.}                                 ;
			DOUBLECLICK { || MsgInfo( aItens[ oBrowse:At(), 4])}  ;
			OF          oBrowse

		ADD COLUMN      oColumn                                   ;
		    DATA        { ||  aItens[ oBrowse:At(), 5] }          ;
			TITLE       "Fator Conversao"                         ;
			SIZE         4                                        ;
			HEADERCLICK { || .T.}                                 ;
			DOUBLECLICK { || MsgInfo( aItens[ oBrowse:At(), 5])}  ;
			OF          oBrowse			

		ADD COLUMN      oColumn                                   ;
		    DATA        { ||  aItens[ oBrowse:At(), 6] }          ;
			TITLE       "Tipo Conversao"                          ;
			SIZE         4                                        ;
			HEADERCLICK { || .T.}                                 ;
			DOUBLECLICK { || MsgInfo( aItens[ oBrowse:At(), 6])}  ;
			OF          oBrowse			

		ADD COLUMN      oColumn                                   ;
		    DATA        { ||  aItens[ oBrowse:At(), 7] }          ;
			TITLE       "Controla Rastro"                         ;
			SIZE         4                                        ;
			HEADERCLICK { || .T.}                                 ;
			DOUBLECLICK { || MsgInfo( aItens[ oBrowse:At(), 7])}  ;
			OF          oBrowse

		ADD COLUMN      oColumn                                   ;
		    DATA        { ||  aItens[ oBrowse:At(), 8] }          ;
			TITLE       "Controla Endereco"                       ;
			SIZE         4                                        ;
			HEADERCLICK { || .T.}                                 ;
			DOUBLECLICK { || MsgInfo( aItens[ oBrowse:At(), 8])}  ;
			OF          oBrowse

		ADD COLUMN      oColumn                                   ;
		    DATA        { ||  aItens[ oBrowse:At(), 9] }          ;
			TITLE       "Operacao"                                ;
			SIZE         7                                        ;
			HEADERCLICK { || .T.}                                 ;
			DOUBLECLICK { || MsgInfo( aItens[ oBrowse:At(), 9])}  ;
			OF          oBrowse

		ADD COLUMN      oColumn                                   ;
		    DATA        { || Stod(aItens[ oBrowse:At(), 10] ) }   ;
			TITLE       "Data"                                    ;
			SIZE         8                                        ;
			HEADERCLICK { || .T.}                                 ;
			DOUBLECLICK { || MsgInfo( aItens[ oBrowse:At(), 10])} ;
			OF          oBrowse

		ADD COLUMN      oColumn                                   ;
		    DATA        { ||  aItens[ oBrowse:At(), 11] }         ;
			TITLE       "Hora"                                    ;
			SIZE         4                                        ;
			HEADERCLICK { || .T.}                                 ;
			DOUBLECLICK { || MsgInfo( aItens[ oBrowse:At(), 11])} ;
			OF          oBrowse

		ADD COLUMN      oColumn                                   ;
		    DATA        { ||  aItens[ oBrowse:At(), 12] }         ;
			TITLE       "Usuario"                                 ;
			SIZE         4                                        ;
			HEADERCLICK { || .T.}                                 ;
			DOUBLECLICK { || MsgInfo( aItens[ oBrowse:At(), 12])} ;
			OF          oBrowse

		oBrowse:ACOLUMNS[1]:NALIGN := 0
		oBrowse:ACOLUMNS[1]:NALIGN := 2

 		oBrowse:GetBackColor( 16777215 )
		oBrowse:GetClrAlterRow( 16770250 )
		oBrowse:GetDescription("Lista de Codigos")
    
		oBrowse:SetLineHeight(25) //Altura de cada linha

		oBrowse:SetArray(aItens)
		oBrowse:Refresh()

 		ACTIVATE FWBROWSE oBrowse
		ACTIVATE MSDIALOG oDlg CENTERED

    else
		MsgInfo( "Nao existem a serem exibidas...")
	endif

return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³  LoadLog  ³ Autor ³ Edilson Mendes       ³ Data ³ 11/03/20 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rotina para a leitura dos arquivos de log.                 ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³ Paramet  ³                                                            ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC FUNCTION LoadLog( cProduto, oProcess )

local aRet      := {}
LOCAL cPasta    := "\logs\logestoque"
local cLine     := ''
local cTemp
local nParse
local nPos
local oLogFile

local aHeader   := {}
local aData     := {}

aFileLog := {}
cPasta   := iif( right( alltrim(cPasta), 1 ) == '\', right( alltrim(cPasta), -1 ), alltrim(cPasta) )
DIR_RECURS( cPasta )

if len( aFileLog ) > 0

	// Define a quantiddade de arquivos a serem processados
	// oProcess:SetRegua1( len( aFileLog ) )
	SetRegua( len( aFileLog ) )

	for nPos := 1 to len( aFileLog )

		IncRegua()

		oLogFile := ReadTXT():New( aFileLog[ nPos ][1] + "\" + aFileLog[ nPos ][2])
		If oLogFile:Open()

			While oLogFile:ReadLine(@cLine)

                // Header
				if SubStr( cLine, 1, 1) == '<'

					cTemp := SubStr( cLine, 2 , Len( cLine ) )
					AAdd( aHeader, cTemp )

				elseIf SubStr( cLine, 1, 1) == '>'

					nParse := 2
					cTemp  := ''
					while nParse <= len( cLine )

						if asc( SubStr(cLine, nParse, 1) ) != 124
                           cTemp += SubStr(cLine, nParse, 1)
						else
							aadd( aData, cTemp )
							cTemp := ''
						endif
						nParse++
					enddo

                    // Realiza a montagem do Array de retorno
					if len( aData ) >= 1

					    // Monta o retorno dos Dados
						if aData[1] == cProduto
							aadd( aRet, aData )
						endif
						aData := {}

					endif

				endif

			Enddo
			oLogFile:Close()

		endif

	next

endif

return( aRet )




STATIC PROCEDURE DIR_RECURS( cPath )

local nPos
local aFiles    := directory( cPath + '\*.*', 'D' )
local nFilCount := len( aFiles )


	FOR nPos := 1 TO nFilCount
		
		if aFiles[ nPos, F_ATTR ] == 'A'
			if right( upper(aFiles[ nPos, F_NAME ]), 3 ) == 'LOG'
				AADD( aFileLog, { cPath, aFiles[ nPos, F_NAME ] } )
			endif
		endif
		
		if 'D' $ aFiles[ nPos, F_ATTR ]
			if aFiles[ nPos, F_NAME ] <> '.'
				DIR_RECURS( cPath + '\' + aFiles[ nPos, F_NAME ] )
			endif
		endif
		
	next
		
return