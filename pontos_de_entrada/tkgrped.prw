#include "protheus.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#Include "Topconn.ch"
#Include "Ap5Mail.Ch"
#Include "xmlxfun.ch"
#INCLUDE "JPEG.CH"
#include "rwmake.ch"

#DEFINE MERCADORIA 	1
#DEFINE DESCONTO	2
#DEFINE	 ACRESCIMO	3
#DEFINE	 FRETE	   	4
#DEFINE	 DESPESA	5
#DEFINE	 BASEDUP	6
#DEFINE	 SUFRAMA	7
#DEFINE	 TOTAL		8

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TKGRPED   � Autor � AP6 IDE            � Data �  19/06/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Antes da grava��o do atendimento na rotina de Televendas   ���
�������������������������������������������������������������������������͹��
���Uso       � Casa Cenario.                                              ���
�������������������������������������������������������������������������ʹ��
��� Programador � Data   � Chamado � Motivo da Alteracao                  ���
�������������������������������������������������������������������������ʹ��
���Caio Garcia  �19/01/18�         �Ajuste para solicitar senhas          ���
���#CMG20180119 �        �         �                                      ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function TKGRPED( nLiquido, aParcelas, cOpera )

	Local aArea 		:= GetArea()
	Local aAreaSUA		:= SUA->(GetArea())
	Local nPTpEntre 	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_TPENTRE"})
	Local nPDtEntre		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_DTENTRE"})
	Local nPValFre		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_01VALFR"})
	Local nPFilSai		:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_FILSAI"})
	Local nPsMostrua	:= Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_MOSTRUA"})
	Local nX			:= 0
	Local nY			:= 0
	Local nTotalParcela	:= 0
	Local nParcelas		:= 0
	Local nEntrada		:= 0
	Local nFinanciado	:= 0
	Local nVlrFrete		:= 0
	Local aOk			:= {}
	Local aErros		:= {}
	Local cItem       	:= ""
	Local lRet 			:= .T.
	Local lOk			:= .F.
	//#CMG201080608.bn
	Local _aDesc   	:= {}
	Local _nDesc   	:= 0
	Local _nValTmp 	:= 0
	Local _nDescIt 	:= 0
	Local _nPosCam 	:= Ascan(aHeader,{|x|Alltrim(X[2])=="UB_DESC"})
	Local _nPosDtL 	:= Ascan(aHeader,{|x|Alltrim(X[2])=="UB_XLIBDES"})
	Local _nPosDMa 	:= Ascan(aHeader,{|x|Alltrim(X[2])=="UB_XDESMAX"})
	Local _nDescMax	:= GetMV("KH_DESMAXI")
	Local _nPos    	:= 0 
	Local cTipo 	:= ""
	Local cUserId	:= __cUserID
	Local _cGrpCred	:= GetMv("MV_KOGRPLB") //Usuario que poder�o liberar de orcamento para faturamento no Call Center
	//#CMG201080608.be
	Local aInfoCH	:= {}	//#RVC20180713.n
	Local cCodSAE	:= ""	//#RVC20180713.n
	Private _lWF    := .F.

	For _nx := 1 To Len(aCols)

		If aCols[_nx,_nPosCam] > _nDescIt

			_nDescIt := aCols[_nx,_nPosCam]

		EndIf

	Next _nx
	//#CMG20170119.en

	//�������������������������������������������������������������������������������Ŀ
	//�N�o permito alterar o atendimento com opera��o Faturamento.                    �
	//���������������������������������������������������������������������������������
	If lRet .And. cOpera=="1" .And. (!Empty(M->UA_NUMSC5))
		MsgStop("N�o � possivel alterar uma venda com pedido gerado. Utilize o cancelamento da venda.","Aten��o!")
		lRet := .F.
	Endif

	//�������������������������������������������������������������������������������Ŀ
	//�N�o permito alterar o atendimento, quando existirem contas a receber baixados. �
	//���������������������������������������������������������������������������������
	If lRet .And. cOpera=="1"
		lRet := A273VLD3()

		If !lRet
			MsgStop("N�o � possivel alterar a venda, existem titulos baixados. Utilize o cancelamento da venda.","Aten��o!")
		Endif
	Endif

	If lRet

		//�������������������������������������������������
		//� FAZ O TRATAMENTO PARA OS TIPOS DE PRODUTO     �
		//�������������������������������������������������
		For nY:=1 To Len(aCols)
			IF aCols[nY,nPsMostrua] == "2" 
				IF EMPTY(cItem)
					cItem := acols[nY,1]
					cTipo := 'MOSTRUARIO' 
				Else
					cItem := cItem + 	" \ " + acols[nY,1]
					cTipo := cTipo + 	" \ " + 'MOSTRUARIO' 
				EndIF
			ElseIF aCols[nY,nPsMostrua] == "5" 
				IF EMPTY(cItem)
					cItem := acols[nY,1]
					cTipo := 'SALDAO' 
				Else
					cItem := cItem + 	" \ " + acols[nY,1]
					cTipo := cTipo + 	" \ " + 'SALDAO' 
				EndIF
			Elseif aCols[nY,nPsMostrua] == "4" 
				IF EMPTY(cItem)
					cItem := acols[nY,1]
					cTipo := 'ACESSORIO' 
				Else
					cItem := cItem + 	" \ " + acols[nY,1]
					cTipo := cTipo + 	" \ " + 'ACESSORIO' 
				EndIF
			EndIF
		Next

		IF !EMPTY(cItem) .And. "MOSTRUARIO" $ cTipo  
			IF !MsgYesNo("Existem itens neste pedido que s�o de mostru�rio [" + cItem + "] , confirma a inclus�o do pedido ?","Confirma?") 
				Return(.F.)
			ELSE

				If Alltrim(cUserId) $ _cGrpCred //Verifica se � usu�rio do credito
					lRet := .T.
				//Else	
				//	lRet:= PedSenha() n�o ser� solicitado senha para mostru�rio, apenas manteremos o alerta (alinhado com Arnaldo) Marcio Nunes 04/07/2019
				EndIf
			EndIF
		Elseif !EMPTY(cItem) .And. "SALDAO" $ cTipo  //#WRP20180911 inclus�o da op��o sald�o
			IF !MsgYesNo("Existem itens neste pedido que s�o do tipo Sald�o [" + cItem + "] , confirma a inclus�o do pedido ?","Confirma?") 
				Return(.F.)
			ELSE

				If Alltrim(cUserId) $ _cGrpCred //Verifica se � usu�rio do credito
					lRet := .T.
				//Else	
				//	lRet:= PedSenha() n�o ser� solicitado senha para mostru�rio, apenas manteremos o alerta (alinhado com Arnaldo) Marcio Nunes 04/07/2019
				EndIf
			EndIF
		EndIF

	Endif

	//�����������������������������������������������������������������������������������������������������������Ŀ
	//�Exigir informa��o do financeiro para confirma��o do Pedido de Venda. Exemplo n� cheque/ cart�o/ Lote, etc; �
	//�������������������������������������������������������������������������������������������������������������
	If lRet .And. cOpera=="1"

		For nY := 1 To Len(aParcelas)

			If Alltrim(aParcelas[nY,3])=="CH"

				If Empty(SUBSTR(aParcelas[nY][4],1,1))
					MsgStop("� obrigat�rio informar os dados do Banco.","Aten��o!")
					lRet := .F.
					Exit
				Endif

				If Empty(SUBSTR(aParcelas[nY][4],4,1))
					MsgStop("� obrigat�rio informar os dados da Agencia.","Aten��o!")
					lRet := .F.
					Exit
				Endif

				If Empty(SUBSTR(aParcelas[nY][4],9,1))
					MsgStop("� obrigat�rio informar os dados da Conta.","Aten��o!")
					lRet := .F.
					Exit
				Endif

				If Empty(SUBSTR(aParcelas[nY][4],19,1))
					MsgStop("� obrigat�rio informar o numero do cheque.","Aten��o!")
					lRet := .F.
					Exit
				Endif

			ElseIf Alltrim(aParcelas[nY,3])=="CC"

				If Empty(SUBSTR(aParcelas[nY][4],1,1))
					MsgStop("� obrigat�rio informar os dados do Cart�o.","Aten��o!")
					lRet := .F.
					Exit
				Endif

			Endif

		Next

	Endif

	//�������������������������������������������������������������Ŀ
	//�Caso o campo UA_01PEDAN esta com conteudo, significa         �
	//�que esta vinculado ao outro pedido, portanto nao deve validar�
	//�o valor do frete.                                            �
	//���������������������������������������������������������������
	If lRet
		If Empty(M->UA_01PEDAN)

			For nY := 1 To Len(aCols)

				If (!aCols[nY][Len(aHeader)+1])

					nVlrFrete += aCols[nY,nPValFre]

					If aCols[nY,nPTpEntre] == '3' //Entrega no Cliente

						If aCols[nY,nPValFre] > 0

							nPos := Ascan( aOk , aCols[nY,nPDtEntre] )
							If nPos==0
								AAdd( aOk , aCols[nY,nPDtEntre] )
							Endif

						Else

							nPos := Ascan( aOk , aCols[nY,nPDtEntre] )
							If nPos==0
								nPosA := Ascan( aErros , aCols[nY,nPDtEntre] )
								If nPosA==0
									AAdd( aErros , aCols[nY,nPDtEntre] )
								Endif
							Endif

						Endif

					Endif

				Endif

			Next

			If Len(aErros) > 0
				//MsgStop("Existem datas de entrega sem o valor de frete informado.","Aten��o")
				//lRet := .F.
			Endif

		Endif

		//Valida o preenchimento do campo Observacao, quando o pedido estiver com pendencia financeira.
		If ( M->UA_PEDPEND == '2' ) .And. Empty(M->UA_OBS)
			MsgStop('Pedidos com pendencias financeiras, � obrigat�rio informar o motivo no campo observa��o.','Aten��o')
			lRet := .F.
		Endif

	Endif

	//Valida o preenchimento do campo Filial de Saida.
	If lRet
		For nY := 1 To Len(aCols)
			If (!aCols[nY][Len(aHeader)+1])
				If Empty(aCols[nY,nPFilSai])
					MsgStop("Existem Produtos que n�o foram informados a Filial de Sa�da.","Aten��o")
					lRet := .F.
				Endif
			Endif
		Next
	Endif

	//Valida o preenchimento do campo Filial de Saida.
	If lRet
		For nY := 1 To Len(aCols)
			If (!aCols[nY][Len(aHeader)+1])
				If Empty(aCols[nY,nPDtEntre])
					MsgStop("Existem Produtos que n�o foram informados a data de entrega.","Aten��o")
					lRet := .F.
				Endif
			Endif
		Next
	Endif

	If !(Alltrim(cUserId) $ _cGrpCred)//Se n�o for usu�rio do credito verifica necessidade de senha 

		//#CMG20170119.bn
		If lRet .And. _nDescIt > 0 .And. Len(aParcelas) > 0

			DbSelectArea("SAE")
			SAE->(DbSetOrder(1))
			SAE->(DbGoTop())

			For _nx := 1 To Len(aParcelas)

				If AllTrim(aParcelas[_nx,3]) $ "R$|CR"

					If Len(_aDesc) > 0

						_nPos := Ascan(_aDesc,{|x,y| x[2] == _nDescMax})

						If _nPos <> 0

							_aDesc[_nPos,3] += aParcelas[_nx,2]

						Else
							//Tipo          ,Desconto Max ,Valor
							AADD(_aDesc, {aParcelas[_nx,3],_nDescMax   ,aParcelas[_nx,2]})

						EndIf

					Else
						//Tipo          ,Desconto Max ,Valor
						AADD(_aDesc, {aParcelas[_nx,3],_nDescMax   ,aParcelas[_nx,2]})

					EndIf

				Else
					//#RVC20180713.bn
					IF AllTrim(aParcelas[_nx,3]) $ "CHT|CHK"
						aInfoCH := StrToKarr(aParcelas[_nx,4],"|")
//						cCodSAE	:= Alltrim(aInfoCH[8])	//#RVC20180729.o
						//#RVC20180729.bn
						If Len(aInfoCH) > 1
							cCodSAE	:= Alltrim(aInfoCH[8])
						Else
							cCodSAE	:= Subs(aParcelas[_nx,4],1,3)
						EndIf
						//#RVC20180729.en
					Else
					 	cCodSAE	:= Subs(aParcelas[_nx,4],1,3)
					EndIF
					//#RVC20180713.en
					
//					SAE->(DbSeek(xFilial("SAE")+Subs(aParcelas[_nx,4],1,3)))	//#RVC20180713.o
					SAE->(DbSeek(xFilial("SAE") + cCodSAE))						//#RVC20180713.o

					If SAE->AE_XDESMAX <> 0

						If Len(_aDesc) > 0

							_nPos := Ascan(_aDesc,{|x,y| x[2] == SAE->AE_XDESMAX})

							If _nPos <> 0

								_aDesc[_nPos,3] += aParcelas[_nx,2]

							Else
								//Tipo          ,Desconto Max     ,Valor
								AADD(_aDesc, {aParcelas[_nx,3],SAE->AE_XDESMAX,aParcelas[_nx,2]})

							EndIf

						Else
							//Tipo          ,Desconto Max     ,Valor
							AADD(_aDesc, {aParcelas[_nx,3],SAE->AE_XDESMAX,aParcelas[_nx,2]})

						EndIf

					Else

						MsgStop("N�o existe desconto m�ximo informado para a operadora "+SAE->AE_COD+" - "+AllTrim(SAE->AE_DESC)+;
						", por favor contate a �rea financeira!","NODESCMAX")

						lRet := .F.

						Exit

					EndIf

				EndIf

			Next _nx

			For _nx := 1 To Len(_aDesc)

				If _aDesc[_nx,3] > _nValTmp

					_nValTmp := _aDesc[_nx,3]

				EndIf

			Next _nx

			_nDesc := fVerPagto(_aDesc,_nValTmp)

			If _nDesc > 0

				For _nx := 1 to Len(aCols)

					aCols[_nx,_nPosDMa] := _nDesc

				Next _nx	     	

			EndIf

			If _nDescIt > _nDesc .And. lRet

				//MsgStop(cValToChar(_nDesc)+"%","DESCONTO")
				_lWF := .T.
				lRet := FVldPsw(_nDescIt,_nDesc,aCols)
				cMsg := IIF(lRet,"","� necess�rio informar a senha do gestor para libera��o do desconto.")

				If lRet

					For _nx := 1 to Len(aCols)

						aCols[_nx,_nPosDtL] := DtoC(Date())+" - "+Time()
						aCols[_nx,_nPosDMa] := _nDesc

					Next _nx

				Else

					_lWF := .F.

				EndIf

			EndIf

		EndIf

		If _lWF .And. lRet .And. M->UA_OPER == '1'

			lRet := MsgYesNo("O pedido ir� solicitar aprova��o de desconto por e-mail, deseja continuar com o processo?","WFCONTINUA")

		EndIf
		//#CMG20170119.en

	EndIf

	RestArea(aArea)
	RestArea(aAreaSUA)

Return(lRet)

/*�������������������������������������������������������������������������
���������������������������������������������������������������������������
�����������������������������������������������������������������������Ŀ��
���Programa �   fVerPagto � Autor � Caio Garcia       � Data � 19/01/18 ���
�����������������������������������������������������������������������Ĵ��
���Descricao� Verifica pagamentos 50%                                   ���
������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������
�������������������������������������������������������������������������*/
Static Function fVerPagto(_aTmp,_nMaiorV)

	Local _lRet  := .F.
	Local _ni    := 0
	Local _aTmp2 := {}
	Local _nDesc := 0

	For _ni := 1 To Len(_aTmp)

		If _aTmp[_ni,3] == _nMaiorV

			AADD(_aTmp2, {_aTmp[_ni,1],_aTmp[_ni,2],_aTmp[_ni,3]})

		EndIf

	Next _ni

	For _ni := 1 To Len(_aTmp2)

		If _aTmp2[_ni,2] > _nDesc

			_nDesc := _aTmp2[_ni,2]

		EndIf

	Next _ni

Return(_nDesc)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FVldPsw   �Autor  �Caio Garcia         � Data �  22/01/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Abre dialog para digita��o de senha                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Komfort House                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FVldPsw(_nDescIt,_nDesc,aColsIt)

	Local lMostrat	:= .T.
    Private	nSenha	:= 0
	Private _lSai   := .F.
	Private _cSenha := Space(20)
	Private _cYesNo := GetMV("KH_DESYORN")
	Private _lSenha := .F. 	 

	Static oDlg, oBitmap1 
	
	Default aColsIt	:= {}	

	If _cYesNo == 'S'
	
		//���������������������������������������������������������������������Ŀ
		//� Grava senha para libera��o via Token 4BIS                           //
		// Foi necess�rio criar as tabelas abaixo pois neste momento o pedido   //
		// ainda n�o est� gravado e o 4BIS precisa ler os dados para liberar    //
		// Marcio Nunes 26/06/2019 - Chamado: 9765                              //
		//�����������������������������������������������������������������������  

		nSenha	:= aleatorio(999999,1)//Gera senha aleat�ria
        
		//grava o total do pedido
		nValor := 0
		For ny := 1 To Len(aColsIt)
			If aCols[ny,50] ==.F.//Valida linha deletada, para n�o gravar, .F. n�o est� deletado 
				nValor += aCols[ny,7]
			EndIf		
		Next ny 
		
		DbSelectArea("ZL3")
		ZL3->(DbSetOrder(1))//ZL3_FILIAL+ZL3_CHAMAD
		If ZL3->(DbSeek(cFilAnt+M->UA_NUM))//utilizado vari�vel de mem�ria, pois o Alias n�o carrega			
			RecLock("ZL3",.F.)//Atualiza Senha		
			//Caso a porcentagem digitada seja igual a porcentagem atual, n�o � necess�rio alterar/solicitar nova senha.
			If (Alltrim(cValToChar(_nDescIt)) == Alltrim(ZL3->ZL3_DESCON) .And. ZL3->ZL3_LIBERA =='1' )
				lMostrat := .F.//N�o solicita senha caso o desconto seja o mesmo ja liberado
				_lSai 	:= .T.//retorna verdadeiro pois a senha ja foi digitada
				_lSenha := .T.//retorna verdadeiro pois a senha ja foi digitada	   	  	 	 
			Else
				ZL3_SENHA	:= cValToChar(nSenha)                                                   
				ZL3_LIBERA	:= ""//Zera o campo para que a solicita��o apare�a no 4BIS, a cada gera��o de senha	
				ZL3_DESCON	:= cValToChar(_nDescIt)
				ZL3_VALTOT	:= nValor 
				ZL3_DTLIBS	:= DATE()	                                                        						
				ZL3->(MsUnLock())           				
			EndIf
		Else   		                                                                                    
			RecLock("ZL3",.T.)//Grava os dados do Or�amento + Senha							
				ZL3_FILCH	:= cFilAnt
				ZL3_CHAMAD	:= M->UA_NUM                                             
				ZL3_DESCON	:= cValToChar(_nDescIt)
				ZL3_VALTOT	:= nValor
				ZL3_VENDED	:= M->UA_VEND +" - "+SA3->A3_NOME
				ZL3_CLIENT	:= M->UA_CLIENTE +" - "+SA1->A1_NOME 		             			
				ZL3_SENHA	:= cValToChar(nSenha)	                            
				ZL3_DTLIBS	:= DATE()
			ZL3->(MsUnLock())                                    
		EndIf			      
		
		//DELETA ITENS PARA DEMOSNTRA��O 4BIS  
		cQuery1 := "SELECT  ZL4_CHAMAD, ZL4_PROD FROM ZL4010 (NOLOCK) L4 "
		cQuery1 += " WHERE L4.ZL4_FILIAL='"+cFilAnt+"' AND L4.ZL4_CHAMAD='"+M->UA_NUM+"' AND D_E_L_E_T_='' " 
                                                  
		cAlias1 := getNextAlias()                    

		//Se encontrar deleta todos os itens para recriar abaixo, necess�rio pois o vendedor pode excluir itens do acols                              
		PLSQuery(cQuery1, cAlias1)
		DbSelectArea("ZL4")
		ZL4->(DbSetOrder(1))//Abre a area e grava os registros 
		If ZL4->(DbSeek(cFilAnt+M->UA_NUM))	                 
			While (cAlias1)->(!eof()) .And.  ZL4->ZL4_FILIAL == cFilAnt .And. ZL4->ZL4_CHAMAD == M->UA_NUM                          
				RecLock("ZL4",.F.)//Deleta itens e regrava abaixo        
					 ZL4->(DbDelete())
				ZL4->(MsUnLock())                                       
				ZL4->(DbSkip())                 
			   	(cAlias1)->(DbSkip())                                   
			 EndDo	
		EndIf
		
		//Grava os itens para demonstra��o no 4BIS	
		For nz := 1 To Len(aColsIt)
			If aCols[nz,50] ==.F.//Valida linha deletada, para n�o gravar, .F. n�o est� deletado 
				ZL4->(dbGoTop())			 		
				RecLock("ZL4",.T.)//Grava os dados do Or�amento + Senha		  					
					ZL4_FILIAL	:= cFilAnt
					ZL4_CHAMAD	:= M->UA_NUM                           
					ZL4_PROD	:= aCols[nz,2]       
					ZL4_ITEM	:= aCols[nz,1]	
					ZL4_DESCP	:= aCols[nz,3]                  
					ZL4_QUANT	:= aCols[nz,5]    
					ZL4_VALOR	:= aCols[nz,7]         
					ZL4_DESCON	:= cValToChar(aCols[nz,8])   		
				ZL4->(MsUnLock())  
			EndIf			
		Next nz 
		ZL4->(DBCloseArea())

		//���������������������������������������������������������������������Ŀ
		//� Criacao da Interface                                                �
		//����������������������������������������������������������������������� 
		If lMostrat // N�o mostra a tela caso ja esteja liberado e o desconto n�o foi alterado 
			MsgAlert("Aguarde o Token, para libera��o do Desconto!") 
			@ 125,81 To 322,504 Dialog oDlg Title OemToAnsi("LIBERA��O DE DESCONTO "+cValToChar(_nDescIt)+"%")
			@ 8,6 To 88,151
			@ 12,10 Say OemToAnsi("O desconto m�ximo para essa condi��o � de "+cValToChar(_nDesc)+"%") Size 125,13
			@ 22,10 Say OemToAnsi("Aguarde o Token para libera��o do desconto:") Size 125,13
			//@ 54,54 Get _cSenha PASSWORD Size 40,14
			@ 18,158 Button OemToAnsi("Confirma") Size 46,24 Action Vai(_cSenha,cValToChar(nSenha))
			@ 63,162 Button OemToAnsi("Sair") Size 36,16 Action Cancela()
			@ 30,15 BITMAP oBitmap1 SIZE 175, 157 OF oDlg FILENAME "\system\token.png" NOBORDER PIXEL Of oDlg      
        
			If _lSai == .F.
	
				Activate Dialog oDlg CENTER //valid Cancela()
	
			Else
	
				Close(oDlg)        
	
			EndIf
		EndIf

	Else

		_lSenha := .T.

	EndIf

Return(_lSenha)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Cancela   �Autor  �Caio Garcia         � Data �  22/01/2018 ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se o a Dialog pode ser finalizada.                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Komfort House                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Cancela()

	_lSai := .T.

	Close(oDlg)

Return( _lSai )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Vai       �Autor  �Caio Garcia         � Data �  22/01/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se o usu�rio digitou a senha correta              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Komfort House                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Vai(_cSenha,cSenhaZL3)  
     //Marcio nunes - retirada a obrigatoriedade da senha, ap�s liberado o pedido poder� ser gravado
	//Local _cSenSup := GetMV("KH_DESSENH") - par�metro substitu�do pela tabela ZL3

	//If AllTrim(_cSenha) == ""                               
	//	MsgInfo("Nenhuma senha foi digitada","NOSENHA")       
	//	_lSai := .T.
	//	Close(oDlg)
	//Else	
			//If Alltrim(cSenhaZL3) == AllTrim(_cSenha)       
				//Posiciona novamente na tabela para atualizar, caso a senha seja liberada pelo Gestor
				DbSelectArea("ZL3") 
				ZL3->(DbSetOrder(1))//ZL3_FILIAL+ZL3_CHAMAD
				If ZL3->(DbSeek(cFilAnt+M->UA_NUM))//posicioona para capturar o campo ZL3_LIBERA, que pode ter sido liberado posterior a digita��o da senha
					If Empty(ZL3->ZL3_LIBERA)                  
						MsgStop("Token n�o liberado. Aguarde a libera��o do Gestor, e clique novamente em Confirmar!","ERROSENHA")  
					Else
						_lSai 	:= .T.
						_lSenha := .T.
						//		MsgInfo("Desconto Liberado!","OKSENHA")
						If _lSai == .T.
							Close(oDlg)           
						EndIf
					EndIf                            
				EndIf
				ZL3->(dbCloseArea())
			//Else
			//	MsgStop("Senha incorreta!","ERROSENHA")
			//EndIf
	//EndIf
 
Return 


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PedSenha  � Autor � Ellen Santiago     � Data �  22/01/2018 ���
�������������������������������������������������������������������������͹��
���Descricao � Caso o pedido for de mostruario ser� solicitado senha      ���
�������������������������������������������������������������������������͹��
���Uso       � Komfort House                                              ���
���Fun��o desabilitada, Marcio Nunes 04/07/2019                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function PedSenha()

	Local _cSenha  := Space(20)
	Local _lSai    := .T.

	Private oDlg, oBitmap1

	//���������������������������������������������������������������������Ŀ
	//� Criacao da Interface                                                �
	//�����������������������������������������������������������������������
	@ 125,81 To 322,504 Dialog oDlg Title OemToAnsi("LIBERA��O PEDIDO DE VENDA TIPO MOSTRU�RIO") 
	@ 8,6 To 88,151
	@ 14,13 Say OemToAnsi("Para libera��o de pedidos do tipo mostru�rio � necess�rio digita��o da senha") Size 125,13
	@ 31,13 Get _cSenha PASSWORD Size 80,14
	@ 18,158 Button OemToAnsi("Confirma") Size 46,24 Action Vai(_cSenha,@_lSai) 
	@ 63,158 Button OemToAnsi("Sair") Size 46,24 Action (_lSai:= .F., oDlg:End())  
	@ 47,13 BITMAP oBitmap1 SIZE 075, 057 OF oDlg FILENAME "\system\logo.png" NOBORDER PIXEL Of oDlg
                                                                                                           
	Activate Dialog oDlg CENTER 

Return _lSai

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � A273VLD3 �Autor  � SYMM CONSULTORIA   � Data �  29/04/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida a exclusao do titulos financeiros gerado pelo       ���
���          � orcamento de vendas.	                                      ���
�������������������������������������������������������������������������͹��
���Uso       � TELEVENDAS - CALL CENTER                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A273VLD3()

Local cQuery 	:= ""
Local cAlias 	:= GetNextAlias()
Local lOk	 	:= .T.
Local aRotAuto 	:= {}
Local aBaixa   	:= {}

//#RVC20180611.bn
If INCLUI .OR. ALTERA //If INCLUI //#RVC20180613.n	
	Return(lOk)
EndIf
//#RVC20180611.en

cQuery += " SELECT E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_CLIENTE,E1_LOJA "
cQuery += " FROM "+RetSqlName("SE1")+" SE1 "
cQuery += " WHERE "
cQuery += " E1_FILORIG 		= '"+ Alltrim(cFilAnt) +"' "	//#RVC20180610.n
cQuery += " AND E1_NUMSUA 	= '"+SUA->UA_NUM+"' "			//#RVC20180610.n
cQuery += " AND E1_CLIENTE 	= '"+SUA->UA_CLIENTE+"' " 		//#RVC20180610.n
cQuery += " AND E1_LOJA    	= '"+SUA->UA_LOJA+"' "			//#RVC20180610.n
cQuery += " AND E1_BAIXA <> ' ' "
cQuery += " AND SE1.D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

(cAlias)->(DbGotop())

//If (cAlias)->(!Eof())
If (cAlias)->(Eof())
	lOk := .F.
Else
	_lBaixaE1 := .T. //#CMG20180713.n	
Endif
(cAlias)->( dbCloseArea() )

Return(lOk)
