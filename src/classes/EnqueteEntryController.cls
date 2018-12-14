public with sharing class EnqueteEntryController {
    public Enquete__c enq {get;set;}
    public Boolean isCompleted {get;set;}
    public String profileLabel {get{return SObjectType.Enquete__c.FieldSets.Profile.getLabel();}}
    public String weddingPlanLabel {get{return SObjectType.Enquete__c.FieldSets.WeddingPlan.getLabel();}}
    public String enqueteLabel {get{return SObjectType.Enquete__c.FieldSets.Enquete.getLabel();}}
    public List<FieldEntity> profileFieldList {get;set;}
    public List<FieldEntity> weddingPlanFieldList {get;set;}
    public List<FieldEntity> enqueteFieldList {get;set;}

    /**
     * コンストラクタ
     */
    public EnqueteEntryController() {
        this.enq = new Enquete__c();
        this.isCompleted = false;
        this.profileFieldList = new List<FieldEntity>();
        Map<String, Schema.SObjectField> enqueteFieldMap = Schema.SObjectType.Enquete__c.fields.getMap(); // for inlineHelpText
        
        for (Schema.FieldSetMember field : SObjectType.Enquete__c.FieldSets.Profile.getFields()) {
            FieldEntity fe = new FieldEntity(field);
            fe.helpText = enqueteFieldMap.get(fe.apiName).getDescribe().getInlineHelpText();
            this.profileFieldList.add(fe);
        }
        this.weddingPlanFieldList = new List<FieldEntity>();
        for (Schema.FieldSetMember field : SObjectType.Enquete__c.FieldSets.WeddingPlan.getFields()) {
            FieldEntity fe = new FieldEntity(field);
            fe.helpText = enqueteFieldMap.get(fe.apiName).getDescribe().getInlineHelpText();
            this.weddingPlanFieldList.add(fe);
        }
        this.enqueteFieldList = new List<FieldEntity>();
        for (Schema.FieldSetMember field : SObjectType.Enquete__c.FieldSets.Enquete.getFields()) {
            FieldEntity fe = new FieldEntity(field);
            fe.helpText = enqueteFieldMap.get(fe.apiName).getDescribe().getInlineHelpText();
            this.enqueteFieldList.add(fe);
        }
    }

    /**
     * 登録ボタン押下時アクション
     */
    public PageReference save() {
        this.isCompleted = true;
        return null;
    }
}