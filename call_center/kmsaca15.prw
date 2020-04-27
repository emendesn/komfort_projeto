#include 'protheus.ch'
#include 'parmtype.ch'

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � KMSACA11� Autor � MUrilo Zoratti     � Data �  11/12/18    ���
�������������������������������������������������������������������������͹��
���cadastro de comiss�o vendedores                                        ���
�������������������������������������������������������������������������͹��
���Uso       � 															  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

user function KMSACA15()
	
	Local cAlias := "ZK5"
	Local cTitulo:= "Cadastro Regi�o - Visitas"
	Local cVldExc:= "U_KMSACAEX()"
	Local cVldAlt:= "U_KMSACAIN()"

	AxCadastro(cAlias,cTitulo,cVldExc,cVldAlt)

Return

/*/
+------------------------------------------------------------------------------
| Descri��o     | Fun��o de valida��o de altera��o/ inclus�o para a AXCADASTRO()  
  Autor: Wellington Raul Pinto
  Data: 03/01/2019    
+------------------------------------------------------------------------------
/*/

User Function KMSACAIN()

	Local lRet := .F.
	local cUserEst := SUPERGETMV("KH_AGETEC", .T., "000779|000478|000695")

	if ALTERA
		if __cUserid $ cUserEst
			lRet := .T.
		else
			MsgInfo("Voc� n�o possu� permiss�o para executar est� fun��o!")
		endif
	elseif INCLUI
		if __cUserid $ cUserEst
			lRet := .T.
		else
			MsgInfo("Voc� n�o possu� permiss�o para executar est� fun��o!")
		endif
	EndIf

Return lRet

/*/
+------------------------------------------------------------------------------
 Descri��o     | Fun��o de valida��o de Exclus�o para a AXCADASTRO()  
 Autor: Wellington Raul Pinto
 Data: 03/01/2019  
+------------------------------------------------------------------------------
/*/

User Function KMSACAEX()

	Local lRet      := .F.
	local cUserEst := SUPERGETMV("KH_AGETEC", .T., "000779|000478|000695")
	
	if __cUserid $ cUserEst
		lRet := .T.
	else
		MsgInfo("Voc� n�o possu� permiss�o para executar est� fun��o!!")
	endif

Return lRet