public class pdftestdesu {

    public String pdfParam {get; set;}

    public Account accRec {get; set;}

    public pdftestdesu() {

        //if (ApexPages.currentPage().getParameters().containsKey('render')) {
            //pdfParam = ApexPages.currentPage().getParameters().get('render');
        //}
		pdfParam = '';

		accRec = [Select Id, QR__c From Account where Id = '001A0000018OIHd' limit 1];
    }

    public pageReference send() {

    	pdfParam = 'pdf';

        //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //mail.setToAddresses(new List<String> { 'toshi_hamano@densan-s.co.jp' });
        //mail.setSubject('件名');
        //mail.setPlainTextBody('本文');


        //PageReference pr = ApexPages.currentPage();

        //pr.getParameters().put('render', 'pdf');
        //pr.setRedirect(false);

        //Blob b = pr.getContent();
        //Blob b = pr.getContentAsPDF();

        //Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        //efa.setFileName('attachment.pdf');
        //efa.setBody(b);
        //mail.setFileAttachments(new List<Messaging.EmailFileAttachment> { efa });

        //Messaging.sendEmail(new List<Messaging.Email> { mail });

        //添付ファイル登録
        Attachment dc = new Attachment();

        //dc.Body     = Blob.valueOf('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAACZElEQVR4nO2Vy24DMQwD8/8/3d5ToAYxlO1kh4BPelGaBfb1er1+Nr93TcdXSvuP30cgAkEHSeMrCQQeJI2vdD2QttL+beBU2/vftpBAdg8M8wUyPTDMF8iiID3IdP+0X6rt9xFI1q/tXyChBBL2T/ulEgjsT/2c9i+QhQQC+wskHTjcXyDpwDBO/XzaByWQsn+BlB/1L5Dyo/7HgVDR/umC6fz2B5NKIOU4lUDKcSqBlONUSyDTb2no8vj4fQQikNGDTccFcll8932uEz3oKv/jDnJaArlMArlMjwMy/RPa/VM9vR/1J5DyfgIp1wskjH89kDihnN8G1vZH++F6gQhEIM0CgWRa1u8GkOanL51P+1FAseHT+QK5LF8gl+U/Dkhb1CBdmAKkfq4DJhCBRPUCgfWPAzJ9wNMHmD5o259AyvOpP4GU51N/AinPp/7iATSf6nbgdJ88AeZTCYQ2LEsgtGFZjwcyPZAeiGr6A8T3FMhsvkCgv3a+QKC/dv6ynh6gbTB9VPSDoP7+5AtEIAL5p59Awv7jQE4v0DbYPujuhxcWiEAif6mf0w8vLJDDQNpqA5rOv62+LoEIBOXfVl+XQN7qv+2n1QaSxvF9BCKQUQkkHTisrwPS1vSBaH+6f/1+AhEIyhfI5v4CWTRcLZDWUz+p2vuNAxWIQDKDUAJZDUwNQglkNRD2b38AqZ/p/QQS+pneTyChn+n9BBL6md7vOiArTc+jHwi9l0AWcYEsJBA4QCBlIFS3H/C0f14QSiACEQjpL5DyQvQA9INoA2jPi/0JZHaeQML50/MEEs6fnhe9X6uGDQ04D9xHAAAAAElFTkSuQmCC');
        blob fileContent = EncodingUtil.base64Decode('iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAACZElEQVR4nO2Vy24DMQwD8/8/3d5ToAYxlO1kh4BPelGaBfb1er1+Nr93TcdXSvuP30cgAkEHSeMrCQQeJI2vdD2QttL+beBU2/vftpBAdg8M8wUyPTDMF8iiID3IdP+0X6rt9xFI1q/tXyChBBL2T/ulEgjsT/2c9i+QhQQC+wskHTjcXyDpwDBO/XzaByWQsn+BlB/1L5Dyo/7HgVDR/umC6fz2B5NKIOU4lUDKcSqBlONUSyDTb2no8vj4fQQikNGDTccFcll8932uEz3oKv/jDnJaArlMArlMjwMy/RPa/VM9vR/1J5DyfgIp1wskjH89kDihnN8G1vZH++F6gQhEIM0CgWRa1u8GkOanL51P+1FAseHT+QK5LF8gl+U/Dkhb1CBdmAKkfq4DJhCBRPUCgfWPAzJ9wNMHmD5o259AyvOpP4GU51N/AinPp/7iATSf6nbgdJ88AeZTCYQ2LEsgtGFZjwcyPZAeiGr6A8T3FMhsvkCgv3a+QKC/dv6ynh6gbTB9VPSDoP7+5AtEIAL5p59Awv7jQE4v0DbYPujuhxcWiEAif6mf0w8vLJDDQNpqA5rOv62+LoEIBOXfVl+XQN7qv+2n1QaSxvF9BCKQUQkkHTisrwPS1vSBaH+6f/1+AhEIyhfI5v4CWTRcLZDWUz+p2vuNAxWIQDKDUAJZDUwNQglkNRD2b38AqZ/p/QQS+pneTyChn+n9BBL6md7vOiArTc+jHwi9l0AWcYEsJBA4QCBlIFS3H/C0f14QSiACEQjpL5DyQvQA9INoA2jPi/0JZHaeQML50/MEEs6fnhe9X6uGDQ04D9xHAAAAAElFTkSuQmCC');
        dc.Body = fileContent;
        dc.Name     = '' + DateTime.now().format('yyyy-MM-dd') + '.png';
        dc.ParentId = accRec.Id;

        upsert dc;

        return null;
    }
}