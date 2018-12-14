public class ChatterMentionTest {

    public ChatterMentionTest() {
    }
    
    public pagereference chatterAction() {
    
    
    User u = [ select Id from User where Id = '005A0000001v5cf' And  IsActive = true LIMIT 1 ];
    User u2 = [ select Id from User where Id = '005A0000005DIpK' And  IsActive = true LIMIT 1 ];
    
    String communityId = null;
    ConnectApi.FeedType feedType = ConnectApi.FeedType.UserProfile;
    
    ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
    ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
    ConnectApi.TextSegmentInput textSegment;
    ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
    ConnectApi.MentionSegmentInput mentionSegment2 = new ConnectApi.MentionSegmentInput();
    
    messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
    
    textSegment = new ConnectApi.TextSegmentInput();
    textSegment.text = 'Hey there ';
    messageInput.messageSegments.add(textSegment);
    
    mentionSegment.Id = u.Id;
    messageInput.messageSegments.add(mentionSegment);
    mentionSegment2.Id = u2.Id;
    messageInput.messageSegments.add(mentionSegment2);
    
    textSegment = new ConnectApi.TextSegmentInput();
    textSegment.text = '. How are you?';
    messageInput.messageSegments.add(textSegment);
    
    input.body = messageInput;
    
    ConnectApi.FeedItem feedItemRep = ConnectApi.ChatterFeeds.postFeedItem(communityId, feedType, 'me', input, null);
    
    return null;
    
    }
}