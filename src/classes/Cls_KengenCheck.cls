public without sharing class Cls_KengenCheck {

    public Cls_KengenCheck() {
        
    }
    
    public PageReference btnAction() {
        Task2__c rec = [select Id, OwnerId From Task2__c Where ID = 'a0iA000000AWrAG'];
        
        rec.OwnerId = '005A0000005xTyY';
        
        update rec;
        return null;
    }
}