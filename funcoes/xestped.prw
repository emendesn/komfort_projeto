
#include 'rwmake.ch'
#include 'totvs.ch'
#include 'protheus.ch'
#include 'topconn.ch'
#include 'tryexception.ch'
#include 'parmtype.ch'

/*
----------------------------------------------------------------|
-> Rotina responsavel por estornar os itens do pedido de venda	|
-> By Alexis Duarte									            |
-> 14/08/2018                                                   |
-> Uso: Komfort House                                           |
----------------------------------------------------------------|
*/

User Function xEstPed(cPedido)
    
	Local aArea     := GetArea()
    Local aAreaC5   := SC5->(GetArea())
    Local aAreaC6   := SC6->(GetArea())
    Local aAreaC9   := SC9->(GetArea())
    Local lRped     := .F.

    Default cPedido := ""
     
    DbSelectArea('SC5')
    SC5->(DbSetOrder(1)) //C5_FILIAL + C5_NUM
    SC5->(DbGoTop())
     
    DbSelectArea('SC6')
    SC6->(DbSetOrder(1)) //C6_FILIAL + C6_NUM + C6_ITEM
    SC6->(DbGoTop())
 
    DbSelectArea('SC9')
    SC9->(DbSetOrder(1)) //C9_FILIAL + C9_PEDIDO + C9_ITEM
    SC9->(DbGoTop())
    
    if SC5->(DbSeek(FWxFilial('SC5') + cPedido))
    	if !empty(alltrim(SC5->C5_NOTA))
    		msgAlert("Não é possivel estornar pedidos ja faturados.","ATENÇÃO")
    		
    		RestArea(aAreaC9)
		    RestArea(aAreaC6)
		    RestArea(aAreaC5)
		    RestArea(aArea)
		    		
    		return
    	endif
    endif
    
    Begin Transaction
     
    //Se conseguir posicionar no pedido
    If SC5->(DbSeek(FWxFilial('SC5') + cPedido))
        //Se conseguir posicionar nos itens do pedido
        If SC6->(DbSeek(FWxFilial('SC6') + cPedido))
            //Percorre todos os itens
            While ! SC6->(EoF()) .And. SC6->C6_FILIAL = FWxFilial('SC6') .And. SC6->C6_NUM == cPedido
                //Posiciona na liberação do item do pedido e estorna a liberação
                SC9->(DbSeek(FWxFilial('SC9')+SC6->C6_NUM+SC6->C6_ITEM))
                While  (!SC9->(Eof())) .AND. SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM) == FWxFilial('SC9')+SC6->(C6_NUM+C6_ITEM) .AND. empty(SC9->C9_NFISCAL)
                    SC9->(a460Estorna(.T.))
                    SC9->(DbSkip())
                EndDo
                
 	    		RecLock("SC6",.F.)
					if IsInCallStack('U_AGEND')
                        SC6->C6_ENTREG := stod('99990909')
                    endif
                    SC6->C6_01AGEND := "2"
					SC6->C6_LOCALIZ := ""
				MsUnlock()
				
					
                SC6->(DbSkip())
                 lRped := .T.
            EndDo
     
            RecLock("SC5", .F.)
                SC5->C5_LIBEROK := ""
            SC5->(MsUnLock())
        EndIf
    EndIf
    
 	End Transaction
    
    RestArea(aAreaC9)
    RestArea(aAreaC6)
    RestArea(aAreaC5)
    RestArea(aArea)
    
Return(lRped)