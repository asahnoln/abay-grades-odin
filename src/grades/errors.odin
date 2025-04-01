package grades

Error :: union {
	Grade_Higher_Than_Task_Error,
}

Grade_Higher_Than_Task_Error :: struct {
	got:  Grade,
	task: Task,
}
