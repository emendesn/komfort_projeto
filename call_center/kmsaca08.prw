#Include "Protheus.ch"
#Include "RwMake.ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � KMSACA08 �Autor  � LUIZ EDUARDO F.C.  � Data � 28/06/2017  ���
�������������������������������������������������������������������������͹��
���Desc.     � TELA DE MANUTENCAO DOS TERMOS DE RETIRA 					  ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
USER FUNCTION KMSACA08()   

Local aCores  := {{'ZK0->ZK0_STATUS == "1"', 'BR_VERMELHO'},{'ZK0->ZK0_STATUS == "2"', 'BR_AZUL'},;
				  {'ZK0->ZK0_STATUS == "3"', 'BR_VERDE'},{'ZK0->ZK0_STATUS == "1"', 'BR_LARANJA'}}
			
			
Private cCadastro := "TERMOS DE RETIRA"
Private cString   := "ZK0"
Private aRotina   := {{'Procurar','AxPesqui',0,1},;
{'Visualisar','AxVisual',0,2},;
{'Incluir','AxInclui',0,3},;
{'Alterar','AxAltera',0,4},;
{'Excluir','U_ExclTer()',0,5},;
{'Legenda', 'U_LEGCA08()',0,6}}

dbSelectArea("ZK0")
dbSetOrder(1)
MBrowse(6,1,22,75,cString,,,,,,aCores)

Return()

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � KMSACA08 �Autor  � LUIZ EDUARDO F.C.  � Data � 28/06/2017  ���
�������������������������������������������������������������������������͹��
���Desc.     � TELA DE MANUTENCAO DOS TERMOS DE RETIRA 					  ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function LEGCA08()

   aLegenda := { {'BR_VERMELHO',	"Pendente" },;
                 {'BR_VERDE',    	"Finalizado"},;
                 {'BR_AZUL',		"Carga Montada"},;
                 {'BR_LARANJA',		"Nao Entregue "} }
                
                 
   BRWLEGENDA( cCadastro, "Legenda", aLegenda )

Return(.T.)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � KMSACA08 �Autor  � LUIZ EDUARDO F.C.  � Data � 28/06/2017  ���
�������������������������������������������������������������������������͹��
���Desc.     � TELA DE MANUTENCAO DOS TERMOS DE RETIRA 					  ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function ExclTer()

	Local lRet      := .F.
	local cUserEst := SUPERGETMV("KH_EXCLTER", .T., "000478|001148")
	Local aAreaZK0 := ZK0->(GetArea())
	Local cCodigo := ZK0->ZK0_COD
	
	if __cUserid $ cUserEst
		lRet := .T.
		DbSelectArea('ZK0')
	    ZK0->(DbSetOrder(1)) //ZK0_FILIAL + ZK0_COD
	    ZK0->(DbGoTop())
	    //Se conseguir posicionar no agendamento T�cnico
	    If ZK0->(DbSeek(xFilial('ZK0')+cCodigo))
	        AxDeleta('ZK0', ZK0->(RecNo()), 5)
	    EndIf
	     
	    RestArea(aAreaZK0)
	else
		MsgAlert("Voc� n�o possu� permiss�o para executar est� fun��o!!")
	endif

Return lRet



