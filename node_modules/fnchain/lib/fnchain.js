var FnChain = module.exports = function FnChain(tasks, callback) {
  this.tasks = tasks
  this.tasksIndex = 0
  this.callback = callback
}

FnChain.prototype.addTask = function (task) {
  this.tasks.push(task)
}

FnChain.prototype.onTaskComplete = function (err, stop) {
  this.tasksIndex++
  if (err || stop || this.tasks.length === this.tasksIndex) {
    this.args.pop()
    this.args.unshift(err)
    this.callback && this.callback.apply(null, this.args)
    return
  }
  this.callNextFunction()
}

FnChain.prototype.callNextFunction = function () {
  this.tasks[this.tasksIndex].apply(null, this.args)
}

FnChain.prototype.call = function () {
  this.args = Array.prototype.slice.apply(arguments)
  this.args.push(this.onTaskComplete.bind(this))
  this.callNextFunction()
  return this;
}