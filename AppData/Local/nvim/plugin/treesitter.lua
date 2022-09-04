require('nvim-treesitter.configs').setup {
    ensure_installed = 'all',
    ignore_install = { 'phpdoc', 'php', 'tlaplus', 'llvm', 'commonlisp' },
    highlight = {
        enable = true,
    },
}
