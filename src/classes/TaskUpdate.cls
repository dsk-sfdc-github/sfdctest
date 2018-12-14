public class TaskUpdate {

	//コンストラクタ
	public TaskUpdate() {

	}

	public pageReference dmlTask() {

		Task2__c taskRec = new Task2__c();

		insert taskRec;

		taskRec.status__c = 'あいうえお';
		update taskRec;

		return null;
	}

}