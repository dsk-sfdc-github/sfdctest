public without sharing class ChgAccountController {

	private ApexPages.StandardController standCon = null;

	public ChgAccountController(ApexPages.StandardController sCon) {
		this.standCon = sCon;
	}

	public PageReference initAction() {

		system.debug('URL取得'+ApexPages.currentPage().getHeaders().get('Referer'));
		system.debug('URL取得'+ApexPages.currentPage().getHeaders());
		system.debug('URL取得'+ApexPages.currentPage().getParameters());

		for (String key: ApexPages.currentPage().getHeaders().keySet()) {
			system.debug('キー='+key+ '：値='+ ApexPages.currentPage().getHeaders().get(key));
		}
		if (UserInfo.getUserId() == '005A0000001v5cf') {
			//濱野敏明	コンソール
			return Page.MainFrame;

		} else {
			//通常ログイン
			return new PageReference('/' + this.standCon.getId() + '/e?nooverride=1');
		}

		return null;
	}
}