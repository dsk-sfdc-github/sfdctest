public with sharing class SampleApexDetailController {

	public ApexPages.StandardController sCon = null;

	public SampleApexDetailController(ApexPages.StandardController controller) {
		this.sCon = controller;
	}

	public PageReference execBtn() {

		system.debug('ボタンが押せました。');
		return this.sCon.view();
	}
}