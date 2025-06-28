local M = {}

vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")

local state = {
  float = {
    win = -1,
    buf = -1,
  }
}

function M.open_double_terminal(opts)
  opts = opts or {}

  local width = opts.width or math.floor(vim.o.columns * 0.65)
  local height = opts.height or math.floor(vim.o.lines * 0.65)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  local window_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded"
  }

  local win = vim.api.nvim_open_win(buf, true, window_config)

  return { buf = buf, win = win }
end

local toggle = function()
  if not vim.api.nvim_win_is_valid(state.float.win) then
    state.float = open_double_terminal { buf = state.float.buf }
    if vim.bo[state.float.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
    vim.cmd("startinsert")
  else
    vim.api.nvim_win_hide(state.float.win)
  end
end

vim.cmd.nvim_create_user_command("Dt", toggle, {})
vim.keymap.set({ "n", "t" }, "<space>t", toggle)

return M
