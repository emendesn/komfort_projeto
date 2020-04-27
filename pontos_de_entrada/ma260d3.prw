#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA: �MA260D3   �AUTOR: �Caio Garcia            �DATA: �08/10/18  ���
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
�����������������������������������������������������������������������������
*/

User Function MA260D3()

Local oButton1
Local oBitmap1
Local oGet1
Local oSay1   
Local _cOp		:= CriaVar("C2_NUM")//criavar determina o tamanho do campo que ir� receber a digita��o                     
Local aAllGrp 	:= UsrRetGrp(PswChave(RetCodUsr(__cUserId)),RetCodUsr(__cUserId))               
Local lAchou	:= .F.                        
Local nI		:= 0
Private _cMotivo := Space(20)                                                    
Private lSai 	:= .F.  
Static oDlg       
                                               
   //Verifica o grupo de usu�rios - Marcio Nunes           
    For nI := 1 to len(aAllGrp)  
    	If 	Alltrim(aAllGrp[ni]) == '000128' .Or. Alltrim(aAllGrp[ni]) == '000000'//Grupo PCP e Admin 	
    		lAchou	:= .T.
    		nI 		:= len(aAllGrp)             
    	EndIf
    Next nI
    
    If lAchou .And. IsInCallStack('U_MA260D3')   
	
		DEFINE MSDIALOG oDlg TITLE "OP" FROM 000, 000  TO 120, 440 COLORS 0, 16777215 PIXEL 
	
		@ 003, 001 SAY oSay1 PROMPT "INFORME OP DA TRANSFER�NCIA:" SIZE 114, 011 OF oDlg COLORS 0, 16777215 PIXEL
		@ 014, 000 MSGET oGet1 VAR _cOp Picture "@!" SIZE 100,10 PIXEL OF oDlg  F3 "SC2" Picture PesqPict("SC2","C2_NUM")
	   //	@ 028, 001 BITMAP oBitmap1 SIZE 052, 030 OF oDlg FILENAME "modelos\logo.jpg" NOBORDER PIXEL
		@ 038, 152 BUTTON oButton1 PROMPT "Confirma" SIZE 064, 014 OF oDlg ACTION Vai("",_cOp,.T.) PIXEL
				                                       
		If lSai == .F.			                               
			Activate Dialog oDlg CENTER valid Cancela()			
		Else			
			oDlg:End()			
		EndIf
	
	Else
    	  
	  DEFINE MSDIALOG oDlg TITLE "MOTIVO" FROM 000, 000  TO 120, 440 COLORS 0, 16777215 PIXEL
	
	    @ 003, 001 SAY oSay1 PROMPT "INFORME O MOTIVO DA TRANSFER�NCIA:" SIZE 114, 011 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 014, 000 MSGET oGet1 VAR _cMotivo SIZE 217, 010 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 028, 001 BITMAP oBitmap1 SIZE 052, 030 OF oDlg FILENAME "modelos\logo.jpg" NOBORDER PIXEL
	    @ 038, 152 BUTTON oButton1 PROMPT "Confirma" SIZE 064, 014 OF oDlg ACTION Vai(_cMotivo,"",.F.) PIXEL
		
		If lSai == .F.			
			Activate Dialog oDlg CENTER valid Cancela()	    
	    Else	    
	    	oDlg:End()	    
	    EndIf   
	    
	EndIf  
    
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Cancela   �Autor  �Caio Garcia         � Data �  08/10/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se o a Dialog pode ser finalizada.                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Cancela()

   If lSai == .F.

	   Alert("Por favor, informe um motivo." )

   EndIf	
    
Return( lSai )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Vai       �Autor  �Caio Garcia         � Data �  08/10/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se o usu�rio digitou os n�meros                   ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Vai(_cMotivo, _cOp, _lOp)
                
Local aAreaSd3	 := SD3->(GetArea())
Default _cMotivo := ""
Default _cOp	 := ""  
Default _lOp	 := .F.
    
    If AllTrim(_cMotivo) == "" .And. _lOp == .F.   		
   		Alert("Por favor, informe um motivo!")   		
   		lSai:= .F. 	
	ElseIf _lOp == .T. .And. Empty(_cOp)
   		Alert("Por favor, informe a OP!")   		
   		lSai:= .F.   
    Else 		
   		lSai := .T.   	  
		
		
	DbSelectArea("SD3")
	If SD3->( DbSetOrder(3), DbSeek(xFilial("SD3") + SD3->D3_COD+"90"+SD3->D3_NUMSEQ ) )  	  
		RecLock("SD3",.F.)		     
		If !Empty(_cOp)
			SD3->D3_01OP 	:= _cOp //grava OP
			SD3->D3_OBS 	:= "TRANSF.SIMP.(MATA260)-"+_cOp //transferencia simples  
			SD3->D3_01SOLI	:= "MATA260" 
			SD3->D3_01DTT	:= Ddatabase
		Else
			SD3->D3_OBS 	:= _cMotivo
		EndIf
		MsUnlock()	    				
	EndIf 
	
	If SD3->( DbSetOrder(3), DbSeek(xFilial("SD3") + SD3->D3_COD+"95"+SD3->D3_NUMSEQ ) )   	   
		RecLock("SD3",.F.)		     
		If !Empty(_cOp)
			SD3->D3_01OP 	:= _cOp //grava OP
			SD3->D3_OBS 	:= "TRANSF.SIMP.(MATA260)-"+_cOp //transferencia simples 
			SD3->D3_01SOLI	:= "MATA260"  
			SD3->D3_01DTT	:= Ddatabase                   
		Else
			SD3->D3_OBS 	:= _cMotivo     
		EndIf                                                  
		MsUnlock()					
	EndIf

 		oDlg:End()   
	    		    
	EndIf 
	
	SD3->(RestArea(aAreaSd3))
   
Return