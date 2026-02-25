return {
  {
    "kevinhwang91/nvim-ufo",
    event = "BufReadPost",
    dependencies = { "kevinhwang91/promise-async" },
    opts = {
      provider_selector = function(_, _, _)
        -- LSP 폴딩이 되는 언어면 LSP가 더 정확한 경우가 많고
        -- 안되면 treesitter/indent로 fallback
        return { "lsp", "treesitter", "indent" }
      end,
    },
    init = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    keys = {
      -- 기본 zR/zM을 ufo 버전으로 (foldlevel 망가뜨리지 않는게 장점)
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        desc = "Ufo Open all folds",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        desc = "Ufo Close all folds",
      },

      -- 선택: fold 더/덜
      {
        "zr",
        function()
          require("ufo").openFoldsExceptKinds()
        end,
        desc = "Ufo Fold less",
      },
      {
        "zm",
        function()
          require("ufo").closeFoldsWith()
        end,
        desc = "Ufo Fold more",
      },

      -- 선택: 커서 아래 접힌 내용 미리보기(진짜 꿀기능)
      {
        "zp",
        function()
          require("ufo").peekFoldedLinesUnderCursor()
        end,
        desc = "Ufo Peek fold",
      },
    },
  },
}
