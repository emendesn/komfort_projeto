#include "protheus.ch"
User function KGBI005()

	Local _aFontes   := {}
	Local _aTipo     := {}
	Local _aArquivo  := {}
	Local _aData     := {}
	Local _aHora     := {}
	Local _nHdl      := 0
	Local _nPos      := 0
	Local _cNomeArq  := ""
	Local _cHtml     := ""
	Local _cDirFont  := "C:\FONTES_SVN\todos\"

	RPCSetType(3)
	RpcSetEnv("01","01",,,,GetEnvServer(),{})

	_cNomeArq  := GetTempPath()+Alltrim(FunName())+".XLS"
	_nHdl := fCreate(_cNomeArq)
	If _nHdl == -1
		MsgAlert("O arquivo de nome "+_cNomeArq+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
	Endif

	_cHtml := "<html><table>"
	_cHtml += "<tr>"
	_cHtml += "<td>Fonte</td>"
	_cHtml += "<td>Função</td>"
	_cHtml += "<td>Tipo</td>"
	_cHtml += "<td>Última Compilação</td>"
	_cHtml += "<td>Status</td>"
	_cHtml += "</tr>"
	fWrite(_nHdl,_cHtml,Len(_cHtml))

	_aFontes := GetFuncArray("*",_aTipo,_aArquivo,,_aData,_aHora)

	_cHtml := ""
	For _nPos := 1 to Len(_aFontes)
		//_aData := GetAPOInfo(_aFontes[_nPos])
		If AllTrim(Upper(_aTipo[_nPos])) == "USER"
			_cHtml += "<tr>"
			_cHtml += "<td>"+_aArquivo[_nPos]+"</td>"
			_cHtml += "<td>"+_aFontes[_nPos]+"</td>"
			_cHtml += "<td>"+_aTipo[_nPos]+"</td>"
			_cHtml += "<td>"+DtoC(_aData[_nPos])+" "+_aHora[_nPos]+"</td>"
			If File(_cDirFont+_aArquivo[_nPos])
				_nHdl2 := fOpen(_cDirFont+_aArquivo[_nPos],68)
				If _nHdl2 == -1
					_cHtml += "<td>Erro ao abrir o fonte</td>"
				Else
					_lEncontrou := .F.
					_nTamFile := fSeek(_nHdl2,0,2)
 					fSeek(_nHdl2,0,0)
 					_cBuffer := Space(1000)
 					_nBtLidos := fRead(_nHdl2,@_cBuffer,1000)
 					While _nBtLidos > 0
 						If "FUNCTION "+StrTran(Upper(AllTrim(_aFontes[_nPos])),"U_","") $ Upper(_cBuffer)
 							_lEncontrou := .T.
 							Exit
 						ElseIf StrTran(Upper(AllTrim(_aFontes[_nPos])),"U_","")  $ ("%"+_aArquivo[_nPos]+"%")//valida nome do fonte     
 							_lEncontrou := .T.
 							Exit
 						EndIf
 						_nBtLidos := fRead(_nHdl2,@_cBuffer,1000)
 					EndDo
 					If _lEncontrou
 						_cHtml += "<td>Fonte OK</td>"
 					Else
 						_cHtml += "<td>Função não encontrada</td>"
 					EndIf
				EndIf
			Else
				_cHtml += "<td>Arquivo não existe</td>"			
			EndIf
			_cHtml += "</tr>"
		EndIf
		If Len(_cHtml) > 10000
			fWrite(_nHdl,_cHtml,Len(_cHtml))
			_cHtml := ""
		EndIf
	Next _nPos
	fWrite(_nHdl,_cHtml,Len(_cHtml))
	
	fClose(_nHdl)
	ShellExecute("open",_cNomeArq,"","",5)

	RpcClearEnv()

Return
