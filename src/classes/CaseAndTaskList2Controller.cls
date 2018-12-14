public with sharing class CaseAndTaskList2Controller {

	public List<ObjectDTO> objList {get; set;}

	public CaseAndTaskList2Controller() {

		objList = new List<ObjectDTO>();

		ObjectDTO objDto = new ObjectDTO();
		objDto.init();

		objList.add(objDto);

		system.debug('リストデバッグ'+objList);
	}
}