#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������ı�
���Funcao �AFTERLOGIN      � Autor � Vanito Rocha        � Data �26/06/19  ��
��������������������������������������������������������������������������ı�
���Descricao � Carregar tela de Or�amentos Pendentes na abertura do sistema��
���          � de acordo com a Tabela SU7 e seus supervisores e o          ��
���          � par�metro KH_ADMORCA onde ficam os gestores                 ��
��������������������������������������������������������������������������ı�
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.              ��
��������������������������������������������������������������������������ı�
���Programador � Data   � BOPS �  Motivo da Alteracao                      ��
��������������������������������������������������������������������������ı�
���������������������������������������������������������������������������*/

User Function AfterLogin()

Local cId  		:= ParamIXB[1]
Local cNome 	:= ParamIXB[2]
Local cCodGer	:= SuperGetMV("KH_ADMORCA",.F.,"001184;000034;000006")
Local cAlias 	:= getNextAlias()
Local cQuery 	:= ""
Local cUserU7
Local lUsaExOr	:= SuperGetMV("KH_USAEXOR",,.F.)
Private cFilIni :=cFilAnt
Private cFilFim :=cFilAnt

iF !OAPP:LMDI
	If lUsaExOr
		If nModulo=13
			cQuery := " SELECT U7_CODUSU FROM SU7010 WHERE U7_TIPO='2' AND D_E_L_E_T_='' AND U7_CODUSU='"+__cUserID+"'"
			PLSQuery(cQuery, cAlias)
			
			cUserU7:=(cAlias)->U7_CODUSU
			
			(cAlias)->(dbCloseArea())
			
			
			If !Empty(cUserU7)
				__cUserID:=cUserU7
				
			Endif
			
			If !(__cUserID $ cCodGer)
				cFilIni :=cFilAnt
				cFilFim :=cFilAnt
			Else
				cQuery := " SELECT MIN(FILFULL) FILINI, MAX(FILFULL) FILFIM FROM SM0010 WHERE CODEMP='01'"
				
				PLSQuery(cQuery, cAlias)
				
				cFilIni:=(cAlias)->FILINI
				cFilFim :=(cAlias)->FILFIM
				
				(cAlias)->(dbCloseArea())
				
			Endif
			
			If !Empty(cUserU7) .OR. __cUserID $ cCodGer
				
				U_KHARNO1(cFilIni,cFilFim)
				
			Endif
		Endif
	Endif
Endif
Return
