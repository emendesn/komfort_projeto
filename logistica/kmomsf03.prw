#Include "Protheus.ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA: �KMOMSF03  �AUTOR: �Caio Garcia            �DATA: �08/10/18  ���
�������������������������������������������������������������������������Ĵ��
���USADO EM: � Estoque/Custos - Komfort House                             ���
�������������������������������������������������������������������������Ĵ��
���	        ATUALIZACOES SOFRIDAS DESDE A CONSTRU��O INICIAL.		      ���
�������������������������������������������������������������������������Ĵ��
���  PROGRAMADOR  �  DATA  � ALTERACAO OCORRIDA 				          ���
�������������������������������������������������������������������������Ĵ��
���               |  /  /  |                                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function KMOMSF03()

Local oBitmap1
Local oButton1
Local oButton2
Local oGet1
Local _cTermo := Space(6)
Local oGet2
Local _cCarga := DAK->DAK_COD
Local oGet3

Local oSay1
Local oSay2
Local oSay3
Private lSai := .F.
Private oDlg

DEFINE MSDIALOG oDlg TITLE "Termo Retira x Carga" FROM 000, 000  TO 260, 380 COLORS 0, 16777215 PIXEL

@ 026, 005 SAY oSay1 PROMPT "Informe o Termo:" SIZE 053, 014 OF oDlg COLORS 0, 16777215 PIXEL
@ 042, 005 SAY oSay3 PROMPT "Informe a Carga:" SIZE 053, 014 OF oDlg COLORS 0, 16777215 PIXEL
@ 025, 060 MSGET oGet2 VAR _cTermo SIZE 113, 010 OF oDlg COLORS 0, 16777215 F3 "ZK0" Valid fVldTer(_cTermo,_cCarga) PIXEL
@ 039, 060 MSGET oGet3 VAR _cCarga SIZE 113, 010 OF oDlg COLORS 0, 16777215 F3 "DAK" When .F. Valid fVldCarga(_cCarga) PIXEL
@ 081, 005 BITMAP oBitmap1 SIZE 064, 042 OF oDlg FILENAME "modelos\logo.jpg" NOBORDER PIXEL
@ 080, 078 BUTTON oButton1 PROMPT "Associar" SIZE 106, 027 OF oDlg ACTION (Vai(_cTermo,_cCarga),oDlg:End()) PIXEL
@ 113, 148 BUTTON oButton2 PROMPT "Sair" SIZE 036, 013 OF oDlg ACTION oDlg:End() PIXEL

If !lSai
	
	Activate Dialog oDlg CENTER //valid Cancela()
	
Else
	
	oDlg:End()
	
EndIf

SF2->(DbCloseArea())
SA1->(DbCloseArea())

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA: �Cancela   �AUTOR: �Caio Garcia            �DATA: �08/10/18  ���
�������������������������������������������������������������������������Ĵ��
���USADO EM: � Estoque/Custos - Komfort House                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function Cancela()

lSai := MsgYesNo("Deseja Sair da Rotina?","SAIR?")

Return( lSai )

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA: �Vai       �AUTOR: �Caio Garcia            �DATA: �08/10/18  ���
�������������������������������������������������������������������������Ĵ��
���USADO EM: � Estoque/Custos - Komfort House                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function Vai(_cTermo,_cCarga)

Local _lProcessa := .T.

_lProcessa := fVldCarga(_cCarga)

If _lProcessa
	
	lSai := MsgYesNo("Confirma a inclus�o do Termo "+AllTrim(_cTermo)+" na carga "+AllTrim(_cCarga)+ "?")
	
	If lSai
		
		DbSelectArea("ZK0")
		ZK0->(DbSetOrder(1))
		ZK0->(DbGoTop())
		
		ZK0->(DbSeek(xFilial("ZK0")+_cTermo))
		
		RecLock("ZK0",.F.)
		ZK0->ZK0_CARGA := _cCarga
		ZK0->(MsUnLock())		
			
	EndIf
	
EndIf

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA: �fVldTer   �AUTOR: �Caio Garcia            �DATA: �08/10/18  ���
�������������������������������������������������������������������������Ĵ��
���USADO EM: � Estoque/Custos - Komfort House                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function fVldTer(_cTermo,_cCarga)

Local _lRet := .T.

DbSelectArea("ZK0")
ZK0->(DbSetOrder(1))
ZK0->(DbGoTop())

If ZK0->(DbSeek(xFilial("ZK0")+_cTermo))
                                
	If !Empty(AllTrim(ZK0->ZK0_CARGA))
	     
		_lRet := MsgYesNo("O termo j� est� associado a carga "+ZK0->ZK0_CARGA+", confirma a altera��o para a carga "+_cCarga+" ?")
	
	EndIf

Else

	Alert("Termo n�o localizado!")     
	_lRet := .F.

EndIf

Return _lRet

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA: �fVldCarga  �AUTOR: �Caio Garcia           �DATA: �08/10/18  ���
�������������������������������������������������������������������������Ĵ��
���USADO EM: � Estoque/Custos - Komfort House                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function fVldCarga(_cCarga)

Local _lRet := .T.
Local lBlqCar   := ( DAK->(FieldPos("DAK_BLQCAR")) > 0 )
Local cCplInt   := SuperGetMv("MV_CPLINT",.F.,"2")
Local lBloqueio := .F.

DbSelectArea("DAK")
DAK->(DbSetOrder(1))

If DAK->(DbSeek(xFilial("DAK")+_cCarga))
	
	lBloqueio := OsBlqExec(DAK->DAK_COD, DAK->DAK_SEQCAR)
	//Integra��o OMSxCPL
	If DAK->(ColumnPos("DAK_VIAROT")) > 0
		If !Empty(DAK->DAK_VIAROT) .And. cCplInt == '1'
			Help(" ",1,"OMS200MNTCPL")//Carga gerada pela integra��o com o Cockpit Log�stico, manuten��o n�o permitida.
			_lRet := .F.
		EndIf
	EndIf
	
	If	GetMV("MV_MANCARG") == "N" .And. DAK->DAK_FEZNF == "1"
		Help(" ",1,"OMS200CFAT") //Esta carga j� se encontra faturada.
		_lRet := .F.
	EndIf
	
	//��������������������������������������������������������������Ŀ
	//� Primeiro verifica se a carga selecionada ainda pode ser edit.�
	//����������������������������������������������������������������
	If !Empty(DAK->DAK_JUNTOU) .And. DAK->DAK_JUNTOU != "JUNTOU" .And. DAK->DAK_JUNTOU != "MANUAL" .And. DAK->DAK_JUNTOU != "ASSOCI"
		Help(" ",1,"DS2602141") //A carga selecionada est� indispon�vel para manipula��es.
		_lRet := .F.
	EndIf
	
	If DAK->DAK_ACECAR == "1"
		Help(" ",1,"DS2602143") //Retorno de Cargas j� realizado, n�o � poss�vel a Manipula��o desta Carga.
		_lRet := .F.
	EndIf
	
	//�������������������������������������������������������������������Ŀ
	//�Verifica se existe o campo e se esta bloqueada                     �
	//���������������������������������������������������������������������
	If ( lBlqCar .And. DAK->DAK_BLQCAR == '1' ) .Or. lBloqueio
		_lRet := .F.
		Help(" ",1,"OMS200CGBL") //Carga bloqueada ou com servi�o em execu��o.
	EndIf
	
EndIf

Return _lRet
