package grades_test

import "core:testing"
import "src:grades"

@(test)
class :: proc(t: ^testing.T) {
	c := &grades.Class{}
	defer delete(c.tasks)

	task := grades.Task{"HW", 2}
	st := grades.Student {
		name = "Arthur",
	}
	defer delete(st.tasks_totals)

	err := grades.add_task(c, task)
	if !testing.expect_value(t, err, nil) {
		return
	}

	grades.add_student(c, st)

	err = grades.add_grade(c^, &st, task, 1)
	if !testing.expect_value(t, err, nil) {
		return
	}

	err = grades.add_grade(c^, &st, task, 1)
	if !testing.expect_value(t, err, nil) {
		return
	}

	testing.expect_value(t, st.total, 2)
}

@(test)
task_vals_cannot_exceed_maximum :: proc(t: ^testing.T) {
	c := &grades.Class{}
	defer delete(c.tasks)

	grades.add_task(c, grades.Task{val = 9})

	err := grades.add_task(c, grades.Task{val = 2})
	testing.expect(t, err == .Task_Value_Exceeds_Class_Maximum)
}
