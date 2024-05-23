local status_ok, persistence = pcall(require, "persistence")
if not status_ok then
  return
end

persistence.setup {
  options = vim.opt.sessionoptions:get(),
}
