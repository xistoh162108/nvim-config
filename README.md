# 🚀 완전체 Terminal IDE 환경 설정 가이드

본 저장소와 설정 파일들은 단순히 예쁜 화면을 넘어서 **Zsh + Tmux + 60여 개의 Neovim 플러그인**의 완벽한 생태계를 구축하여 macOS 터미널을 강력한 개발용 IDE로 변모시킵니다. VSCode를 상회하는 속도, AI 코딩 경험, 그리고 키보드 중심의 생산성을 제공합니다.

---

## 🌟 핵심 구성 요소 (Core Components)

### 1. Zsh (터미널 쉘)
Fish 쉘의 사용자 경험(UX)을 이식하고, 최신 Rust CLI로 무장했습니다.
- **Powerlevel10k & Zsh 기능**: 지연 없는 프롬프트, Autosuggestions(명령어 추천), Syntax Highlighting(명령어 채색), History Substring Search(이전 명령어 부분 검색), Zsh-Abbr(공백으로 전개되는 단축키).
- **Rust 기반 현대적 CLI**: `eza` (아이콘 지원 ls), `yazi` (미디어 프리뷰 파일 매니저), `tealdeer` (오프라인 예시 제공 `man`), `jless` & `termshark` (네트워크 및 API 디버깅).
- **Direnv (.envrc)**: 프로젝트 진입 시 가상 환경과 환경 변수(API 키 등)를 자동으로 로드합니다.

### 2. Tmux (터미널 멀티플렉서)
작업 흐름을 결코 끊기지 않게 하는 프로젝트 관리의 뼈대입니다. (Prefix: `Ctrl + a`)
- **버릴 곳 없는 화면 분할**: Neovim과 동일한 방향키(`hjkl`)로 패널 탐색이 연동되며, 저장 및 자동 복원(Resurrect)을 지원합니다.
- **어디서든 팝업 (FloaX & SessionX)**:
  - `prefix + p`: 화면 정중앙에 플로팅 팝업 터미널을 띄워 현재 레이아웃을 망가뜨리지 않고 `lazygit`이나 테스트 스크립트를 실행.
  - `prefix + o`: 활성화된 전체 프로젝트를 퍼지 검색하여 눈 깜짝할 새 즉각 세션 이동.
- **Extrakto**: `prefix + Tab`으로 이전에 출력된 로그나 경로를 마우스 드래그 없이 파싱해서 바로 클립보드에 담아줍니다.

---

## 🧠 3. Neovim (초연결 텍스트 에디터)

일반적인 텍스트 에디터를 넘어 AI와 통합된 개발 전용 슈퍼 컴퓨터입니다. **총 60개 이상의 메이저 플러그인**이 유기적으로 충돌 없이 통합되어 있습니다.

### 🤖 3.1 AI 페어 프로그래밍 (Copilot & Avante)
VSCode의 Cursor 에디터와 동일한 AI 경험을 터미널에 탑재했습니다.
- **Github Copilot**: 코딩 중 맥락을 파악해 회색 텍스트 오토컴플릿 제안 (`Ctrl+l` 수락).
- **Avante.nvim (`<leader>aa`)**: 터미널 자체 사이드바에 나타나는 AI 채팅. 현재 열려 있는 코드에 대해 질문하고, AI가 제안한 코드를 즉석에서 파일에 반영(Apply) 하 수 있습니다.

### ⚡ 3.2 극강의 코드 조작과 리팩토링
- **Inc-Rename (`<leader>cr`)**: 변수나 함수 이름을 일괄 변경할 때 모든 변경 사항을 **실시간으로 미리보기(Live Preview)** 합니다.
- **Dial.nvim (`<C-a>/<C-x>`)**: 코딩 중 마주치는 숫자, `true/false`, IP, 날짜 등을 맥락에 맞게 똑똑하게 증감시킵니다.
- **Multicursor (`<C-n>`)**: VSCode의 다중 커서 및 선택 편집을 완벽하게 재현했습니다.
- **Neoclip (`<leader>fy`)**: 과거 복사/삭제 내역을 SQLite에 저장하여 나중에 언제든 검색해서 다시 붙여넣을 수 있습니다.
- **Im-Select**: Insert(입력) 모드에서 한글을 쓰다가 `Esc`로 Normal 모드 복귀 시, 운영체제의 입력기가 **자동으로 영어로 전환**됩니다. 영문 명령어를 쳐야 하는데 한글로 오타가 나는 치명적인 스트레스를 제거했습니다.

### 🔍 3.3 내비게이션 및 디버깅 생태계
- **Telescope & Harpoon**: 파일 찾기, 전체 텍스트 검색(Live Grep)은 기본이며, 가장 자주 가는 파일 4개는 Harpoon(`<leader>ha`) 등록 후 단축키 1번으로 즉각 이동합니다.
- **DAP (Debug Adapter Protocol)**: 터미널 안에서 그래픽 UI 기반의 브레이크포인트 생성, 스텝 오버, 변수 감시를 모두 수행합니다 (`<leader>dc`, `<leader>db`).
- **에러 파악 (Trouble & Lualine)**: 코드 하단의 상태바와 Trouble(`<leader>xx`) 창에서 프로젝트 전역의 에러나 경고를 손쉽게 수집합니다.
- **시각화 (Flash & Smear Cursor)**: 마우스 없이 화면 어디든 3글자만 치면 점프하는 Flash 스나이퍼 모드(`s`), 커서 이동 시 잔상을 남기는 고주사율 부드러운 이동을 제공합니다.

---

## 🛠 설치 및 셋업 (Installation)
1. **Tmux 플러그인**: `prefix + I` 로 TPM 플러그인 로드.
2. **Neovim 플러그인**: `nvim` 실행 시 Lazy.nvim이 60여 개의 플러그인을 병렬 자동 설치.
3. **세부 확인**: `~/.zshrc`의 터미널 테마, Homebrew 경로 등 점검 후 쉘 재시작.

> 💡 **사용법 통합 가이드 목록:**
> 코어 단축키와 주요 플러그인들의 연결된 사용법은 아래 문서를 필수적으로 확인하세요!
> - [📘 상세 워크플로우 가이드 (docs/workflow.md)](docs/workflow.md): 실제 상황에서 어떻게 플러그인들을 조합해서 쓰는지, 충돌 방지는 어떻게 했는지 적혀 있습니다.
> - [⌨️ 전체 치트시트 (docs/cheatsheet.md)](docs/cheatsheet.md): 단 1장으로 요약된 60개 플러그인의 절대 단축키 요약본입니다.
