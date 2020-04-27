#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MA030TOK � Autor � LUIZ EDUARDO F.C.  � Data �  21/10/2016 ���
�������������������������������������������������������������������������͹��
���Descricao � BUSCA OS ITENS DO PEDIDO INFORMADO                         ���
�������������������������������������������������������������������������͹��
���Uso       � KOMFORT HOUSE                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
USER FUNCTION MA030TOK()

Local aArea	   := GetArea()  
Local aAreaSU5 := SU5->(GetArea())  
Local aAreaAC8 := AC8->(GetArea())
Local nCodCont := GetSxeNum("SU5","U5_CODCONT")
Local cMay     := ""

//�����������������������������������������������������Ŀ
//� TRATAMENTO APENAS PARA A INCLUSAO DE NOVOS CLIENTES �
//�������������������������������������������������������
	IF INCLUI
		//If MsgYesNo("Deseja criar um contato (que ser� utilizado pelo SAC) para este cliente?","Aten��o")  
			Begin Transaction
			
			//����������������������������������������������������������Ŀ
			//� BUSCANDO A NUMERACAO SEQUENCIAL PARA O CODIGO DO CONTATO �
			//������������������������������������������������������������
			nCodCont := GetSxeNum("SU5","E5_CODCONT")
			cMay := "SU5"+Alltrim(xFilial("SU5"))+nCodCont
			
			While (MsSeek(xFilial("SU5")+nCodCont) .OR. !MayIUseCode(cMay))
				nCodCont := Soma1(nCodCont,Len(nCodCont))
			EndDo
			
			//������������������������������������������Ŀ
			//� GRAVANDO AS INFORMACOES DO CONTATO - SU5 �
			//��������������������������������������������
			SU5->(RecLock("SU5",.T.))
				SU5->U5_FILIAL  := xFilial("SU5")
				SU5->U5_CODCONT := nCodCont
				SU5->U5_CONTAT  := M->A1_NOME
				SU5->U5_END     := M->A1_END
				SU5->U5_BAIRRO  := M->A1_BAIRRO
				SU5->U5_MUN     := M->A1_MUN
				SU5->U5_EST     := M->A1_EST
				SU5->U5_CEP     := M->A1_CEP
				SU5->U5_CODPAIS := M->A1_DDI
				SU5->U5_DDD     := M->A1_DDD
				SU5->U5_FONE    := M->A1_TEL
				SU5->U5_FCOM1   := M->A1_TEL2
				SU5->U5_EMAIL   := M->A1_EMAIL
				SU5->U5_URL     := M->A1_HPAGE
				SU5->U5_ATIVO   := "1" // ATIVO SIM
				SU5->U5_STATUS  := "2" // CADASTRO ATUALIZADO
				SU5->U5_MSBLQL  := "2" // STATUS ATIVO 
				SU5->U5_01SAI   := M->A1_COD + M->A1_LOJA
			SU5->(MsUnLock()) 
			
			//��������������������������������������������������������������������������������������������Ŀ
			//� GRAVANDO AS INFORMACOES NA TABELA DE RELACIONAMENTO DE ENTIDADES - CONTATO X CLIENTE - AC8 �
			//����������������������������������������������������������������������������������������������
			DbSelectArea("AC8")
			AC8->(RecLock("AC8",.T.))
				AC8->AC8_FILIAL := xFilial("AC8") 
				AC8->AC8_ENTIDA := "SA1" 
				AC8->AC8_CODENT := M->A1_COD + M->A1_LOJA
				AC8->AC8_CODCON := nCodCont
			AC8->(MsUnLock())    
			
			End Transaction
			
			ConfirmSX8()		//#RVC20181126.n
		Else
		
			RollbackSX8()		//#RVC20181126.n
			
		EndIF

RestArea(aArea)
RestArea(aAreaSU5)
RestArea(aAreaAC8)

RETURN(.T.)