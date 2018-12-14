trigger ShareTestTgr on usermng__c (after Insert, after Update) {

    List<ID> recordIdList = new List<ID>();
    List<ID> ownerIdList = new List<ID>();
    
    for(usermng__c item : Trigger.new){
        recordIdList.add(item.Id);
        ownerIdList.add(item.OwnerId);
    }
    
    // 共有レコード追加リストの作成の
    // 共有先ユーザ／グループの設定のところで、
    // 所有者IDに対応するグループIDを取得したいので、
    // 「所有者ID-ロールID マップ」と
    // 「ロールID-グループID マップ」を作成する
    //
    // 所有者ID-ロールID マップの作成
    Map<Id, Id> ownerIdMap = new Map<Id, Id>();
    for(User u : [Select Id, UserRoleId From User Where Id = :ownerIdList]) {
        ownerIdMap.put(u.Id, u.UserRoleId);
    }
    
    // ロールID-グループID マップの作成
    Map<Id, Id> roleIdMap = new Map<Id, Id>();
    for(Group grp : [Select Id, RelatedId From Group Where RelatedId = :ownerIdMap.values() and Type = 'Role']) {
        roleIdMap.put(grp.RelatedId, grp.Id);
    }

    // 共有レコード追加リストの作成
    // （共有オブジェクトに追加するレコードを作成する）
    List<usermng__Share> addShareList = new List<usermng__Share>();
    for(usermng__c item : Trigger.new) {
        usermng__Share shareObj = new usermng__Share();

        // 共有レコードID
        shareObj.ParentId = item.Id;

        // 共有先ユーザ／グループ
        // （所有者のロールに対応するグループIDを設定）
        shareObj.UserOrGroupId = roleIdMap.get(ownerIdMap.get(item.OwnerId)); 

        // アクセス権限
        // 参照のみ : read
        // 参照・更新 : edit
        shareObj.AccessLevel = 'read';
    
        // 共有の理由
        shareObj.RowCause = Schema.usermng__Share.RowCause.ShareReason1__c;

        addShareList.add(shareObj);
    }

    // 共有レコード削除リストの作成
    List<usermng__Share> delShareList =[Select Id From usermng__Share Where ParentId = :recordIdList and RowCause = :Schema.usermng__Share.RowCause.ShareReason1__c];

    try {
        // 共有の理由が「所有者のロールへの共有」である
        // 共有レコードを削除してから、追加する
        delete delShareList;
        insert addShareList;
    } catch (System.DmlException e) {  
    }
}