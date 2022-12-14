local servers = { 'yamlls', 'vimls', 'clangd', 'bashls', 'jsonls', 'pyright', 'zls' }
for _, server in ipairs(servers) do
    require('lspconfig')[server].setup({
        on_attach = require('lsp').on_attach,
    })
end
