return {
  "amitds1997/remote-nvim.nvim",
  version = "*", -- 최신 안정화 버전 사용
  dependencies = {
    "nvim-lua/plenary.nvim",         -- 코어 유틸리티 필수 플러그인
    "MunifTanjim/nui.nvim",          -- UI 컴포넌트 렌더링용 플러그인
    "nvim-telescope/telescope.nvim", -- 서버 목록 퍼지 검색 UI를 위한 필수 플러그인
  },
  
  -- Task 3: 직관적인 커스텀 단축키 설정 (Lazy 키맵)
  keys = {
    { "<leader>rc", "<cmd>RemoteStart<CR>", desc = "Remote Connect (접속 UI 열기)" },
    { "<leader>ri", "<cmd>RemoteInfo<CR>",  desc = "Remote Info (세션 정보 확인)" },
    { "<leader>rq", "<cmd>RemoteStop<CR>",  desc = "Remote Quit (세션 종료)" },
  },

  -- Task 2: 플러그인 핵심 옵션 구성
  opts = {
    -- 1. SSH Config Parsing: 로컬 Mac의 ~/.ssh/config 파일을 읽어 서버 목록을 구성하도록 명시
    ssh_config = {
      ssh_binary = "ssh",
      scp_binary = "scp",
      ssh_config_file_paths = { "$HOME/.ssh/config" },
    },
    
    -- 2 & 3. Offline Mode 지원: 
    -- 대상 서버가 폐쇄망(인터넷 연결 끊김) 환경일 때, 
    -- 로컬 Mac 인터넷으로 Neovim 릴리즈를 받아 scp로 대상 서버에 밀어넣도록 설정 활성화
    offline_mode = {
      enabled = true,
      -- 만약 Mac 자체도 인터넷이 안되는 완전 오프라인 환경이라면 
      -- 릴리즈 파일을 수동으로 캐시에 넣고 no_github = true 로 전환하세요.
      no_github = false,
    },
  },
}
