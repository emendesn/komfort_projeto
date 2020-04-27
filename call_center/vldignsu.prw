#Include "Protheus.ch" 

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VLDIGNSU                                 Data �  30/01/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o Do NSU digitado, para minimizar os erros         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Shoebiz                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function VLDIGNSU(cChr)

Local lRet    	:= .T.
Local cCodBloq 	:= GetMv("MV_NSUBLOQ",,"000000000000|           |111111111111|222222222222|333333333333|444444444444|555555555555|666666666666|777777777777|888888888888|999999999999|123456789012")
//Local cChr     := AllTrim(M->XNSU)
Default cChr	:= ""

If Empty(cChr) .Or. cChr = ' '
//  MsgAlert("O NSU digitado � inv�lido. Digite o NSU CORRETAMENTE!!!")	//Alterado por Eduardo Clemente - 27/06/14 //#RVC20180622.o
  MsgStop("O NSU em branco. Digite o NSU.")	//#RVC20180622.n
  lRet := .F.     
//If Substr(UPPER(cChr),1,6) $ cCodBloq .OR. Len(cChr) < 6			//#RVC20180622.o
ElseIf Substr(UPPER(cChr),1,6) $ cCodBloq .OR. Len(Alltrim(cChr)) < 6	//#RVC20180622.n
//  MsgAlert("O NSU digitado � inv�lido. Digite o NSU CORRETAMENTE!!!")	//#RVC20180622.o  
  MsgStop("O NSU digitado � inv�lido. Digite o NSU CORRETAMENTE!!!")	//#RVC20180622.n
  lRet := .F.      
EndIF


//Verifica cada Caracter
//**********************
/*For x := 1 To Len(cChr)

	If !(Asc(Substr(cChr,x,1)) > 47 .And. Asc(Substr(cChr,x,1)) < 58).And.; //Verifica se existe Numeros
	      !(Asc(Substr(cChr,x,1)) == 32) //Verifica se existe Espaco

		MsgAlert("O caracter " + Substr(cChr,x, 1) + " n�o � permitido neste campo.")
		x    := Len(cChr)
		lRet := .F.

    EndIf

Next x*/

Return lRet

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VLDCARD                                  Data �  22/06/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o Do CART�O digitado, para minimizar os erros      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Komfort                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function VLDCARD(cCARD)

Local lRet    	:= .T.
Default cCARD	:= ""

If Empty(cCARD) .Or. cCARD = ' '
  MsgStop("Campo em branco. Informar Cart�o.")
  lRet := .F. 
ElseIf Len(Alltrim(cCARD)) < 4	
  MsgStop("Tamanho Inv�lido. M�nimo 4.")  
  lRet := .F.          
EndIF

Return lRet

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VLDFLAG         	                       Data �  16/11/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o Do CART�O digitado, para minimizar os erros      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Komfort                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function VLDFLAG(cADM,cFLAG)

Local lRet    	:= .T.
Local cCodEsp	:= SuperGetMV("KH_ADMESPC",.T.,"112")
Local cDescAdm1	:= ""
Local cDescAdm2	:= ""

Default cFLAG	:= ""

cDescAdm1 := GetAdvFVal("SAE","AE_DESC",xFilial("SAE") + cADM ,1,"OPERADORA1")
cDescAdm2 := GetAdvFVal("SAE","AE_DESC",xFilial("SAE") + cCodEsp,1,"OPERADORA2")

If Empty(cFLAG) .Or. cFLAG = ' '
	MsgStop("Campo em branco. Informar Bandeira.")
	lRet := .F. 
ElseIf cFLAG $ "AMERICAN EXPRESS|HIPER|HIPERCARD" .AND. !cADM $ cCodEsp
	MsgStop("AMEX/HIPER n�o permitido para "+ Alltrim(cADM) + " - " + Alltrim(cDescAdm1) + "." + chr(13) + chr(10) + "Utilizar a op��o " + Alltrim(cCodEsp) + " - " + Alltrim(cDescAdm2) + ".")
	lRet := .F.          
EndIF

Return lRet