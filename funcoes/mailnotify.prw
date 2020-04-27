#include "rwmake.ch"
#include "ap5mail.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � EnvMail  �Autor  � Vanito Rocha   � Data �  08/02/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Envia email com ate dois anexos                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Baruel                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MailNotify(_cEmailTo,_cEmailBcc,_cAssunto,_aMsg,_aAttach,_lMostraMsg)

Local _ni          := 0
Local _lOk         := .F.
Local _lSendOk     := .F.
Local _lRet        := .T.
Local _cError      := ""
Local _cAttach1    := ""
Local _cAttach2    := ""
Local _cMsg        := ""
Local _cArqLog     := ""
Local _cMailConta  := GETMV("MV_RELFROM")
Local _cMailServer := GETMV("MV_RELSERV")
Local _cMailLogin  := GETMV("MV_RELACNT")
Local _cMailSenha  := GETMV("MV_RELPSW")

// Monta o corpo do e-mail e cria o arquivo de log no sigaadv
_cMsg := "<html>"
_cMsg += "<div><span class=610203920-12022004><FONT face=Verdana color=#ff0000 size=2>"
_cMsg += "<strong>Workflow - Servi�o de Envio de Mensagens</strong></font></span></div><hr>"
For _ni := 1 To Len(_aMsg)
	_cMsg   	+= "<div><font face='Verdana' color='#000080' size='2'><span class=216593018-10022004>"+_aMsg[_ni]+"</span></font></div><p>"
	_cArqLog 	:= _aMsg[_ni] + Chr(13) + Chr(10)
Next _ni
_cMsg += "</html>"

//Verifica se existe o SMTP Server
If Empty(_cMailServer)
	If _lMostraMsg
		Help(" ",1,"SEMSMTP")
	EndIf
	Return(.F.)
EndIf
//Verifica se existe a CONTA
If Empty(_cMailConta)
	If _lMostraMsg
		Help(" ",1,"SEMCONTA")//"A Conta do email nao foi configurado !!!" ,"Atencao"
	EndIf
	Return(.F.)
EndIf
//Verifica se existe a Senha
If Empty(_cMailSenha)
	If _lMostraMsg
		Help(" ",1,"SEMSENHA")	//"A Senha do email nao foi configurado !!!" ,"Atencao"
	EndIf
	Return(.F.)
EndIf
// Verifica se existe destinatario
If Empty(_cEmailTo)
	Return(.F.)
EndIf
// Envia e-mail com os dados necessarios
CONNECT SMTP SERVER _cMailServer ACCOUNT _cMailConta PASSWORD _cMailSenha RESULT _lOk
If !_lOk .And. _lMostraMsg
	Aviso("Erro ao envio de e-mail","Erro ao conectar ao servidor SMTP",{"Fechar"})
EndIf
// Caso o sistema exija autenticacao, faz a autenticacao
If GetMv("MV_RELAUTH")
	If !MailAuth(_cMailLogin,_cMailSenha)
		If _lMostraMsg
			MsgInfo("Nao foi possivel autenticar no servidor "+_cMailServer,OemToAnsi("Erro na autenticacao"))
		EndIf
	EndIf
EndIf
If _lOk
	If ! ValType(_aAttach) == "U"
		If Len(_aAttach) > 0
			_cAttach1 := _aAttach[1]
			If Len(_aAttach) > 1
				_cAttach2 := _aAttach[2]
			EndIf
		EndIf
	EndIf
	
	//SEND MAIL FROM GETMV("MV_EMCONTA") TO _cEmailTo BCC _cEmailBcc SUBJECT _cAssunto BODY _cMsg ATTACHMENT _cAttach1, _cAttach2 RESULT _lSendOk  // Alterado Tiberio
	SEND MAIL FROM GETMV("MV_RELFROM") TO _cEmailTo BCC _cEmailBcc SUBJECT _cAssunto BODY _cMsg ATTACHMENT _cAttach1, _cAttach2 RESULT _lSendOk
	If !_lSendOk
		//Erro no Envio do e-mail
		GET MAIL ERROR _cError
		If _lMostraMsg
			MsgInfo(_cError,OemToAnsi("Erro no envio do e-mail"))
		EndIf
	EndIf
	
	DISCONNECT SMTP SERVER
	
Else
	
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR _cError
	If _lMostraMsg
		MsgInfo(_cError,OemToAnsi("Erro na conexao com o SMTP Server"))
	EndIf
	
EndIf

Return(_lSendOk)
