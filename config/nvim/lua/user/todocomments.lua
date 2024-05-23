local status_ok, tdc = pcall(require, "todo-comments")
if not status_ok then
  return
end

tdc.setup {}
