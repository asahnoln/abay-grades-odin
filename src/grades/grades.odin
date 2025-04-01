package grades

MAXIMUM_CLASS_TOTAL :: 10

Class :: struct {
	total: int,
	tasks: map[Task]struct {},
}

Task :: struct {
	name: string,
	val:  int,
}

Student :: struct {
	name:         string,
	total:        int,
	tasks_totals: map[Task]int,
}

Error :: enum {
	None,
	Grade_Exceeds_Task_Value,
	Task_Value_Exceeds_Class_Maximum,
	Wrong_Task,
}

add_task :: proc(c: ^Class, t: Task) -> Error {
	if c.total + t.val > MAXIMUM_CLASS_TOTAL {
		return .Task_Value_Exceeds_Class_Maximum
	}

	c.tasks[t] = struct {}{}
	c.total += t.val

	return .None
}

add_student :: proc(_: ^Class, s: Student) {}

// If Student doesn't have initialized map in tasks_totals, add_grade automatically allocates one. Make sure to delete it after use
add_grade :: proc(c: Class, s: ^Student, t: Task, val: int) -> Error {
	if _, ok := c.tasks[t]; !ok {
		return .Wrong_Task
	}

	if s.tasks_totals == nil {
		s.tasks_totals = make(map[Task]int)
	}

	if s.tasks_totals[t] + val > t.val {
		return .Grade_Exceeds_Task_Value
	}

	s.total += val
	s.tasks_totals[t] += val

	return .None
}
