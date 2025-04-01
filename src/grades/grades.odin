package grades

// Grade type for convenience.
Grade :: int

// Use struct fields for read only.
// Do not change fields directly, otherwise you will get undefined behaviour. Set them with provided procedures.
Student :: struct {
	tasks: map[Task]Grade,
	total: Grade,
}

Task :: struct {
	val: Grade,
}

// Updates student tasks and total. Error returned if grade is greater than task value.
set_grade :: proc(s: ^Student, t: Task, g: Grade) -> Error {
	if g > t.val {
		return Grade_Higher_Than_Task_Error{got = g, task = t}
	}

	if t in s.tasks {
		s.total -= s.tasks[t]
	}

	s.tasks[t] = g
	s.total += g

	return nil
}

// Removes task from student tasks and reduced total.
remove_task :: proc(s: ^Student, t: Task) -> bool {
	g, ok := s.tasks[t]
	if ok {
		s.total -= g
		delete_key(&s.tasks, t)
	}

	return ok
}
