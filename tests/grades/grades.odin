package grades_test

import "core:testing"
import "src:grades"

@(test)
grade_cannot_exceed_task_value :: proc(t: ^testing.T) {
	task := grades.Task {
		val = 2,
	}

	c := grades.Class{}
	c.tasks[task] = {}
	defer delete(c.tasks)

	st := grades.Student{}
	defer delete(st.tasks_totals)

	err := grades.add_grade(c, &st, task, 3)
	testing.expect(t, err == .Grade_Exceeds_Task_Value)
}

@(test)
grades_added_to_different_tasks :: proc(t: ^testing.T) {
	task1 := grades.Task {
		val = 1,
	}
	task2 := grades.Task {
		val = 2,
	}
	c := grades.Class {
		tasks = {},
	}
	c.tasks[task1] = struct {}{}
	c.tasks[task2] = struct {}{}
	defer delete(c.tasks)

	st := grades.Student{}
	defer delete(st.tasks_totals)

	err := grades.add_grade(c, &st, task1, 1)
	testing.expect(t, err == .None)

	err = grades.add_grade(c, &st, task2, 2)
	testing.expect(t, err == .None)
}

@(test)
wrong_task_returns_err :: proc(t: ^testing.T) {
	c := &grades.Class{}
	defer delete(c.tasks)
	task := grades.Task {
		name = "proper task",
	}

	st := grades.Student{}
	defer delete(st.tasks_totals)

	err := grades.add_grade(c^, &st, grades.Task{name = "does not exist"}, 1)
	testing.expect(t, err == .Wrong_Task)
}
