#include "protheus.ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA: �MA261D3   �AUTOR: �Caio Garcia            �DATA: �08/10/18  ���
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

User Function MA261D3()

Local oButton1
Local oBitmap1
Local oGet1
Local oSay1
Private _cMotivo := Space(20)
Private lSai := .F.  
Static oDlg

    // Caso a execucao seja pela rotina de transferencia e/ou exclusao da 
    // ordem de producao, o sistema nao realizar a abertura da tela para que seja informado 
    // os dados do campo D3_OBS
	If IsInCallStack('U_KMHTRAN')  .OR. IsInCallStack('U_MA261D3')
   		lSai := .T.

	Else
		
		DEFINE MSDIALOG oDlg TITLE "MOTIVO" FROM 000, 000  TO 120, 440 COLORS 0, 16777215 PIXEL
		
		@ 003, 001 SAY oSay1 PROMPT "INFORME O MOTIVO DA TRANSFER�NCIA:" SIZE 114, 011 OF oDlg COLORS 0, 16777215 PIXEL
		@ 014, 000 MSGET oGet1 VAR _cMotivo SIZE 217, 010 OF oDlg COLORS 0, 16777215 PIXEL
		@ 028, 001 BITMAP oBitmap1 SIZE 052, 030 OF oDlg FILENAME "modelos\logo.jpg" NOBORDER PIXEL
		@ 038, 152 BUTTON oButton1 PROMPT "Confirma" SIZE 064, 014 OF oDlg ACTION Vai(_cMotivo) PIXEL
		
		
		If lSai == .F.
			
			Activate Dialog oDlg CENTER valid Cancela()
			
		Else
			
			oDlg:End()
			
		EndIf
		
	EndIf
	    
Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Cancela   �Autor  �Caio Garcia         � Data �  08/10/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se o a Dialog pode ser finalizada.                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

Static Function Cancela()

   If lSai == .F.

	   Alert("Por favor, informe um motivo." )

   EndIf	
    
Return( lSai )

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Vai       �Autor  �Caio Garcia         � Data �  08/10/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se o usu�rio digitou os n�meros                   ���
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Procedure Vai(_cMotivo)
    
    If AllTrim(_cMotivo) == ""
   		
   		Alert("Por favor, informe um motivo!")
   		
   		lSai:= .F.
   
    Else 		

   		lSai := .T.
   	  
		RecLock("SD3",.F.)
		SD3->D3_OBS := _cMotivo
		MsUnlock()

 		oDlg:End()   
	    		    
	EndIf
   
Return