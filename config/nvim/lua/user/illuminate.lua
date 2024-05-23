local ok, illuminate = pcall(require, "illuminate")
if not ok then
  return
end

illuminate.configure {
  filetypes_denylist = {
    "qf",
    "dashboard",
    "Trouble",
    "toggleterm",
    "NvimTree",
    "TelescopePrompt",
  }
}
