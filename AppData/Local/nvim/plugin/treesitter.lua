require('nvim-treesitter.configs').setup {
    ensure_installed = 'all',
    ignore_install = { 'phpdoc', 'php', 'tlaplus' },
    highlight = {
        enable = true,
    },
}
