/**
 *	@class	Salesforceテンプレートメール送信クラス
 *	オプトンサンプル
 *	@version 1.0
 *	@since 2010/07/24
 *	@author	澤山　加奈子
 *	修正履歴	2010/09/07	澤山　加奈子
 *				活動の関連先を置換対象オブジェクトとは別に指定できるように修正
 *				2011/01/12	澤山　加奈子
 *				ファイルの添付をサポートするように修正
 **/
//public class SendEmail Extends LettyBase
public class SendEmail
{

	/*==================================
	 *	private宣言部
	====================================**/
	/** メールタイトル **/
	private String subject = null;

	/** 活動に保存するか判断する値 **/
	private boolean isSaveActivity = false;

	/** プレーンテキスト本文 **/
	private String textBody = null;

	/** Htmlメール本文 **/
	private String htmlBody = null;

	/** メール本文追加情報 */
	private List<List<String>> addObjTypeArr = null;

	/** メールTo **/
	private List<String> toAddress = null;

	/** メールCc **/
	private List<String> ccAddress = null;

	/** メールBcc **/
	private List<String> bccAddress = null;

	/** メール関連オブジェクト **/
	private List<sObject> objectList = null;

	/** メール関連オブジェクトの名前リスト **/
	private List<List<String>> objTypeArr = null;

	/** Sender表示名 **/
	private String senderDisplayName = null;

	/** 返信先 **/
	private String replyTo = null;

	/** 活動先関連オブジェクトのId **/
	private Id whatId = null;

	/** メールに添付するファイルのリスト **/
	private List<Messaging.Emailfileattachment> fas = null;

	/*----------------------------------
	 *	final宣言部
	 -----------------------------------**/
	private final String FINISH = '完了';
	private final String TO = '追加先：';
	private final String CC = 'Cc：';
	private final String BCC = 'Bcc';
	private final String RETUN = '\n\n';
	private final String DEFAULT_REPLY_TO = 'no-reply@salesforce.com';

	/*==================================
	 *	public宣言部
	====================================**/

	/** 活動に保存するか判断する値のプロパティ　**/
	public boolean isSaveActivityProp {
		set {isSaveActivity = value; }
	}

	/** メールToのプロパティ **/
	public List<String> toAddressProp{
		set{toAddress = value;}
	}

	/** メールCcのプロパティ **/
	public List<String> ccAddressProp{
		set{ccAddress = value;}
	}

	/** メールBccのプロパティ **/
	public List<String> bccAddressProp{
		set{bccAddress = value;}
	}

	/** メール関連オブジェクトのプロパティ **/
	public List<sObject> objectListProp {
		set{objectList = value;}
	}

	/** Sender表示名のプロパティ **/
	public String senderDisplayNameProp{
		set{senderDisplayName = value;}
	}

	/** 返信先のプロパティ **/
	public String replyToProp
	{
		set{replyTo = value;}
	}

	/** 活動関連先Idのプロパティ **/
	public Id whatIdProp
	{
		set{whatId = value;}
	}

	/**
	 * コンストラクタ
	 *
	 * @param objTypeArr
	 */
	//public SendEmail(List<List<String>> objTypeArr) {
	public SendEmail() {
		//this.objTypeArr = objTypeArr;
	}

	/*++++++++++++++++++++++++++++++++++
	 *	public処理部
	++++++++++++++++++++++++++++++++++**/

	public void setAddTextArr(List<List<String>> addObjTypeArr) {
		this.addObjTypeArr = addObjTypeArr;
	}
	/**
	 *	メールに添付するファイルリストをセットします
	 *	@param	attachments 添付ファイルのリスト
	 **/
	public void setMailAttachment(List<Messaging.EmailFileAttachment> attachments) {
		// メールの添付ファイルを設定
		fas = new List<Messaging.Emailfileattachment>();
		fas = attachments;
	}

	/**
	 * Salesforceのメールテンプレートを使ってメールを送ります。
	 * @param template	Salesforceメールテンプレートのレコード
	 */
	//public void sendSingleEmailMsg(sObject template) {
	public void sendSingleEmailMsg() {

		//メッセージオブジェクトの配列を作成
		List<Messaging.SingleEmailMessage> message = new List<Messaging.SingleEmailMessage>();

		String mainText = '';

		//for(sObject obj : objectList) {
			Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();

			//mail.setCharset('ISO-2022-JP');
			msg.setCharset('Windows-31J');

			//メール本文をセット
			msg.setPlainTextBody('本文');

			// メール件名をセット
			msg.setSubject('subject');

			// 送信先をセット
			msg.setToAddresses(toAddress);
			msg.setCcAddresses(ccAddress);
			msg.setBccAddresses(bccAddress);

			//メールに添付するものがあれば、メールに添付する
			if(fas != null) {
				msg.setFileAttachments(fas);
			}

			//Sender表示名と、ReplyToをセット
			//nullの場合は、Salesforceに設定したログインユーザ名の名前になる
			if(senderDisplayName != null) {
				msg.setSenderDisplayName(senderDisplayName);
			}
			if(replyTo != null) {
				msg.setReplyTo(replyTo);
				System.debug('ReplyToをセット----' + replyTo);
			} else {
				//特に指定がなければ、デフォルトのメールアドレスへ
				msg.setReplyTo(DEFAULT_REPLY_TO);
				System.debug('defultReplyTo');
			}

			message.add(msg);


		//}

		List<Messaging.SendEmailResult> result;
		try {
			//メール送信
			result = Messaging.sendEmail((Messaging.SingleEmailMessage[]) message);

			if (result[0].isSuccess()) {
				system.debug('成功');
				//writeINFOLog('メール送信成功');
				//f(isSaveActivity) {
					//活動へ記録を行う場合、活動オブジェクトにレコードを作成する
					//DataAccess dao = new DataAccess();
					//dml.insertData((List<sObject>)tasks);
					//Map<String,String> retMap = dao.insertData((List<sObject>)tasks);
				//}
			} else {
				system.debug('失敗');
				//writeINFOLog('メール送信失敗: ' + result[0].getErrors()[0].getMessage());
			}
		} catch (Exception e) {
			if(result.size() != 0){
				//writeINFOLog( 'メール送信失敗: '	+ result[0].getErrors()[0].getMessage());
				throw e;
			}
		}
	}

	/*++++++++++++++++++++++++++++++++++
	 *	private処理部
	++++++++++++++++++++++++++++++++++**/

	/**
	 * 置換処理行い、置換後文字列を返します
	 * @param sourceText	置換対象文字列
	 * @param obj			置換情報
	 * @param objectType	置換情報の型
	 * @param rerationName	リレーション項目、なければ、Null
	 * @return
	 */
	private String mergeFields(String sourceText, SObject obj, String objectType, String rerationName) {
		//writeINFOLog('------------------------- 置換処理開始 ----------------------');

		//writeINFOLog('------------> 置換対象文字列: ' + sourceText);
		Integer a = sourceText.indexOf('{!' + objectType + '.');
		//writeINFOLog('------------> 最初の {!' + objectType + '. 位置: ' + a);
		Integer b = (a > -1 && a < sourceText.length() ? a + sourceText.substring(a).indexOf('}') : a);
		//writeINFOLog('------------> 最初の } 位置: ' + b);
		String token = (b > a && a > -1 ? sourceText.substring(a, b + 1) : '');
		Integer c = token.indexOf('.');
		String field = (c > -1 ? token.substring(c + 1).replace('}', '') : '');

		while (token != '' && token != null && field != '' && field != null && a > -1 && b > -1 && b > a) {

			//writeINFOLog('------------> 置換対象:' + token + ' 置換項目:' + field);
			try {

				if (rerationName == null && obj.get(field) != null) {
					//writeINFOLog('通常置換');
					sourceText = sourceText.replace(token, (String) obj.get(field));
					//writeINFOLog('------------> 置換処理:' + token + '項目名:' + field + ' : 値:' + obj.get(field));
				} else {
					if (obj.getSObject(rerationName) != null) {
						sourceText = sourceText.replace(token, (String) obj.getSObject(rerationName).get(field));

						//writeINFOLog('------------> 関連オブジェクトによる置換処理:'
						//		+ token
						//		+ '項目名:'
						//		+ field
						//		+ ' : 値:'
						//		+ (String) obj.getSObject(rerationName).get(field));
					}else {
						sourceText = sourceText.replace(token, '');
						//writeINFOLog('------------> 置換処理:' + token + ' : 置換値なし');
					/**} else {
						//FREE文言置換
						sourceText = sourceText.replace(token, (String) field);*/
					}
				}
			} catch (Exception e) {
				sourceText = sourceText.replace(token, '');
				//writeINFOLog('------------> 置換処理: ' + token + ', 例外発生のため、空白で置換' + e.getMessage());
			}
			a = sourceText.indexOf('{!' + objectType + '.');
			b = (a > -1 && a < sourceText.length() ? a + sourceText.substring(a).indexOf('}') : a);
			token = (b > a && a > -1 ? sourceText.substring(a, b + 1) : '');
			c = token.indexOf('.');
			field = (c > -1 ? token.substring(c + 1).replace('}', '') : '');
		}

		// HTMLテンプレートのための置換処理
		sourceText = sourceText.replace('<![CDATA[', '');
		sourceText = sourceText.replace(']]>', '');

		sourceText = sourceText.replace('<br>', '<br/>');
		sourceText = sourceText.replace('<hr>', '<hr/>');

		return sourceText;
	}
}