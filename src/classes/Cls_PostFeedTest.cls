public with sharing class Cls_PostFeedTest {

@Future(callout=true)
    public static void doPostFeed() {

// 公式ドキュメントサンプル
// postFeedElementBatch(communityId, feedElements)
// 1 つの DML ステートメントで最大 500 個のフィード要素を一括で投稿します。

    // メソッドに同時に渡される一連の入力を作成します。
    List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();

    List<String> fixList = new List<String>();
//    fixList.add('puser.risa_fukumoto@densan-s.co.jp');  // パートナー１：パートナー  （エイリアスメール）
//    fixList.add('risa_fukumoto@densan-s.co.jp.portal');  // ポータル ユーザ：カスタマーポータル  （普通のメール）
//    fixList.add('puser.risa_fukumoto@densan-s.co.jp');  // パートナー１：パートナー  （エイリアスメール）
//    fixList.add('risa_fukumoto@densan-s.co.jp.portal');  // ポータル ユーザ：カスタマーポータル  （普通のメール）
//    fixList.add('risa_fukumoto@densan-s.co.jp');        // 福本里沙：システム管理者（普通のメール）/実行者
//    fixList.add('risa_fukumoto@densan-s.co.jp.test7');  // テストユーザ７：システム管理者（エイリアスメール）

    // subjectIdレコードへの参照権限無いユーザだと@がグレー色（投稿あるが通知なし）になる
    // 上記条件だと、実行者以外には送信された（全5件）

    String userName = 'toshitoshiuser1@densan-s.co.jp';
       for (Integer i = 0; i < 500; i++) {
           fixList.add(userName);
       }
//    for (User u : [SELECT Id, UserName, Name
//                                FROM User WHERE UserName IN :fixList AND IsActive = true
//                                ORDER BY UserName ASC]) {
    for (String uname: fixList) {
        ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
        ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();

        input.subjectId = '001A000001SABxr';

        ConnectApi.MessageBodyInput body = new ConnectApi.MessageBodyInput();
        body.messageSegments = new List<ConnectApi.MessageSegmentInput>();

        //mentionSegmentInput.username = u.UserName;
        mentionSegmentInput.username = uname;

        body.messageSegments.add(mentionSegmentInput);

        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = '\r\npostFeedElementBatch()投稿\r\nです。';

        body.messageSegments.add(textSegment);
        input.body = body;
        input.visibility = ConnectApi.FeedItemVisibilityType.AllUsers;// アクセス権があるすべてのユーザに投稿しないとコミュニティユーザが見れない

        ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(input);
        batchInputs.add(batchInput);
    }

    ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchInputs);

    }
}