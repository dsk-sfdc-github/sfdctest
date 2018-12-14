public with sharing class ConsoleCaseCheckController {

	public Account accRec {get; set;}

	public ConsoleCaseCheckController(ApexPages.StandardController sCon) {
		accRec = (Account)sCon.getRecord();
	}

	public Pagereference save() {

		try {
			upsert accRec;
		} catch (Exception e) {
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getStackTraceString());
			ApexPages.addMessage(myMsg);
			return null;
		}

		return new PageReference('/003A000001SSC2b');
	}

}