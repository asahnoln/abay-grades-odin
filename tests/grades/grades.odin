package grades_test

import "core:testing"
import "src:grades"

@(test)
set_grade :: proc(t: ^testing.T) {
	s := grades.Student {
		total = 1,
	}
	tsk := grades.Task {
		val = 2,
	}
	defer delete(s.tasks)

	grades.set_grade(&s, tsk, 2)
	testing.expect_value(t, s.tasks[tsk], 2)
	testing.expect_value(t, s.total, 3)
}

@(test)
reduce_grade_for_task_reduces_total :: proc(t: ^testing.T) {
	tsk := grades.Task {
		val = 3,
	}
	s := grades.Student {
		total = 4,
	}
	defer delete(s.tasks)

	s.tasks[tsk] = 3

	grades.set_grade(&s, tsk, 2)
	testing.expect_value(t, s.total, 3)
}

@(test)
error_when_grade_is_greater_than_task :: proc(t: ^testing.T) {
	s: grades.Student
	defer delete(s.tasks)

	tsk := grades.Task {
		val = 5,
	}

	err := grades.set_grade(&s, tsk, 6)
	testing.expect_value(t, err, grades.Grade_Higher_Than_Task_Error{got = 6, task = tsk})
}

@(test)
remove_task_from_student :: proc(t: ^testing.T) {
	tsk := grades.Task{}
	s := grades.Student {
		total = 5,
	}
	defer delete(s.tasks)

	s.tasks[tsk] = 4

	ok := grades.remove_task(&s, tsk)
	testing.expect(t, ok)
	testing.expect(t, !(tsk in s.tasks))
	testing.expect_value(t, s.total, 1)
}

@(test)
remove_task_that_doesnt_exist :: proc(t: ^testing.T) {
	s := grades.Student {
		total = 9,
	}

	ok := grades.remove_task(&s, grades.Task{})
	testing.expect(t, !ok)
	testing.expect_value(t, s.total, 9)
}
