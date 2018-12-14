public class Cls_OwnerChg {

    //500A000000JdPrS    ケース
    //a0iA0000009Umbn    タスク

    //オブジェクトID（ケース or タスク）
    public ID id {get; set;}

   //タスクオブジェクト
    public Task2__c taskObj {get; set;}

    //ケースオブジェクト
    public Case caseObj {get; set;}

    //対象オブジェクト
    public String targetObj {get; private set;}

    //対象オブジェクトを示す固定値
    public static final String TARGET_OBJECT_TASK  = 'Task2__c';//タスク
    public static final String TARGET_OBJECT_CASE  = 'Case';//ケース

    public Cls_OwnerChg() {
 
        this.id= null;
        this.targetObj = null;
        this.taskObj = new Task2__c();
        this.caseObj = new Case();

    }
    
    public void main() {
        //ここに処理
        //TASK
        this.id= 'a0iA0000009Umbn';
        this.targetObj  = TARGET_OBJECT_TASK;
        this.taskObj = this.getTaskRecord(this.id)[0];
//        //CASE
//        this.id= '500A000000JdPrS';
//        this.targetObj  = TARGET_OBJECT_CASE;
//        this.caseObj = this.getCaseRecord(this.id)[0];
        
            if(!this.sendEmail()) {
                system.debug( '所有者変更通知メールの送信に失敗しました。');
            }

    }
    
    /**
     * @description  メール送信
     * @return       Boolean 送信成否（true：成功、false：失敗）
     *
     * @author       FJ FUKUMOTO
     * @date         2015/09/14
    */
    private Boolean sendEmail() {

        //初期化
        String devName = null;
        EmailTemplate mailObj = new EmailTemplate();
        ID objId = null;
        ID ownId = null;
        
        if(this.targetObj == TARGET_OBJECT_CASE) {
            devName = 'Temp_OwnerChgForCase';
            objId = this.caseObj.Id;
            ownId = this.caseObj.OwnerId;
        } else if(this.targetObj == TARGET_OBJECT_TASK) {
            devName = 'Temp_OwnerChgForTask2';
            objId = this.taskObj.Id;
            ownId = this.taskObj.OwnerId;
        }

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
        //テンプレートIDの取得
        Schema.SObjectType objType = EmailTemplate.SObjectType;
        Schema.DescribeSObjectResult objResult = objType.getDescribe();
        if (!objResult.isAccessible()) {
            return false;
        }
        List<EmailTemplate> mailList = [Select Id From EmailTemplate Where DeveloperName = :devName Limit 1];
        if(mailList == null || (mailList != null && mailList.size() == 0)) {
            return false;
        }
        mailObj = mailList[0];

        mail.setTemplateId(mailObj.Id); //メールテンプレートID
        mail.setTargetObjectId(ownId);  //ユーザID（ケースORタスクの所有者（OwnerId））
        mail.setSaveAsActivity(false);  //固定
        mail.setWhatId(objId);  //対象のオブジェクト（ケースORタスクのID）

        system.debug(mail);
        //メール送信
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }, false);
        system.debug(results);
        if(!results.get(0).isSuccess()) {
            return false;
        }
        return true;
    }

    private List<Case> getCaseRecord(ID recId) {

        List<Case> caseList = null;

        Schema.SObjectType objType = Case.SObjectType;
        Schema.DescribeSObjectResult objResult = objType.getDescribe();
        if (objResult.isAccessible()) {
            caseList = [Select Id, CaseNumber, OwnerId, LastModifiedDate From Case Where Id = :recId limit 1];
        }

        return caseList;
    }

    private List<Task2__c> getTaskRecord(ID recId) {

        List<Task2__c> taskList = null;

        Schema.SObjectType objType = Task2__c.SObjectType;
        Schema.DescribeSObjectResult objResult = objType.getDescribe();
        if (objResult.isAccessible()) {
            taskList = [Select Id, Name, OwnerId, LastModifiedDate From Task2__c Where Id = :recId limit 1];
        }

        return taskList;
    }

}