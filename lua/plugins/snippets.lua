-- lua/plugins/snippets.lua
-- Academic and Low-Level Snippets (LuaSnip)

return {
  {
    "L3MON4D3/LuaSnip",
    opts = function()
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local f = ls.function_node

      -- Helper for current date
      local date = function() return { os.date("%Y-%m-%d") } end
      -- Helper for filename
      local filename = function() return { vim.fn.expand("%:t") } end

      ls.add_snippets("all", {
        -- Academic Assignment Header
        s("!header", {
          t({ "/*", " * Assignment: " }), i(1, "Title"),
          t({ "", " * File:       " }), f(filename, {}),
          t({ "", " * Date:       " }), f(date, {}),
          t({ "", " * Author:     bagjimin (xistoh162108)", " * Description: " }), i(2, "Brief description here"),
          t({ "", " */", "" }),
        }),
      })

      ls.add_snippets("c", {
        -- Socket Programming Template (Network Course)
        s("!socket", {
          t({ "#include <stdio.h>", "#include <stdlib.h>", "#include <string.h>", "#include <unistd.h>", 
              "#include <arpa/inet.h>", "#include <sys/socket.h>", "", "int main() {", 
              "    int sock = socket(PF_INET, SOCK_STREAM, 0);", 
              "    struct sockaddr_in serv_addr;", 
              "    memset(&serv_addr, 0, sizeof(serv_addr));", 
              "    serv_addr.sin_family = AF_INET;", 
              "    serv_addr.sin_addr.s_addr = inet_addr(\"127.0.0.1\");", 
              "    serv_addr.sin_port = htons(" }), i(1, "8080"), t({ ");", "", "    return 0;", "}" }),
        }),
      })

      ls.add_snippets("asm", {
        -- Basic x86_64 Template (System Programming)
        s("!asm_temp", {
          t({ "section .text", "    global _start", "", "_start:", "    ; write your code here", 
              "    mov rax, 60         ; sys_exit", "    mov rdi, 0          ; error code 0", "    syscall" }),
        }),
      })
    end,
  },
}
