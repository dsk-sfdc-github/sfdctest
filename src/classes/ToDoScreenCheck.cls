public without sharing class ToDoScreenCheck {

	public List<Task> taskList {get; set;}

	public List<Event> eventList {get; set;}

	public ToDoScreenCheck() {
		taskList = new List<Task>();
		eventList = new List<Event>();

		taskList = [Select Id, Subject From Task];
		eventList = [Select Id, Subject From Event];
	}
}