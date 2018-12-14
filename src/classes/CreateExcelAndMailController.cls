/**
* プログラム内でエクセルを作成し、メールに添付します。
*/
public with sharing class CreateExcelAndMailController {

	public String sjisStr {get; set;}

	public Boolean sendFlg {get; set;}

	List<EmailTemplate> Templates = null;

	//コンストラクタ
	public CreateExcelAndMailController() {
		//this.sendTicketMail();
		this.sendFlg = false;
		this.sjisStr = '感じ';
	}

	public String sendMail() {
		//sendTicketMail();
		//this.sendFlg = true;
		//sendTicketMail();
		return null;
	}

	public Pagereference sendMailExec() {
		sendTicketMail();
		this.sendFlg = true;
		return null;
	}
	/** メールを送信します。 */
	public Pagereference sendTicketMail() {

		SendEmail sMail = new SendEmail();

		//送信先を設定
		List<String> toList = new List<String>();

		//オプトン社員
		toList.Add('toshi_hamano@densan-s.co.jp');
		//toList.Add('m_yoshida@letty.co.jp');

		//送信先がなければ、送信しない
		if(toList.size() == 0) {
			//システムエラー画面に遷移する
		}
		sMail.toAddressProp = toList;

		//Sender表示名
		sMail.senderDisplayNameProp = '管理者';
		List<Messaging.Emailfileattachment> attList = new List<Messaging.Emailfileattachment>();
		Messaging.Emailfileattachment att = new Messaging.Emailfileattachment();
//		Apexpages.Pagereference.getContent();

		//att.setBody(Page.SendMailAttachment.getContent());

		//添付設定
		//String str = '<html><head><meta HTTP-EQUIV="PRAGMA" CONTENT="NO-CACHE" /><meta HTTP-EQUIV="Expires" content="Mon, 01 Jan 1990 12:00:00 GMT" />'+
		//'</head><body><table align="center" cols="5" style="border-collapse: collapse;" width="704"><tr><td colspan="5" style="font-size:12pt; font-weight:bold;text-align:center;">&#34920;&#32025;&#65297;</td></tr>'+
		//'<tr><td colspan="2"></td><td colspan="3" style="font-size:28pt; vertical-align:middle; text-align:center;">OPTON</td></tr><tr>'+
        //'<td colspan="2" style="text-align:left;font-size:11pt;">&#12487;&#12540;&#12479;</td>'+
        //'<td colspan="3" style="height:13.5pt;text-align:left;font-size:11pt; background-color:#99cc00;">&#12487;&#12540;&#12479;&#12381;&#12398;&#12395;</td>'+
    	//'</tr></table></body></html>';

		//EncodingUtil.convertToHex(Blob.valueOf('に'));
		//system.debug('に(16進)(&#12395;)：'+EncodingUtil.convertToHex(Blob.valueOf('に')));
		//String result = null;
		//String hex = EncodingUtil.convertToHex(Blob.valueOf('あ'));
		//String hex = EncodingUtil.convertToHex(Blob.valueOf(Encodingutil.urlEncode('あ', 'Shift-JIS')));
		//system.debug('16進SJIS'+hex);
		//for (Integer i = 0, size = hex.length(); i < size; i = i + 2) {
			//result = result + '%' + hex.substring(i, i + 2);
		//}
		//system.debug('あenc(&#12354;)：'+Encodingutil.urlDecode(result, 'Shift-JIS'));

		//system.debug('あenc(&#12354;)：'+Encodingutil.urlEncode('あ', 'Shift-JIS'));

		//system.debug('あdec(&#12354;)：'+Encodingutil.urlDecode(Encodingutil.urlEncode('あ', 'Shift-JIS'), 'Shift-JIS'));
		//system.debug('&#12354;(2)(&#12395;)：'+this.sjisStr);
    	String str = '<html><head><meta HTTP-EQUIV="PRAGMA" CONTENT="NO-CACHE" /><meta HTTP-EQUIV="Expires" content="Mon, 01 Jan 1990 12:00:00 GMT" />'+
		'</head><body><table align="center" cols="5" style="border-collapse: collapse;" width="704"><tr><td colspan="5" style="font-size:12pt; font-weight:bold;text-align:center;">'+this.sjisStr+'</td></tr>'+
		'<tr><td colspan="2"></td><td colspan="3" style="font-size:28pt; vertical-align:middle; text-align:center;">OPTON</td></tr><tr>'+
        '<td colspan="2" style="text-align:left;font-size:11pt;">'+this.sjisStr+'</td>'+
        '<td colspan="3" style="height:13.5pt;text-align:left;font-size:11pt; background-color:#99cc00;">'+this.sjisStr+'</td>'+
    	'</tr></table></body></html>';

    	Blob fileBody = Blob.valueOf(str);

		att.setFileName('test.xls');
		att.setBody(fileBody);
		attList.add(att);
		sMail.setMailAttachment(attList);
		//sMail.setMailAttachment(Apexpages.Pagereference.getContent());
		//送信処理を呼び出す
		sMail.sendSingleEmailMsg();

		return null;
	}
}