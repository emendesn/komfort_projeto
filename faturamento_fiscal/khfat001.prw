#include 'totvs.ch'
#include 'protheus.ch'

User Function KHFAT001()

    Local cUsrPriori := SUPERGETMV("KH_PRIORI", .T., "000478")//000779

    if !(__cUserid $ cUsrPriori)
        apMsgAlert("Usuario Sem Permissão para executar essa ação.","User without permission!")
        Return
    endif

    DbSelectArea("SC5")
    SC5->(dbSetOrder(1))

    if SC5->(dbseek(xFilial("SC5")+SC5->C5_NUM))

        if empty(alltrim(SC5->C5_XPRIORI))
            recLock("SC5",.F.)
                SC5->C5_XPRIORI := "1"
            SC5->(msUnlock())

            apMsgAlert("Pedido "+SC5->C5_NUM+" definido como prioridade.","SUCCESS")

        elseif alltrim(SC5->C5_XPRIORI) == '2'
            recLock("SC5",.F.)
                SC5->C5_XPRIORI := "1"            
            SC5->(msUnlock())       
        
            apMsgAlert("Pedido "+SC5->C5_NUM+" definido como prioridade.","SUCCESS")

        else
            recLock("SC5",.F.)
                SC5->C5_XPRIORI := "2"            
            SC5->(msUnlock())

            apMsgAlert("Removida Prioridade do Pedido "+SC5->C5_NUM+".","SUCCESS")

        endif

    endif
    
Return