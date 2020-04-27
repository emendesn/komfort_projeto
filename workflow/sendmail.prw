#include "totvs.ch"
#Include "ap5mail.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SENDMAIL  �Autor  � Cristiam Rossi     � Data �  03/04/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o gen�rica de envio de e-mails                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Global / KomfortHouse                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function sendMail( cPara, cAssunto, cMensagem )
Local cAccount
Local cPassword
Local cServer
Local cError     := ""
Local lAutentica				// Necessita de autentica��o de e-mail
Local lResult    := .F.	// Retorno se enviou ou n�o a mensagem

	cAccount	 := AllTrim(GetMV( "MV_RELACNT" ))	 // ExpC1 : Conta para conexao com servidor SMTP
	cPassword    := AllTrim(GetMV( "MV_RELPSW"  ))	 // ExpC2 : Password da conta para conexao com o servidor SMTP
	cServer      := AllTrim(GetMV( "MV_RELSERV" ))	 // ExpC3 : Servidor de SMTP
	lAutentica   := GetMV( "MV_RELAUTH" )

	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult 

	If lResult .and. lAutentica
		lResult := Mailauth(cAccount,cPassword)
	Endif

	If lResult           

		SEND MAIL	FROM cAccount;
		TO      	cPara;
		SUBJECT 	cAssunto;
		BODY    	cMensagem;
		RESULT 		lResult

		If ! lResult //Erro no envio do email
			GET MAIL ERROR cError
		EndIf

		DISCONNECT SMTP SERVER
	endif

Return lResult
