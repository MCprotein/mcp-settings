## 실행방법

### 기본 사용법

1. **모든 MCP 서비스 시작**

   ```bash
   make up
   ```

2. **특정 MCP 서비스 시작**

   ```bash
   make up brave-search-mcp
   make up excel-mcp-server
   make up playwright-mcp
   make up sequential-thinking-mcp
   ```

3. **환경변수 파일 지정하여 시작**
   ```bash
   make up brave-search-mcp ENV_FILE=.env.prod
   ```

### 관리 명령어

4. **서비스 중지**

   ```bash
   make down                    # 모든 서비스 중지
   make down brave-search-mcp   # 특정 서비스 중지
   ```

5. **서비스 목록 확인**

   ```bash
   make list
   ```

6. **도움말 보기**

   ```bash
   make help
   ```

7. **모든 서비스 정리 (볼륨 포함)**
   ```bash
   make clean
   ```

### 환경 설정

- 기본 환경변수 파일: `.env`
- 커스텀 환경변수 파일 사용: `ENV_FILE=.env.prod`
- 환경변수 파일은 프로젝트 루트 디렉토리에 위치해야 합니다.
