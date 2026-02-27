return {
  {
    "dnlhc/glance.nvim",
    cmd = "Glance",
    keys = {
      { "gpd", "<cmd>Glance definitions<CR>",      desc = "Peek definitions" },
      { "gpr", "<cmd>Glance references<CR>",       desc = "Peek references" },
      { "gpt", "<cmd>Glance type_definitions<CR>", desc = "Peek type definitions" },
      { "gpi", "<cmd>Glance implementations<CR>",  desc = "Peek implementations" },
    },
    opts = {
      border = {
        enable = true,
        top_char = "―",
        bottom_char = "―",
      },
      -- 현재 파일을 떠나지 않고 같은 위치에 미리보기
      hooks = {
        before_open = function(results, open, jump, method)
          if #results == 1 then
            jump(results[1]) -- 결과가 하나면 바로 이동
          else
            open(results)
          end
        end,
      },
    },
  },
}
