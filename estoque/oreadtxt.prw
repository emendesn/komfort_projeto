#IFDEF TOTVS
	#INCLUDE 'TOTVS.CH'
#ELSE
	#INCLUDE 'PROTHEUS.CH'
#ENDIF
#INCLUDE 'FILEIO.CH'

#define pEOL                    CHR(13)+CHR(10)
#define pDEFAULT_FILE_BUFFER    4096

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
class ReadTXT from longnameclass

    data nHnd as integer
    data cFName as string
    data cFSep as string
    data nFerror as integer
    data nOSError as integer
    data cFerrorStr as string
    data nFSize as integer
    data nFReaded as integer
    data nFBuffer as integer

    data _Buffer as array
    data _PosBuffer as integer
    data _Resto as string

    method New()
    method Open()
    method Close()
    method GetFSize()
    method GetError()
    method GetOsError()
    method GetErroStr()
    method ReadLine()

    method _ClearLastErr()
    method _SetError()
    method _SetOsError()

endclass


method new(cFName, cFSep, nFBuffer) class ReadTXT

    DEFAULT cFSep    := pEOL
    DEFAULT nFBuffer := pDEFAULT_FILE_BUFFER

    ::nHnd := -1
    ::cFName := cFName
    ::cFSep := cFSep
    ::_Buffer := {}
    ::_Resto := ''
    ::nFSize := 0
    ::nFReaded := 0
    ::nFerror := 0
    ::nOSError := 0
    ::cFerrorStr := ''
    ::_PosBuffer := 0
    ::nFBuffer := nFBuffer

return Self


method Open( ifMode ) class ReadTXT

local lRetValue := .T.

DEFAULT ifMode := 0

    ::_ClearLastErr()
    If ::nHnd != -1
        _SetError( -1, "Erro na abertura do arquivo Arquivo ja aberto")
        lRetValue := .F.
    EndIf

    // Abre o arquivo
    If ( ::nHnd := FOpen( ::cFName, ifMode ) ) > 0 .and. lRetValue

        // Tamanho do arquivo
        ::nFSize := FSeek( ::nHnd,  FS_SET, FS_END)

        // Posiciona no Inicio do Arquivo
        FSeek( ::nHnd, FS_SET )

    Else
        _SetError( -2, "Erro na abertura do arquivo (OS)", FError())
        lRetValue := .F.
    EndIf

return lRetValue


method Close() class ReadTXT

local lRetValue := .T.

    ::_ClearLastErr()
    If ::nHnd == -1
        _SetError( -3, "Arquivo ja esta fechado")
        lRetValue := .F.
    Else

        // Fecha o arquivo
        FClose(::nHnd)

        // Limpa o Buffer de Arquivo
        aSize( ::_Buffer, 0 )
        ::_Resto := ''
        ::nHnd := -1
        ::nFSize := 0
        ::nFReaded := 0
        ::_PosBuffer := 0

    EndIf

return lRetValue


method ReadLine( cReadLine ) class ReadTXT

local cTmp := ''
local cBuffer
local nRPos
local nRead

    // Incrementa a posicao do Buffer
    ::_PosBuffer++
    If ( ::_PosBuffer <= len( ::_Buffer ) )
        // A proxima linha ja esta no Buffer onde a rotina recupera e retorna
        cReadLine := ::_Buffer[ ::_PosBuffer ]
        return .T.
    EndIf

    if ( ::nFReaded < ::nFSize )

        // Continua a leitura ate o final do arquivo
        if ( nRead := FRead( ::nHnd, @cTmp, ::nFBuffer) ) < 0
            _SetError( -5, "Erro na leitura do arquivo (OS)", FError())
            return .f.
        endif

        //Soma a quantidade de Bytes lidos
        ::nFReaded += nRead

        // Considera como Buffer o restante a ultima leitura com o que acabou de ser lido
        cBuffer := ::_Resto + cTmp

        // Determina a ultima quebra
        If ( nRPos := RAt( ::cFsep, cBuffer) ) > 0

            // Pega o que sobrou na ultima quebra e guarda no resto
            ::_Resto := SubStr( cBuffer, nRPos + len( ::cFSep ) )

            // Isola o resto do buffer atual
            cBuffer := Left( cBuffer, nRPos- 1)
        Else

            // Nao tendo resto, o buffer é considerado inteiro
            ::_Resto := ''
        EndIf

        // Limpa e Recria o Array Cache
        // Por Default, as linhas vazias sao desconsideradas
        // Reseta o posicionamento do Buffer para o mrimeiro elemento
        // e retorna a primeira linha do buffer
        aSize( ::_Buffer, 0 )
        ::_Buffer := StrTokArr2( cBuffer, ::cFSep )
        ::_PosBuffer := 1
        cReadLine := ::_Buffer[ ::_PosBuffer ]
        return .t.

    EndIf

    ::_SetError( -4, "Final de arquivo")

return .F.

method GetError() class ReadTXT
    return ::nFError

method GetOsError() class ReadTXT
    return ::nOSError

method GetErroStr() class ReadTXT
    return ::cFerrorStr

method GetFSize() class ReadTXT
    return ::nFSize

method _SetError( nCode, cStr) class ReadTXT
    ::nFerror := nCode
    ::cFerrorStr := cStr
return

method _SetOsError( nCode, cStr, nOSError) class ReadTXT
    ::nFerror := nCode
    ::cFerrorStr := cStr
    ::nOSError := nOSError
return

method _ClearLastErr() class ReadTXT
    ::nFerror := 0
    ::cFerrorStr := ''
    ::nOSError := 0
return