local status_ok, gitlinker = pcall(require, "gitlinker")
if not status_ok then
  return
end

gitlinker.setup {
  mappings = nil, -- set keymaps explicitly
  callbacks = {
    ["git.soma.salesforce.com"] = require("gitlinker.hosts").get_github_type_url,
  },
}
