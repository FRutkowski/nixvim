# {
#   plugins = {
#     cmp-emoji = {
#       enable = true;
#     };
#     cmp = {
#       enable = true;
#       settings = {
#         autoEnableSources = true;
#         experimental = {
#           ghost_text = false;
#         };
#         performance = {
#           debounce = 60;
#           fetchingTimeout = 200;
#           maxViewEntries = 30;
#         };
#         snippet = {
#           expand = "luasnip";
#         };
#         formatting = {
#           fields = [
#             "kind"
#             "abbr"
#             "menu"
#           ];
#         };
#         sources = [
#           { name = "git"; }
#           { name = "nvim_lsp"; }
#           { name = "emoji"; }
#           {
#             name = "buffer"; # text within current buffer
#             option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
#             keywordLength = 3;
#           }
#           { name = "copilot"; }
#           {
#             name = "path"; # file system paths
#             keywordLength = 3;
#           }
#           {
#             name = "luasnip"; # snippets
#             keywordLength = 3;
#           }
#         ];
#
#         window = {
#           completion = {
#             border = "solid";
#           };
#           documentation = {
#             border = "solid";
#           };
#         };
#
#         mapping = {
#           "<C-Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
#           "<C-j>" = "cmp.mapping.select_next_item()";
#           "<C-k>" = "cmp.mapping.select_prev_item()";
#           "<C-e>" = "cmp.mapping.abort()";
#           "<C-b>" = "cmp.mapping.scroll_docs(-4)";
#           "<C-f>" = "cmp.mapping.scroll_docs(4)";
#           "<C-Space>" = "cmp.mapping.complete()";
#           "<C-CR>" = "cmp.mapping.confirm({ select = true })";
#           "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
#         };
#       };
#     };
#     cmp-nvim-lsp = {
#       enable = true;
#     }; # lsp
#     cmp-buffer = {
#       enable = true;
#     };
#     cmp-path = {
#       enable = true;
#     }; # file system paths
#     cmp_luasnip = {
#       enable = true;
#     }; # snippets
#     cmp-cmdline = {
#       enable = false;
#     }; # autocomplete for cmdline
#   };
#   extraConfigLua = ''
#         luasnip = require("luasnip")
#         kind_icons = {
#           Text = "󰊄",
#           Method = " ",
#           Function = "󰡱 ",
#           Constructor = " ",
#           Field = " ",
#           Variable = "󱀍 ",
#           Class = " ",
#           Interface = " ",
#           Module = "󰕳 ",
#           Property = " ",
#           Unit = " ",
#           Value = " ",
#           Enum = " ",
#           Keyword = " ",
#           Snippet = " ",
#           Color = " ",
#           File = "",
#           Reference = " ",
#           Folder = " ",
#           EnumMember = " ",
#           Constant = " ",
#           Struct = " ",
#           Event = " ",
#           Operator = " ",
#           TypeParameter = " ",
#         }
#
#          local cmp = require'cmp'
#
#      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
#      cmp.setup.cmdline({'/', "?" }, {
#        sources = {
#          { name = 'buffer' }
#        }
#      })
#
#     -- Set configuration for specific filetype.
#      cmp.setup.filetype('gitcommit', {
#        sources = cmp.config.sources({
#          { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
#        }, {
#          { name = 'buffer' },
#        })
#      })
#
#      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
#      cmp.setup.cmdline(':', {
#        sources = cmp.config.sources({
#          { name = 'path' }
#        }, {
#          { name = 'cmdline' }
#        }),
#      })  '';
# }
{ lib, helpers, ... }:
{
  plugins = {
    cmp = {
      enable = true;
      autoEnableSources = true;

      cmdline = {
        "/" = {
          mapping.__raw = "cmp.mapping.preset.cmdline()";
          sources = [ { name = "buffer"; } ];
        };
        ":" = {
          mapping.__raw = "cmp.mapping.preset.cmdline()";
          sources = [
            { name = "path"; }
            {
              name = "cmdline";
              option.ignore_cmds = [
                "Man"
                "!"
              ];
            }
          ];
        };
      };

      filetype = {
        sql.sources = [
          { name = "buffer"; }
          { name = "vim-dadbod-completion"; }
        ];
      };

      settings = {
        # Preselect first entry
        completion.completeopt = "menu,menuone,noinsert";
        sources = [
          {
            name = "nvim_lsp";
            priority = 100;
          }
          {
            name = "nvim_lsp_signature_help";
            priority = 100;
          }
          {
            name = "nvim_lsp_document_symbol";
            priority = 100;
          }
          {
            name = "treesitter";
            priority = 80;
          }
          {
            name = "luasnip";
            priority = 70;
          }
          {
            name = "codeium";
            priority = 60;
          }
          {
            name = "buffer";
            priority = 50;
            # Words from other open buffers can also be suggested.
            option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
            keywordLength = 3;
          }
          {
            name = "path";
            priority = 30;
          }
          {
            name = "git";
            priority = 20;
          }
          {
            name = "npm";
            priority = 20;
          }
          {
            name = "zsh";
            priority = 20;
          }
          {
            name = "calc";
            priority = 10;
          }
          {
            name = "emoji";
            priority = 5;
          }

          # Disable this if running tests with nix flake check
          (lib.mkIf helpers.enableExceptInTests { name = "nixpkgs_maintainers"; })
        ];

        window = {
          completion.border = "rounded";
          documentation.border = "rounded";
        };
        experimental.ghost_text = true;

        mapping = {
          "<Tab>".__raw = ''
            cmp.mapping(function(fallback)
              local luasnip = require("luasnip")
              if luasnip.locally_jumpable(1) then
                luasnip.jump(1)
              else
                fallback()
              end
            end, { "i", "s" })
          '';

          "<S-Tab>".__raw = ''
            cmp.mapping(function(fallback)
              local luasnip = require("luasnip")
              if luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" })
          '';

          "<C-j>" = # lua
            "cmp.mapping(cmp.mapping.select_next_item())";
          "<C-k>" = # lua
            "cmp.mapping(cmp.mapping.select_prev_item())";
          "<C-e>" = # lua
            "cmp.mapping.abort()";
          "<C-d>" = # lua
            "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = # lua
            "cmp.mapping.scroll_docs(4)";
          "<Up>" = # lua
            "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<Down>" = # lua
            "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<CR>" = # lua
            "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })";
          "<C-Space>" = # lua
            "cmp.mapping.complete()";
        };

        snippet.expand = # lua
          ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';
      };
    };
  };
}
