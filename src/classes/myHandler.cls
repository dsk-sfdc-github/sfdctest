global class myHandler implements Messaging.InboundEmailHandler {

      global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {

          Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

          //件名識別
          String subject = email.subject;

			//InboundEmail
			system.debug('HAMANODEBUG_受信（InboundEmail）：'+email);

			system.debug('HAMANODEBUG_binaryAttachments：'+email.binaryAttachments);
			system.debug('HAMANODEBUG_ccAddresses：'+email.ccAddresses);
			system.debug('HAMANODEBUG_fromAddress：'+email.fromAddress);
			system.debug('HAMANODEBUG_fromName：'+email.fromName);
			system.debug('HAMANODEBUG_headers：'+email.headers);
			system.debug('HAMANODEBUG_htmlBody：'+email.htmlBody);
			system.debug('HAMANODEBUG_htmlBodyIsTruncated：'+email.htmlBodyIsTruncated);
			system.debug('HAMANODEBUG_inReplyTo：'+email.inReplyTo);
			system.debug('HAMANODEBUG_messageId：'+email.messageId);
			system.debug('HAMANODEBUG_plainTextBody：'+email.plainTextBody);
			system.debug('HAMANODEBUG_plainTextBodyIsTruncated：'+email.plainTextBodyIsTruncated);
			system.debug('HAMANODEBUG_references：'+email.references);
			system.debug('HAMANODEBUG_replyTo：'+email.replyTo);
			system.debug('HAMANODEBUG_subject：'+email.subject);
			system.debug('HAMANODEBUG_textAttachments：'+email.textAttachments);
			system.debug('HAMANODEBUG_toAddresses：'+email.toAddresses);


			//InboundEnvelope
			system.debug('HAMANODEBUG_受信（InboundEnvelope）：'+envelope);
			system.debug('HAMANODEBUG_fromAddress：'+envelope.fromAddress);
			system.debug('HAMANODEBUG_toAddress：'+envelope.toAddress);


          //本文識別
          //String planeTxt = email.plainTextBody;



          //Chatterデータ作成
          /**
			PageReference pr = Page.MailAndPDFTestPage;
			Blob b = pr.getContent();


			FeedItem post = new FeedItem();
			//post.ParentId = '0F9A00000004xf1';
			post.Body = 'ここにchetterの本文を記載';
			post.Type = 'ContentPost';
			post.ContentData = b;
			//post.ContentFileName = 'chatterAttachment' + '.pdf';
			post.CreatedById = [Select Id From User Where Id = '005A0000005D60y'].Id;

			insert post;
		*/

/**
		    User u = [ select Id from User where Id = '005A0000001v5cf' And IsActive = true LIMIT 1 ];	//濱野

		    User u2 = [ select Id from User where Id = '005A0000005D60y' And IsActive = true LIMIT 1 ];	//所有者太郎

			String communityId = null;
		    String subjectId = 'me';
		    //String contentId = '069A0000001G71t';
		    String contentId = '005A0000005D60y';

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

		    system.debug('登録結果確認：'+feedItem);
		    system.debug('登録結果確認：'+communityId);
*/

          return result;
      }
  }