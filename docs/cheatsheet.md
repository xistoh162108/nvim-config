# Neovim Cheatsheet
> LazyVim · Cyberdream · Leader = `Space`

---

## Modes

| 키 | 모드 | 설명 |
|----|------|------|
| `ESC` / `<C-[>` | → Normal | 노멀 모드로 복귀 |
| `i` | → Insert | 커서 앞에서 삽입 |
| `a` | → Insert | 커서 뒤에서 삽입 |
| `I` | → Insert | 줄 맨 앞에서 삽입 |
| `A` | → Insert | 줄 맨 끝에서 삽입 |
| `o` | → Insert | 아래 새 줄 + 삽입 |
| `O` | → Insert | 위 새 줄 + 삽입 |
| `v` | → Visual | 문자 비주얼 |
| `V` | → V-Line | 줄 비주얼 |
| `<C-v>` | → V-Block | 블록 비주얼 |
| `:` | → Command | 명령 모드 |
| `R` | → Replace | 교체 모드 |

---

## Navigation (Normal Mode)

| 키 | 설명 |
|----|------|
| `h` `j` `k` `l` | 좌 / 하 / 상 / 우 |
| `w` `b` `e` | 단어 앞 / 뒤 / 끝 |
| `W` `B` `E` | WORD 앞 / 뒤 / 끝 |
| `gg` / `G` | 파일 처음 / 끝 |
| `{n}G` | n번 줄로 이동 |
| `0` / `^` / `$` | 줄 시작(col0) / 첫 비공백 / 줄 끝 |
| `%` | 매칭 괄호로 점프 |
| `*` / `#` | 커서 단어 검색 (앞/뒤) |
| `f{c}` / `F{c}` | 문자 c로 점프 (앞/뒤) |
| `t{c}` / `T{c}` | 문자 c 직전으로 점프 (앞/뒤) |
| `;` / `,` | f/F/t/T 반복 |
| `<C-d>` / `<C-u>` | 반 페이지 下 / 上 |
| `<C-f>` / `<C-b>` | 한 페이지 下 / 上 |
| `zz` / `zt` / `zb` | 커서를 화면 중앙/상단/하단 |
| `H` / `M` / `L` | 화면 상단/중앙/하단으로 이동 |
| `<C-o>` / `<C-i>` | 점프 리스트 뒤로 / 앞으로 |
| `'` / `` ` `` | 마크로 이동 (줄 / 정확한 위치) |

---

## Editing (Normal Mode)

| 키 | 설명 |
|----|------|
| `x` | 커서 문자 삭제 |
| `dd` | 줄 삭제 |
| `cc` | 줄 변경 (삭제 + 삽입) |
| `yy` | 줄 복사 |
| `p` / `P` | 커서 뒤/앞에 붙여넣기 |
| `u` / `<C-r>` | 실행 취소 / 재실행 |
| `r{c}` | 문자를 c로 교체 |
| `.` | 마지막 변경 반복 |
| `~` | 대소문자 토글 |
| `>>` / `<<` | 들여쓰기 / 내어쓰기 |
| `J` | 줄 합치기 |
| `d{motion}` | 모션으로 삭제 |
| `c{motion}` | 모션으로 변경 |
| `y{motion}` | 모션으로 복사 |
| `ciw` / `diw` / `yiw` | 단어 변경/삭제/복사 |
| `ci"` / `di"` / `yi"` | 따옴표 안 변경/삭제/복사 |
| `ca"` / `da"` / `ya"` | 따옴표 포함 변경/삭제/복사 |
| `cit` / `dit` | 태그 안 변경/삭제 |
| `ci(` / `ci[` / `ci{` | 괄호 안 변경 |

---

## Search & Replace

| 키 | 설명 |
|----|------|
| `/pattern` | 앞으로 검색 |
| `?pattern` | 뒤로 검색 |
| `n` / `N` | 다음 / 이전 결과 |
| `:%s/old/new/g` | 전체 치환 |
| `:%s/old/new/gc` | 전체 치환 (확인) |
| `:s/old/new/g` | 현재 줄 치환 |

---

## Windows & Splits

| 키 | 설명 |
|----|------|
| `<C-w>s` | 수평 분할 |
| `<C-w>v` | 수직 분할 |
| `<C-w>h/j/k/l` | 창 이동 |
| `<C-w>H/J/K/L` | 창 위치 이동 |
| `<C-w>q` | 창 닫기 |
| `<C-w>=` | 창 크기 균등 |
| `<C-w>+/-` | 높이 조절 |
| `<C-w></>` | 너비 조절 |

---

## File Commands

| 키 | 설명 |
|----|------|
| `:w` | 저장 |
| `:q` | 종료 |
| `:wq` / `ZZ` | 저장 후 종료 |
| `:q!` / `ZQ` | 저장 없이 종료 |
| `:e {파일}` | 파일 열기 |

---

## Plugin Keybindings

### Flash (빠른 이동)

| 키 | 모드 | 설명 |
|----|------|------|
| `s` | n/x/o | Flash 점프 |
| `S` | n/x/o | Flash Treesitter |
| `r` | o | Remote Flash |
| `R` | o/x | Treesitter 검색 |
| `<C-s>` | cmd | Flash 검색 토글 |

| `<Esc>` | 멀티커서 종료 |

### Overseer (태스크 매니저)

| 키 | 설명 |
|----|------|
| `<leader>tr` | 태스크 실행 (OverseerRun) |
| `<leader>tt` | 태스크 목록 토글 |
| `<leader>tc` | 태스크 빌드 (OverseerBuild) |
| `<leader>ti` | 태스크 정보 |

### Navigation (Cross-tool)

| 키 | 설명 |
|----|------|
| `<C-h/j/k/l>` | Neovim 스플릿 ↔ Tmux 패널 이동 |

### Bufferline (버퍼)

| 키 | 설명 |
|----|------|
| `<S-h>` / `[b` | 이전 버퍼 |
| `<S-l>` / `]b` | 다음 버퍼 |

### File Explorer

| 키 | 설명 |
|----|------|
| `<leader>e` | 탐색기 (프로젝트 루트) |
| `<leader>E` | 탐색기 (현재 파일 위치) |
| `<leader>-` | Oil (상위 디렉토리) |

### Telescope (퍼지 파인더)

| 키 | 설명 |
|----|------|
| `<leader>ff` | 파일 찾기 |
| `<leader>fg` | Live Grep |
| `<leader>fb` | 버퍼 찾기 |
| `<leader>fh` | 도움말 태그 |
| `<leader>fp` | 프로젝트 목록 |
| `<leader>st` | TODO 검색 |

### Harpoon (빠른 파일 이동)

| 키 | 설명 |
|----|------|
| `<leader>ha` | 현재 파일 추가 |
| `<leader>hh` | Harpoon 메뉴 |
| `<leader>h1` | 북마크 1로 이동 |
| `<leader>h2` | 북마크 2로 이동 |
| `<leader>h3` | 북마크 3로 이동 |
| `<leader>h4` | 북마크 4로 이동 |
| `[h` / `]h` | 이전 / 다음 북마크 |

### Git

| 키 | 설명 |
|----|------|
| `<leader>gg` | LazyGit 열기 |
| `]c` / `[c` | 다음 / 이전 Git Hunk |
| `<leader>hs` | Hunk 스테이지 |
| `<leader>hr` | Hunk 리셋 |
| `<leader>hu` | Hunk 스테이지 취소 |
| `<leader>hp` | Hunk 미리보기 |
| `<leader>hb` | 줄 Blame |
| `<leader>go` | Diffview 열기 |
| `<leader>gc` | Diffview 닫기 |
| `<leader>gh` | Diffview 파일 히스토리 |
| `<leader>gS` | Fugit2 상태 |
| `<leader>gG` | Fugit2 그래프 |

### LSP (Language Server Protocol)

| 키 | 설명 |
|----|------|
| `gd` | 정의로 이동 |
| `gD` | 선언으로 이동 |
| `gI` | 구현으로 이동 |
| `gy` | 타입 정의로 이동 |
| `gr` | 참조 찾기 (Telescope) |
| `K` | 호버 문서 |
| `<leader>ca` | 코드 액션 |
| `<leader>cr` | 심볼 이름 변경 |
| `<leader>cf` | 포맷 |

### Glance (미리보기 창)

| 키 | 설명 |
|----|------|
| `gpd` | 정의 미리보기 (현재 파일 유지) |
| `gpr` | 참조 미리보기 |
| `gpt` | 타입 정의 미리보기 |
| `gpi` | 구현 미리보기 |

### Trouble (진단)

| 키 | 설명 |
|----|------|
| `<leader>xx` | 전체 진단 토글 |
| `<leader>xX` | 버퍼 진단 토글 |
| `<leader>cs` | 심볼 (Trouble) — Normal mode |
| `<leader>xL` | Location List |
| `<leader>xQ` | Quickfix List |
| `<leader>xr` | LSP 참조/정의 (Trouble) |

| `<leader>O` | 코드 아웃라인 토글 |

### Undotree (히스토리 시각화)

| 키 | 설명 |
|----|------|
| `<leader>ut` | 무한 Undo 트리 토글 |

### Treesitter Context

| 키 | 설명 |
|----|------|
| `<leader>tc` | 상단 고정 컨텍스트 토글 (현재 함수/클래스 표시) |

### Dropbar (Breadcrumbs)

| 키 | 설명 |
|----|------|
| `<leader>.` | Breadcrumb 픽 모드 (키보드로 경로 이동) |

### DAP (디버깅)

| 키 | 설명 |
|----|------|
| `<leader>db` | 브레이크포인트 토글 |
| `<leader>dc` | 디버그 시작/계속 |
| `<leader>di` | Step Into |
| `<leader>do` | Step Over |
| `<leader>dO` | Step Out |
| `<leader>dr` | DAP REPL |
| `<leader>dl` | 마지막 실행 반복 |
| `<leader>du` | DAP UI 토글 |
| `<leader>dt` | 인라인 진단 토글 |

### Neotest (테스트 러너)

| 키 | 설명 |
|----|------|
| `<leader>Tr` | 가장 가까운 테스트 실행 |
| `<leader>Tf` | 현재 파일 전체 테스트 |
| `<leader>Ts` | 테스트 요약 패널 |
| `<leader>To` | 테스트 출력 패널 |
| `<leader>Tx` | 테스트 중지 |
| `]T` | 다음 실패 테스트로 이동 |
| `[T` | 이전 실패 테스트로 이동 |

### Avante (AI · Claude)

| 키 | 모드 | 설명 |
|----|------|------|
| `<leader>aa` | n | Avante에 질문 |
| `<leader>at` | n | Avante 토글 |
| `<leader>af` | n | Avante 포커스 |
| `<leader>ar` | n | Avante 새로고침 |
| `<leader>ae` | v | 선택 영역 편집 |
| `<leader>aR` | n | RepoMap 표시 |
| `<leader>am` | n | 모델 전환 |
| `<leader>ap` | n | 프로바이더 전환 |
| `<leader>as` | n | Avante 중지 |
| `<leader>an` | n | 새 채팅 |
| `<leader>ah` | n | 대화 히스토리 |
| `y` / `n` | n | 충돌 수락 / 거절 |
| `]x` / `[x` | n | 다음 / 이전 충돌 |

### Copilot (Insert Mode)

| 키 | 설명 |
|----|------|
| `<C-l>` | 제안 수락 |
| `<C-j>` | 단어 수락 |
| `<C-;>` | 다음 제안 |
| `<C-,>` | 이전 제안 |
| `<C-]>` | 제안 취소 |

### UFO Folding

| 키 | 설명 |
|----|------|
| `zR` | 모든 폴드 열기 |
| `zM` | 모든 폴드 닫기 |
| `zr` | 폴드 레벨 줄이기 |
| `zm` | 폴드 레벨 늘리기 |
| `zp` | 폴드 미리보기 |
| `zK` | 폴드 미리보기 or 호버 |

### Terminal

| 키 | 설명 |
|----|------|
| `<leader>tf` | 플로팅 터미널 토글 |
| `<leader>ts` | 스플릿 터미널 토글 |

### Markdown Preview (Disabled by default)

_Use `render-markdown.nvim` which handles in-editor rendering automatically._


### Minimap (neominimap.nvim)

| 키 | 설명 |
|----|------|
| `<leader>nm` | 전역 미니맵 토글 (Toggle) |
| `<leader>no` | 전역 미니맵 활성화 (Enable) |
| `<leader>nc` | 전역 미니맵 비활성화 (Disable) |
| `<leader>nwt` | 현재 창 미니맵 토글 |
| `<leader>nf` | 미니맵으로 포커스 이동 |

---

### Database (vim-dadbod-ui)

| 키 | 설명 |
|----|------|
| `<leader>D` | DBUI 사이드패널 토글 |
| `o` (DBUI창) | 연결/테이블 열기 |
| `R` (DBUI창) | 새로고침 |
| `\S` (SQL버퍼) | 쿼리 실행 (결과 하단 창) |
| `\S` (Visual) | 선택 영역만 실행 |

> DB 연결: `:DBUIAddConnection` 또는 환경변수 `DB_URL`

### Market Watcher (증시/시세 위젯)

| 키 | 모드 | 설명 |
|----|------|------|
| `<leader>M` | n | Market Watcher (BTC/KOSPI 등) 토글 |
| `r` | (위젯) | 수동 새로고침 (Refresh) |
| `<CR>` | (위젯) | 커서 종목 차트 웹 브라우저로 열기 |
| `q` / `<ESC>` | (위젯) | 위젯 닫기 |

### Obsidian (Notes & Workspace)

| 키 | 모드 | 설명 |
|----|------|------|
| `<leader>od` | n | 데일리 노트 (`60_Periodic/a. Daily`) 생성/열기 |
| `<leader>on` | n | 새 커스텀 노트 생성 (`00_Inbox/`) |
| `<leader>os` | n | 전체 볼트 퍼지 검색 (Telescope) |
| `<leader>os` | v | 선택 코드 스니펫 → 프로젝트 노트 맨 아래에 추가 |
| `<leader>op` | n | **Obsidian Workspace** (탐색기+뷰어) 토글 |
| `<leader>oe` | n | 현재 프로젝트의 Obsidian 폴더 열기 (Explorer) |
| `<leader>of` | n | 현재 프로젝트의 Obsidian 노트들 검색 (Finder) |
| `<leader>oa` | n | 프로젝트 동기화/아카이브 (`40_Archive`로 이동) |
| `<leader>ob` | n | 현재 노트 백링크 목록 |
| `gf` | n | `[[링크]]` 위에서 해당 노트로 이동 |
| `<CR>`  | (탐색기) | 선택 파일 → 하단 뷰어로 열기 및 커서 이동 (Edit) |
| `<Tab>` | (탐색기) | 선택 파일 → 하단 뷰어로 열기 (미리보기/Preview) |

> **Workpace State Machine**
> 프로젝트 상태(Active/Archive)에 따라 Obsidian 폴더를 자동으로 `10_Projects`와 `40_Archive` 사이에서 동기화하며, 워크스페이스 활성화 시 전용 보라색(Purple) 테두리가 적용됩니다.

### Jupyter / Molten

| 키 | 모드 | 설명 |
|----|------|------|
| `<leader>mi` | n | Python3 커널 초기화 |
| `<leader>ml` | n | 현재 줄 실행 |
| `<leader>mc` | n | 현재 셀 재실행 |
| `<leader>mo` | n | 출력 창으로 포커스 이동 |
| `<leader>mh` | n | 출력 창 숨기기 |

> 이미지 렌더링: image.nvim (backend: iTerm2 3.5+ 및 Kitty 지원)

### LaTeX (vimtex)

> `\` = localleader. `.tex` 파일에서 활성

| 키 | 설명 |
|----|------|
| `\ll` | 컴파일 시작 / 토글 (Auto-Compile) |
| `\lv` | PDF 포워드 검색 (nvim → Skim) |
| `\le` | 컴파일 에러 목록 열기 |

| `<leader>Fd` | 연결된 디바이스 목록 |
| `<leader>Fr` | Flutter Run |
| `<leader>FH` | Hot Reload |
| `<leader>FR` | Hot Restart |

### Low-Level & Academic

| 키 | 설명 |
|----|------|
| `<leader>ce` | Compiler Explorer (C → ASM 실시간 변환) |
| `<leader>hx` | HexView 토글 (바이너리 분석) |
| `K` (asm파일) | 어셈블리 명령어(Opcode) 도움말 호버 |
| `!header` | (Insert) 과제용 헤더 템플릿 생성 |
| `!socket` | (Insert) C 네트워크 소켓 프로그래밍 템플릿 |
| `!asm_temp` | (Insert) x86_64 어셈블리 기본 템플릿 |
| `<leader>fX` | (Fun) Cellular Automaton: Make it Rain! |
| `<leader>fG` | (Fun) Cellular Automaton: Game of Life |

---

### Misc

| 키 | 설명 |
|----|------|
| `<leader>tt` | 다크/라이트 테마 토글 |
| `,v` | 가상환경 선택 |
| `<leader>.` | Dropbar breadcrumb 픽 |
| `<leader>bd` | 버퍼 닫기 & 레이아웃 보호 (대시보드 복구) |
| `:TelemetryReport` | 사용 통계 보고서 생성 |

---

## 포맷터 (Conform)

| 언어 | 포맷터 |
|------|--------|
| C / C++ / Rust | clang-format / rustfmt |
| Java | google-java-format |
| Python | ruff |
| JS/TS/JSON/MD | prettierd |

---

## 레이아웃 명령

| 명령 | 설명 |
|------|------|
| `:LayoutDefault` | 기본 3단 정렬 레이아웃 적용 |
| `:LayoutBottomPanels` | 하단 패널(터미널 등) 높이 균등 정리 |
