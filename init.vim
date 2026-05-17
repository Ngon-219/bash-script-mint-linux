" ==============================================================================
" 1. CÀI ĐẶT CƠ BẢN & PHÍM TẮT VS CODE (LƯU, COPY, MOVE LINE)
" ==============================================================================
set number
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
set mouse=a               
set clipboard=unnamedplus 

" --- Phím tắt Ctrl + S để lưu file ---
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>
vnoremap <C-s> <Esc>:w<CR>gv

" --- Di chuyển dòng (Alt + j/k giống Alt + Up/Down) ---
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" --- Giữ vùng chọn khi Tab ---
vnoremap < <gv
vnoremap > >gv

" ==============================================================================
" 2. QUẢN LÝ PLUGIN (VIM-PLUG)
" ==============================================================================
call plug#begin('~/.local/share/nvim/plugged')

" --- Giao diện & Tiện ích ---
Plug 'preservim/nerdtree'
Plug 'kdheepak/lazygit.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.5' }
Plug 'nvim-lua/plenary.nvim'

" --- Nhóm LSP & Auto-complete (Bản v0.1.8 ổn định nhất cho Nvim hiện tại) ---
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip'

call plug#end()

" ==============================================================================
" 3. CẤU HÌNH PHÍM TẮT PLUGIN (NERDTREE, LAZYGIT, TELESCOPE)
" ==============================================================================
" Ctrl + B: Ẩn/hiện cây thư mục
nnoremap <C-b> :NERDTreeToggle<CR>

" Ctrl + G: Mở Lazygit (Sửa lại lệnh gọi chuẩn)
nnoremap <C-g> :LazyGit<CR>

" Ctrl + P: Tìm file nhanh
nnoremap <C-p> :Telescope find_files<CR>

" Ctrl + F: Tìm kiếm text trong file
nnoremap <C-f> :Telescope current_buffer_fuzzy_find<CR>

" ==============================================================================
" 4. CẤU HÌNH LUA (LSP, MASON, CMP)
" ==============================================================================
lua << EOF
-- 1. Setup Mason
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "ts_ls" }
})

-- 2. Setup LSP Config
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
lspconfig.ts_ls.setup { 
    capabilities = capabilities,
    -- Thêm dòng này để hỗ trợ cả file .mts và .cts của bác
    filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact", "javascript.jsx" }
}

-- Sửa lỗi: Phải dùng -- để comment trong Lua, và gọi setup mới chạy được
--lspconfig.ts_ls.setup { capabilities = capabilities }
-- lspconfig.rust_analyzer.setup { capabilities = capabilities }

-- 3. Setup Auto-complete (CMP)
local cmp = require('cmp')
cmp.setup({
    snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    }),
    sources = { { name = 'nvim_lsp' } }
})

-- 4. Keymaps cho LSP
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
EOF

" ==============================================================================
" FIX LỖI MẤT BACKGROUND TERMINAL (TRANSPARENT BG)
" ==============================================================================
highlight Normal guibg=none
highlight NonText guibg=none
highlight Normal ctermbg=none
highlight NonText ctermbg=none
