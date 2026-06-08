# BEPlayground

`FastAPI` 기반 Todo 백엔드 예제입니다.

## 포함 기능

- Todo CRUD API: `GET/POST/PATCH/DELETE /api/todos`
- Todo 페이지네이션 조회: `GET /api/todos/page?page=1&size=10`
- DB 현황판 페이지: `/db`
- Swagger 페이지: `/swagger`
- OpenAPI JSON: `/openapi.json`

## 실행

```bash
cd Playground/BEPlayground
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

실행 후:

- 홈: `http://127.0.0.1:8000/`
- Swagger: `http://127.0.0.1:8000/swagger`
- DB 현황판: `http://127.0.0.1:8000/db`

## 예시 요청

```bash
curl -X POST http://127.0.0.1:8000/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"ReactorKit 화면 만들기","description":"Todo 앱 초안 연결","is_done":false}'
```

```bash
curl "http://127.0.0.1:8000/api/todos"
```

```bash
curl "http://127.0.0.1:8000/api/todos/page?page=1&size=10"
```
