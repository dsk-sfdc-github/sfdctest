global class queryLocator implements Database.Batchable<sObject>{

    /*global Database.QueryLocator start(Database.BatchableContext BC) {
    	system.debug(database.getQuerylocator([Select Id, Name From Account]));
		return database.getQuerylocator([Select Id, Name From Account]);
	}

	global void execute(Database.BatchableContext BC, List<sObject> scope) {

	}

	global void finish(Database.BatchableContext BC) {

	}*/
    global Database.QueryLocator start(Database.BatchableContext info){
        //CalloutScheduledExecute.execute();
        //Database.QueryLocator aaa = Database.getQueryLocator('select Id, Name, (Select Id From Contacts) c From Account');

        //system.debug('hayashi:' + aaa);

        /*for(Account rec:(Account)aaa){
        	system.debug('hayashi:' + rec);
        }*/

        //system.debug('hayashi' + Database.getQueryLocator('select Id, Name, (Select Id From Contacts) c From Account'));
        return Database.getQueryLocator('select Id, Name, (Select Id From Contacts) From Account');
    }

    global void execute(Database.BatchableContext info, SObject[] scope){

    	for (Sobject so : scope)  {
          Account ar = (Account) so;

          system.debug('hamano:' + ar.Contacts.size());

          //Integer counter = Integer.valueOf(ar.get('expr0'));
          // process the results
        }
    }

    global void finish(Database.BatchableContext info){
        //system.scheduleBatch(new CalloutScheduledBatch(), 'Callout Scheduled Batch', 5);
    }
}