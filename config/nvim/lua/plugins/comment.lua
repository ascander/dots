--[[

Comment.nvim configuration

Plugins:

  - Comment.nvim (https://github.com/numToStr/Comment.nvim)

--]]

local ok, comment = pcall(require, "Comment")
if not ok then
  return
end

local ft_ok, ft = pcall(require, "Comment.ft")
if not ft_ok then
  return
end

-- Settings.
comment.setup()

-- Support for SBT files
ft.set("sbt", { "//%s", "/*%s*/" })
