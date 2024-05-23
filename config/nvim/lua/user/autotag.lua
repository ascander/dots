local status_ok, autotag = pcall(require, "nvim-ts-autotag")
if not status_ok then
  return
end

autotag.setup {
  enable = true,
  enable_rename = true,
  enable_close = false,
  enable_close_on_slash = false,
}
