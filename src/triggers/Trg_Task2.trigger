trigger Trg_Task2 on Task2__c (After update) {
    
	List<Task2__History> historyList = [select CreatedById,CreatedDate,Field,Id,IsDeleted,NewValue,OldValue,ParentId From Task2__History Where ParentId IN :trigger.newMap.keySet() ORDER BY CreatedDate DESC];
    
    system.debug('履歴リスト：'+historyList);
}