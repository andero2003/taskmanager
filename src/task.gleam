import gleam/int
import gleam/list

pub type Task {
  Task(id: Int, desc: String, completed: Bool)
}

pub fn get_max_id(tasks: List(Task)) -> Int {
  tasks
  |> list.map(fn(task) {
    case task {
      Task(id, _, _) -> id
    }
  })
  |> list.fold(0, int.max)
}

pub fn add_task(tasks: List(Task), description: String) -> List(Task) {
  list.append(tasks, [Task(get_max_id(tasks) + 1, description, False)])
}

pub fn get_check_emoji(value: Bool) -> String {
  case value {
    True -> "✅"
    False -> "❌"
  }
}

pub fn list_tasks(tasks: List(Task)) -> String {
  tasks
  |> list.fold("", fn(result_string, task) {
    case task {
      Task(id, desc, completed) ->
        result_string
        <> get_check_emoji(completed)
        <> " TASK "
        <> int.to_string(id)
        <> ": "
        <> desc
        <> "\n"
    }
  })
}

pub fn task_exists(tasks: List(Task), task_id: Int) -> Bool {
  case
    tasks
    |> list.find(fn(task) {
      case task {
        Task(id, _, _) -> id == task_id
      }
    })
  {
    Ok(_) -> True
    Error(_) -> False
  }
}

pub fn mark_complete(tasks: List(Task), task_id: Int) -> List(Task) {
  tasks
  |> list.map(fn(task) {
    case task {
      Task(id, desc, _) if id == task_id -> Task(id, desc, True)
      _ -> task
    }
  })
}

pub fn delete_task(tasks: List(Task), task_id: Int) -> List(Task) {
  tasks
  |> list.filter(fn(task) {
    case task {
      Task(id, _, _) -> id != task_id
    }
  })
}
