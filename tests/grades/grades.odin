package grades_test

import "core:testing"
import "src:grades"

@(test)
grade_cannot_exceed_task_value :: proc(t: ^testing.T) {
	task := grades.Task {
		val = 2,
	}
	st := grades.Student {
		total = 5,
	}
	defer delete(st.tasks_totals)

	err := grades.add_grade(&st, task, 1)
	testing.expect(t, err == .None)

	err = grades.add_grade(&st, task, 2)
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
	st := grades.Student{}
	defer delete(st.tasks_totals)

	err := grades.add_grade(&st, task1, 1)
	testing.expect(t, err == .None)

	err = grades.add_grade(&st, task2, 2)
	testing.expect(t, err == .None)
}

@(test)
wrong_task_returns_err :: proc(t: ^testing.T) {
	c := &grades.Class{}
	task := grades.Task{}

	grades.add_task(c, task)

	st := grades.Student{}
	defer delete(st.tasks_totals)

	err := grades.add_grade(&st, grades.Task{}, 1)
	testing.expect_value(t, err, .Wrong_Task)
}
