public class MailAndPDFTestController {

	public String renderVal {get; set;}

	public MailAndPDFTestController() {
		/**renderVal = 'pdf';

		if (Apexpages.currentPage().getParameters().containsKey('prmRenderVal')) {
			renderVal = Apexpages.currentPage().getParameters().get('prmRenderVal');
		}
		*/

		//sendMail();
	}

	public pageReference sendMailTest() {

		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setToAddresses(new List<String> { 'toshi_hamano@densan-s.co.jp' });
		//mail.setToAddresses(new List<String> { 'tony_050223090121_ff_lightninig@docomo.ne.jp' });
		mail.setSubject('件名');
		//mail.setPlainTextBody('<a href="mailto:info@example.com?subject=問い合わせ&amp;body=ご記入ください">メールはこちらへ</a>');
		mail.setHtmlBody('<a href="mailto:info@example.com?subject=問い合わせ&amp;body=ご記入ください。%0d%0a改行">メールはこちらへ</a>');

		Messaging.sendEmail(new List<Messaging.Email> { mail });

		return null;
	}

	public pageReference sendMail() {
	//public void sendMail() {

		//VFページをPDF化

		//メール送信（メール送信の場合）
		/**
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setToAddresses(new List<String> { 'toshi_hamano@densan-s.co.jp' });
		mail.setSubject('件名');
		mail.setPlainTextBody('本文');
		*/

		//PDFをメール添付
		PageReference pr = Page.MailAndPDFTestPage;

		//pr.getParameters().put('prmRenderVal', 'pdf');
		//pr.setRedirect(true);

		Blob b = pr.getContent();

		//（メール送信の場合）
		/**
		Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
		efa.setFileName('attachment.pdf');
		efa.setBody(b);
		mail.setFileAttachments(new List<Messaging.EmailFileAttachment> { efa });

		Messaging.sendEmail(new List<Messaging.Email> { mail });
		*/

		//Chatter送信（@メンションなし）
		/**
		FeedItem post = new FeedItem();
    	post.ParentId = '0F9A00000004xf1';
    	post.Body = 'ここにchetterの本文を記載';
    	post.Type = 'ContentPost';
    	post.ContentData = b;
    	post.ContentFileName = 'chatterAttachment' + '.pdf';

		insert post;
		*/

		//Chatter送信（@メンションあり）
		String communityId = null;
		String subjectId = 'me';
		String contentId = '069A0000001G71t';

		User u = [ select Id from User where Id = '005A0000001v5cf' And IsActive = true LIMIT 1 ];


		ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
		ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
		ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
		ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();

		textSegment.text = 'Chatter本文';
		messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
		messageInput.messageSegments.add(textSegment);

		mentionSegment.Id = u.Id;
		messageInput.messageSegments.add(mentionSegment);

		feedItemInput.body = messageInput;

		//ファイルオブジェクト添付
		//ConnectApi.ContentAttachmentInput attachmentInput = new ConnectApi.ContentAttachmentInput();
		//attachmentInput.contentDocumentId = contentId;
		//feedItemInput.attachment = attachmentInput;

		//新規ファイル添付
		// POST FILE_FEED_ITEM
		ConnectApi.NewFileAttachmentInput v_fileIn = new ConnectApi.NewFileAttachmentInput();
		v_fileIn.title = 'chatterAttachment';
		v_fileIn.description = '備考';

		feedItemInput.attachment = v_fileIn;

		ConnectApi.BinaryInput v_feedBinary = new ConnectApi.BinaryInput(b, 'application/pdf', 'chatterAttachment.pdf');


		//送信
		//ConnectApi.FeedItem feedItem = ConnectApi.ChatterFeeds.postFeedItem(communityId, ConnectApi.FeedType.UserProfile, subjectId, feedItemInput, null);
		ConnectApi.FeedItem feedItem = ConnectApi.ChatterFeeds.postFeedItem(communityId, ConnectApi.FeedType.UserProfile, subjectId, feedItemInput, v_feedBinary);


		return null;
	}
}