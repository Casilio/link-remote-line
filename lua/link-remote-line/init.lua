local M = {}

function M.link()
  local origin = io.popen("git remote get-url origin"):read()
  local url = ""

  if origin == nil then
    return
  end

  if string.find(origin, "git@") then
    url = extractGitUrl(origin)
  elseif string.find(origin, "http") then
    url = extractHTTPUrl(origin)
  end

  local branch = io.popen("git branch --show-current"):read()
  local filename = vim.fn.expand('%')

  local line = vim.fn.line(".")
  local link = string.format("%s/blob/%s/%s#L%s", url, branch, filename, line)

  vim.fn.setreg("+p", link)
  print(link)
end

function extractGitUrl(origin)
  return chopGitSuffix(origin:gsub("^git@", ""):gsub(":", "/"))
end

function extractHTTPUrl(origin)
  return chopGitSuffix(origin)
end

function chopGitSuffix(url)
  return url:gsub(".git$", "")
end


return M
