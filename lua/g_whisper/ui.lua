--- KEEP COMMENT::keymap to exit out of mode?::not sure if I actually need that here or yet
--- DONE create state
--- DONE create window open function
--- DONE initiate opts to exist or be nil (empty table)
--- DONE width, height, rows, columns
--- DONE create scratch buffer
--- DONE ui config
--- DONE open window
--- DONE return buf, win
--- DONE toggle window open and closed
--- DONE create command
--- keymap shortcut for open/close

local M = {}

local state = {
  ui = {
    win = -1,
    buf = -1
  }
}

function M.open_ui_window(opts)
  opts = opts or {}

  local width = opts.width or math.floor(vim.o.columns * 0.7) --- keeping it at 70% for now
  local height = opts.height or math.floor(vim.o.lines * 0.7) --- keeping it at 70% for now
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  local ui_config = {
    relative = "editor",
    height = height,
    width = width,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded"
  }

  local win = vim.api.nvim_open_win(buf, true, ui_config)

  return { buf = buf, win = win }
end

local toggle = function()
  if not vim.api.nvim_win_is_valid(state.ui.win) then
    state.ui = M.open_ui_window({ buf = state.ui.buf })
  else
    vim.api.nvim_win_hide(state.ui.win)
  end
end

vim.api.nvim_create_user_command("Gr", function()
  require("g_whisper").toggle()
end, {})

vim.keymap.set("n", "<space>gr", toggle)

return M
