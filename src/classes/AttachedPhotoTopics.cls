/**
* クラス名      : AttachedPhotoTopics.cls
* クラス概要 : ファイル添付機能
* @created  : 2017/02/20 I Len Tran Thanh
* @modified :
*/
public without sharing class AttachedPhotoTopics {
   public static String pId {get; set;}
    public static String pName {get; set;}
    public static List<Attachment> listAttachment {get; set;}
    public static String message {get; set;}
    private static final Integer MAX_FILE_NUMBER = 10;
	public AttachedPhotoTopics(ApexPages.StandardController stdController) {
        try {
            BusinessTripReports__c btReport = (BusinessTripReports__c)stdController.getRecord();
            if(btReport != null) {
                //pid = btReport.Id;
                pid = 'a0qA0000004RhuD';
                List<BusinessTripReports__c> lstBusinessTripReports = [SELECT Id, Name FROM BusinessTripReports__c WHERE Id =: pId];
				pName = !lstBusinessTripReports.isEmpty() ? lstBusinessTripReports[0].Name : '';

				listAttachment = new List<Attachment>();
				for (Integer i = 0; i < MAX_FILE_NUMBER; i++) {
					listAttachment.add(new Attachment());
				}
            }
        } catch(Exception e) {
            System.debug('Exception: ' + e.getMessage() + ' Trace: ' + e.getStackTraceString());
        }
    }

    /*
	* showPageMessage
	*
	* @param: なし
	* @return: なし
	* @created: 2017/02/20 I Len Tran Thanh
	* @modified:
	*/
	public void showPageMessage() {
		if(String.isNotEmpty(message)) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, message));
		}
	}
}