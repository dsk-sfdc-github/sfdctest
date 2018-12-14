public with sharing class ObjectDTO {

	public Account mainObj {get; set;}

	//List<underListDto> underDtiList {get; set;}
	public List<ObjectDTO> underDto {get; set;}

	public ObjectDTO() {

		//mainObj = new Account();
		/**mainObj = createAccount('ツリー取引先１');

		underDto = new List<ObjectDTO>();

		ObjectDTO objDto2 = new ObjectDTO();
		objDto2.createAccount('ツリー取引先２');
		objDto2.underDto = new List<ObjectDTO>();

		ObjectDTO objDto3 = new ObjectDTO();
		objDto3.createAccount('ツリー取引先３');

		objDto2.underDto.add(objDto3);


		underDto.add(objDto2);*/

		//objDto.mainObj = new Contact();
		//objDto.underDtiList = new List<ObjectDTO>();
		//objDto.underDtiList.add()

	}

	public void init() {

		//mainObj = new Account();
		mainObj = createAccount('ツリー取引先１');

		underDto = new List<ObjectDTO>();

		ObjectDTO objDto2 = new ObjectDTO();
		objDto2.mainObj = objDto2.createAccount('ツリー取引先２');
		objDto2.underDto = new List<ObjectDTO>();

		ObjectDTO objDto3 = new ObjectDTO();
		objDto3.mainObj = objDto3.createAccount('ツリー取引先３');

		objDto2.underDto.add(objDto3);


		underDto.add(objDto2);

		//objDto.mainObj = new Contact();
		//objDto.underDtiList = new List<ObjectDTO>();
		//objDto.underDtiList.add()

	}

	private Account createAccount(String accName) {
		Account acc = new Account();
		acc.Name = accName;
		return acc;
	}

	/**class underListDto {

		Sobject mainObj {get; set;}

		List<underListDto> underDtiList {get; set;}

		public underListDto() {

		}
	}*/

}