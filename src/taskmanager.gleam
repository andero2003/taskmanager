import gleam/erlang
import gleam/int
import gleam/io
import gleam/string
import storage
import task.{type Task, Task}

pub fn main() {
  io.println("Hello from Task Manager!")
  let tasks = storage.load_tasks("tasks.txt")
  // let tasks = task.add_task(tasks, "Do thing 1")
  // let tasks = task.add_task(tasks, "Do thing 2")
  // storage.save_tasks("tasks.txt", tasks)
  ask_input(tasks)
}

pub fn ask_new_task(tasks: List(Task)) {
  case erlang.get_line("Enter description for task: ") {
    Ok(desc) -> ask_input(task.add_task(tasks, string.trim(desc)))
    Error(err) -> {
      io.debug("Oopsie")
      Nil
    }
  }
}

pub fn delete_task(tasks: List(Task)) {
  case erlang.get_line("Enter task ID number: ") {
    Ok(str_id) -> {
      case int.parse(string.trim(str_id)) {
        Ok(id) -> {
          case task.task_exists(tasks, id) {
            True -> ask_input(task.delete_task(tasks, id))
            False -> {
              io.println("Invalid ID. ")
              mark_complete(tasks)
            }
          }
        }
        Error(err) -> io.debug(err)
      }
    }
    Error(err) -> {
      io.debug(err)
      Nil
    }
  }
}

pub fn mark_complete(tasks: List(Task)) {
  case erlang.get_line("Enter task ID number: ") {
    Ok(str_id) -> {
      case int.parse(string.trim(str_id)) {
        Ok(id) -> {
          case task.task_exists(tasks, id) {
            True -> ask_input(task.mark_complete(tasks, id))
            False -> {
              io.println("Invalid ID. ")
              mark_complete(tasks)
            }
          }
        }
        Error(err) -> io.debug(err)
      }
    }
    Error(err) -> {
      io.debug(err)
      Nil
    }
  }
}

pub fn save_and_exit(tasks: List(Task)) {
  storage.save_tasks("tasks.txt", tasks)
  Nil
}

pub fn ask_input(tasks: List(Task)) {
  io.println("-------")
  io.println("")
  io.println(task.list_tasks(tasks))
  io.println("-------")
  io.println("1. Add a new task")
  io.println("2. Mark task as complete")
  io.println("3. Delete a task")
  io.println("Any other key - Save and exit")
  case erlang.get_line("Choose option (1,2,3,4): ") {
    Ok(key) -> {
      case string.trim(key) {
        "1" -> ask_new_task(tasks)
        "2" -> mark_complete(tasks)
        "3" -> delete_task(tasks)
        _ -> save_and_exit(tasks)
      }
    }
    Error(err) -> {
      io.debug("oopsie")
      Nil
    }
  }
}
