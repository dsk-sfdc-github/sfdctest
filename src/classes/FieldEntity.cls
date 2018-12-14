public with sharing class FieldEntity {
    public static final String TWO_COLUMN = 'col-xs-12 col-sm-6 col-md-6';
    public static final String ONE_COLUMN = 'col-xs-12 col-sm-12 col-md-12';

    public String labelName {get;set;}
    public String apiName {get;set;}
    public Boolean isRequired {get;set;}
    public String columnClass {get;set;}
    public Schema.DisplayType dataType {get;set;}
    public Boolean isRadio {
        get {return dataType == Schema.DisplayType.Picklist;}
    }
    public Boolean isCheck {
        get {return dataType == Schema.DisplayType.MultiPicklist;}
    }
    public Boolean isDate {
        get {return dataType == Schema.DisplayType.Date;}
    }
    public Boolean isTextArea {
        get {return dataType == Schema.DisplayType.TextArea;}
    }
    public Boolean isNormal {
        get {return (!isRadio && !isCheck && !isDate && !isTextArea);}
    }
    // 選択リスト値（LabelとValueの配列）
    public List<List<String>> options {get;set;}
    // ヘルプテキスト値
    public String helpText {get;set;}

    public FieldEntity(Schema.FieldSetMember field) {
        this.labelName = field.getLabel();
        this.apiName = field.getFieldPath();
        this.isRequired = field.getRequired();
        this.dataType = field.getType();
        
        if (this.isRadio || this.isCheck) {
            this.options = new List<List<String>>();
            for (Schema.PicklistEntry p : SObjectType.Enquete__c.Fields.getMap().get(this.apiName).getDescribe().getPicklistValues()) {
                this.options.add(new List<String>{p.getLabel(), p.getValue()});
            }
        }
        
        // 表示方式を指定
        if (this.isCheck || this.isTextArea) {
            this.columnClass = ONE_COLUMN;
        } else {
            this.columnClass = TWO_COLUMN;
        }
    }
}