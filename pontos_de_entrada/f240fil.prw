#include 'protheus.ch'
#include 'parmtype.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F240FIL   �Autor  �Rafael Cruz          � Data �  19.10.18  ���
�������������������������������������������������������������������������͹��
���Desc.     �O ponto de entrada F240FIL sera utilizado para montar o 	  ���
���          �filtro para Indregua apos preenchimento da tela de dados do ���
���          �bordero. O filtro retornado pelo ponto de entrada ser� 	  ���
���          �anexado ao filtro padr�o do programa.       				  ���
���          �aRotina na no contas a pagar.                               ���
�������������������������������������������������������������������������͹��
���Uso       �Espec�ficos Galderma Brasil                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function F240FIL()

Local aPerg		:= {}
Local cRet		:= ""
Local aRetParam	:= {}
Local dEmissao	:= CtoD("")

	If MsgYesNo("Deseja filtrar os t�tulos por data de emiss�o?","Filtro Border�")
	
		aAdd( aPerg ,{1,"Emiss�o De:  "      , dEmissao  ,"@!"                  ,'.t.',""  ,'.t.'    , 50,.t.})
		aAdd( aPerg ,{1,"Emiss�o Ate: "      , dEmissao  ,"@!"                  ,'.t.',""  ,'.t.'    , 50,.t.})  
	
		
		If !ParamBox(aPerg ,"Filtro titulos ",@aRetParam)
		
			Return(.F.)
		
		EndIf
		
		cRet := " DTOS(E2_EMISSAO) >= '" + DTOS(aRetParam[1]) + "' .AND. DTOS(E2_EMISSAO) <= '" + DTOS(aRetParam[2]) + "'"
	 
	 Else
	 
	 	Return(.F.)
	 
	 EndIf
	 
Return cRet