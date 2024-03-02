local function read_file(path)
  local file = io.open(path, 'rb')
  if not file then
    return nil
  end
  local content = file:read '*a' -- *a or *all reads the whole file
  file:close()
  return content
end

vim.api.nvim_create_user_command('RunJobs', function()
  local path = 'job.json'
  local fileContent = read_file(path)
  if not fileContent then
    vim.notify(path .. ' file not found', vim.log.levels.ERROR)
    return nil
  end
  local t = vim.json.decode(fileContent)

  local names = {}
  local jobs = {}
  for k, v in pairs(t) do
    if not k == 'jobs' then
      vim.notify('jobs object not found', vim.log.levels.ERROR)
      return nil
    end
    for _, val in pairs(v) do
      if not val.name or not val.cmd then
        vim.notify('name or cmd not found', vim.log.levels.ERROR)
        return nil
      end
      if not val.pane then
        val.pane = 2
      end
      table.insert(names, val.name)
      table.insert(jobs, { cmd = val.cmd, pane = val.pane })
    end
  end

  vim.ui.select(names, { prompt = 'Jobs' }, function(_, i)
    if not i then
      return nil
    end
    io.popen('tmux send -t ' .. jobs[i].pane .. " '" .. jobs[i].cmd .. "' Enter")
  end)
end, {})
