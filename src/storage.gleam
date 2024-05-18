import gleam/dynamic.{type DecodeError, type Dynamic}
import gleam/io
import gleam/json.{type Json, array, bool, int, object, string}
import gleam/list
import gleam/result
import simplifile.{type FileError}

import task.{type Task, Task}

pub fn serialize_tasks(tasks: List(Task)) -> Json {
  array(tasks, of: fn(task) {
    case task {
      Task(id, desc, completed) ->
        object([
          #("id", int(id)),
          #("desc", string(desc)),
          #("completed", bool(completed)),
        ])
    }
  })
}

pub fn deserialize_tasks(
  json_string: String,
) -> Result(List(Task), json.DecodeError) {
  json.decode(
    from: json_string,
    using: dynamic.list(of: dynamic.decode3(
      Task,
      dynamic.field("id", of: dynamic.int),
      dynamic.field("desc", of: dynamic.string),
      dynamic.field("completed", of: dynamic.bool),
    )),
  )
}

pub fn save_tasks(
  file_path: String,
  tasks: List(Task),
) -> Result(Nil, FileError) {
  tasks
  |> serialize_tasks()
  |> json.to_string()
  |> simplifile.write(to: file_path)
}

pub fn load_tasks(file_path: String) {
  case simplifile.read(from: file_path) {
    Ok(data) ->
      case deserialize_tasks(data) {
        Ok(decoded) -> decoded
        Error(status) -> {
          io.debug(status)
          []
        }
      }
    Error(status) -> {
      io.debug(status)
      []
    }
  }
}
