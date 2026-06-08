from contextlib import asynccontextmanager
from html import escape
from sqlite3 import connect

from fastapi import Depends, FastAPI, Form, HTTPException, Query, Response, status
from fastapi.openapi.docs import get_swagger_ui_html
from fastapi.responses import HTMLResponse, JSONResponse, RedirectResponse
from sqlalchemy import select
from sqlalchemy.orm import Session

from .database import BASE_DIR, DB_PATH, Base, engine, get_db
from .models import Todo, TodoCreate, TodoListResponse, TodoRead, TodoUpdate


@asynccontextmanager
async def lifespan(_: FastAPI):
    Base.metadata.create_all(bind=engine)
    yield


app = FastAPI(
    title="BEPlayground Todo API",
    version="1.0.0",
    description="Todo CRUD API with a database dashboard and a dedicated Swagger page.",
    docs_url=None,
    redoc_url=None,
    lifespan=lifespan,
)


def normalize_title(title: str) -> str:
    normalized = title.strip()
    if not normalized:
        raise HTTPException(status_code=422, detail="Title must not be blank")
    return normalized


def normalize_page(page: int) -> int:
    return page if page > 0 else 1


def normalize_page_size(size: int) -> int:
    if size < 1:
        return 10
    return min(size, 100)


def layout(title: str, content: str) -> str:
    return f"""
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="utf-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1" />
      <title>{escape(title)}</title>
      <style>
        :root {{
          --bg: #f4efe6;
          --panel: #fffdf9;
          --ink: #1d1b19;
          --muted: #6f665d;
          --accent: #0d7c66;
          --accent-soft: #dff3ee;
          --line: #e7dccf;
          --danger: #a63b32;
        }}
        * {{ box-sizing: border-box; }}
        body {{
          margin: 0;
          font-family: "Avenir Next", "Pretendard", sans-serif;
          background:
            radial-gradient(circle at top left, #fff5d9 0, transparent 30%),
            linear-gradient(180deg, #f8f4ec 0%, var(--bg) 100%);
          color: var(--ink);
        }}
        .wrap {{ max-width: 1100px; margin: 0 auto; padding: 40px 20px 60px; }}
        .hero {{
          background: linear-gradient(135deg, #173b34 0%, #0d7c66 100%);
          color: white;
          border-radius: 28px;
          padding: 28px;
          box-shadow: 0 20px 60px rgba(19, 58, 51, 0.18);
        }}
        .hero h1 {{ margin: 0 0 10px; font-size: 2rem; }}
        .hero p {{ margin: 0; color: rgba(255,255,255,.86); }}
        .nav {{
          display: flex;
          flex-wrap: wrap;
          gap: 12px;
          margin-top: 18px;
        }}
        .nav a, .button {{
          display: inline-flex;
          align-items: center;
          justify-content: center;
          padding: 12px 16px;
          border-radius: 999px;
          text-decoration: none;
          border: 1px solid transparent;
          color: white;
          background: rgba(255,255,255,.14);
          backdrop-filter: blur(10px);
          font-weight: 600;
        }}
        .nav a.secondary {{
          color: var(--ink);
          background: var(--panel);
          border-color: var(--line);
        }}
        .grid {{
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
          gap: 16px;
          margin-top: 24px;
        }}
        .card {{
          background: var(--panel);
          border: 1px solid var(--line);
          border-radius: 22px;
          padding: 20px;
          box-shadow: 0 8px 30px rgba(61, 48, 34, 0.07);
        }}
        .card h2, .card h3 {{ margin-top: 0; }}
        .muted {{ color: var(--muted); }}
        table {{
          width: 100%;
          border-collapse: collapse;
          margin-top: 12px;
          font-size: 0.95rem;
        }}
        th, td {{
          text-align: left;
          padding: 12px;
          border-bottom: 1px solid var(--line);
          vertical-align: top;
        }}
        th {{ color: var(--muted); font-weight: 700; }}
        code {{
          background: #f3ede4;
          padding: 2px 6px;
          border-radius: 6px;
        }}
        .pill {{
          display: inline-flex;
          padding: 6px 10px;
          border-radius: 999px;
          font-size: 0.85rem;
          font-weight: 700;
        }}
        .done {{ background: #dff3ee; color: var(--accent); }}
        .pending {{ background: #fbe7d5; color: #9a5612; }}
        .empty {{
          padding: 18px;
          border: 1px dashed var(--line);
          border-radius: 16px;
          color: var(--muted);
          background: rgba(255,255,255,.45);
        }}
        .stack {{
          display: grid;
          gap: 18px;
          margin-top: 18px;
        }}
        form {{
          margin: 0;
        }}
        .form-grid {{
          display: grid;
          grid-template-columns: 1.1fr 1.6fr auto;
          gap: 12px;
          align-items: end;
        }}
        label {{
          display: grid;
          gap: 8px;
          font-weight: 600;
        }}
        input[type="text"], textarea {{
          width: 100%;
          border: 1px solid var(--line);
          border-radius: 14px;
          padding: 12px 14px;
          font: inherit;
          background: #fff;
          color: var(--ink);
        }}
        textarea {{
          min-height: 96px;
          resize: vertical;
        }}
        .checkbox {{
          display: inline-flex;
          align-items: center;
          gap: 8px;
          color: var(--muted);
        }}
        .button {{
          cursor: pointer;
          font: inherit;
        }}
        .button.primary {{
          background: var(--accent);
          color: white;
        }}
        .button.danger {{
          background: var(--danger);
          color: white;
        }}
        .status-button {{
          border: 0;
          padding: 0;
          background: transparent;
        }}
        .form-actions {{
          display: grid;
          gap: 12px;
          align-self: stretch;
        }}
        .row-actions {{
          display: flex;
          justify-content: flex-end;
        }}
        .inline-form {{
          display: inline-flex;
        }}
        .pager {{
          display: flex;
          flex-wrap: wrap;
          align-items: center;
          justify-content: space-between;
          gap: 12px;
          margin-top: 16px;
        }}
        .pager-info {{
          color: var(--muted);
          font-weight: 600;
        }}
        .pager-nav {{
          display: flex;
          gap: 10px;
        }}
        .pager-link {{
          display: inline-flex;
          align-items: center;
          justify-content: center;
          min-width: 92px;
          padding: 10px 14px;
          border-radius: 999px;
          text-decoration: none;
          border: 1px solid var(--line);
          background: #fff;
          color: var(--ink);
          font-weight: 700;
        }}
        .pager-link.disabled {{
          pointer-events: none;
          opacity: 0.45;
        }}
        @media (max-width: 820px) {{
          .form-grid {{
            grid-template-columns: 1fr;
          }}
          .row-actions {{
            justify-content: flex-start;
          }}
          .pager {{
            align-items: flex-start;
            flex-direction: column;
          }}
        }}
      </style>
    </head>
    <body>
      <main class="wrap">
        {content}
      </main>
      <script>
        const scrollKey = "db-dashboard-scroll-y";
        document.querySelectorAll("form[data-preserve-scroll='true']").forEach((form) => {{
          form.addEventListener("submit", () => {{
            sessionStorage.setItem(scrollKey, String(window.scrollY));
          }});
        }});

        const savedScrollY = sessionStorage.getItem(scrollKey);
        if (savedScrollY !== null) {{
          window.addEventListener("load", () => {{
            window.scrollTo(0, Number(savedScrollY));
            sessionStorage.removeItem(scrollKey);
          }});
        }}
      </script>
    </body>
    </html>
    """


@app.get("/", response_class=HTMLResponse, include_in_schema=False)
def home() -> str:
    content = """
    <section class="hero">
      <h1>BEPlayground Todo Backend</h1>
      <p>FastAPI 기반 CRUD API, 데이터베이스 현황판, Swagger 페이지를 한 곳에 모았습니다.</p>
      <div class="nav">
        <a href="/swagger">Swagger</a>
        <a href="/db" class="secondary">DB Dashboard</a>
        <a href="/api/todos" class="secondary">Todos JSON</a>
      </div>
    </section>
    <section class="grid">
      <article class="card">
        <h2>API</h2>
        <p class="muted"><code>/api/todos</code>에서 Todo 목록 조회, 생성, 수정, 삭제를 할 수 있습니다.</p>
      </article>
      <article class="card">
        <h2>Dashboard</h2>
        <p class="muted"><code>/db</code>에서 SQLite 파일 위치, 테이블 스키마, 최근 데이터 현황을 확인할 수 있습니다.</p>
      </article>
      <article class="card">
        <h2>Swagger</h2>
        <p class="muted"><code>/swagger</code>에서 OpenAPI 기반 문서를 바로 테스트할 수 있습니다.</p>
      </article>
    </section>
    """
    return layout("BEPlayground", content)


@app.get("/health", response_class=JSONResponse, tags=["meta"])
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.get("/swagger", include_in_schema=False)
def swagger():
    return get_swagger_ui_html(
        openapi_url="/openapi.json",
        title=f"{app.title} Swagger UI",
    )


@app.get("/api/todos", response_model=list[TodoRead], tags=["todos"])
def list_todos(db: Session = Depends(get_db)) -> list[Todo]:
    return list(db.scalars(select(Todo).order_by(Todo.id.desc())))


@app.get("/api/todos/page", response_model=TodoListResponse, tags=["todos"])
def list_todos_paginated(
    page: int = Query(1, description="Page number, starting from 1"),
    size: int = Query(10, description="Number of items per page"),
    db: Session = Depends(get_db),
) -> TodoListResponse:
    page = normalize_page(page)
    size = normalize_page_size(size)
    total = db.query(Todo).count()
    total_pages = max(1, (total + size - 1) // size)
    page = min(page, total_pages)
    offset = (page - 1) * size
    items = list(db.scalars(select(Todo).order_by(Todo.id.desc()).offset(offset).limit(size)))
    return TodoListResponse(
        items=items,
        total=total,
        page=page,
        size=size,
        total_pages=total_pages,
    )


@app.post(
    "/api/todos",
    response_model=TodoRead,
    status_code=status.HTTP_201_CREATED,
    tags=["todos"],
)
def create_todo(payload: TodoCreate, db: Session = Depends(get_db)) -> Todo:
    todo = Todo(
        title=normalize_title(payload.title),
        description=payload.description.strip() if payload.description else None,
        is_done=payload.is_done,
    )
    db.add(todo)
    db.commit()
    db.refresh(todo)
    return todo


@app.get("/api/todos/{todo_id}", response_model=TodoRead, tags=["todos"])
def get_todo(todo_id: int, db: Session = Depends(get_db)) -> Todo:
    todo = db.get(Todo, todo_id)
    if todo is None:
        raise HTTPException(status_code=404, detail="Todo not found")
    return todo


@app.patch("/api/todos/{todo_id}", response_model=TodoRead, tags=["todos"])
def update_todo(todo_id: int, payload: TodoUpdate, db: Session = Depends(get_db)) -> Todo:
    todo = db.get(Todo, todo_id)
    if todo is None:
        raise HTTPException(status_code=404, detail="Todo not found")

    updates = payload.model_dump(exclude_unset=True)
    if "title" in updates and updates["title"] is not None:
        updates["title"] = normalize_title(updates["title"])
    if "description" in updates:
        description = updates["description"]
        updates["description"] = description.strip() if description else None

    for key, value in updates.items():
        setattr(todo, key, value)

    db.add(todo)
    db.commit()
    db.refresh(todo)
    return todo


@app.delete("/api/todos/{todo_id}", status_code=status.HTTP_204_NO_CONTENT, tags=["todos"])
def delete_todo(todo_id: int, db: Session = Depends(get_db)) -> Response:
    todo = db.get(Todo, todo_id)
    if todo is None:
        raise HTTPException(status_code=404, detail="Todo not found")
    db.delete(todo)
    db.commit()
    return Response(status_code=status.HTTP_204_NO_CONTENT)


@app.post("/db/todos", include_in_schema=False)
def create_todo_from_dashboard(
    title: str = Form(...),
    description: str = Form(""),
    is_done: bool = Form(False),
    page: int = Form(1),
    db: Session = Depends(get_db),
):
    page = normalize_page(page)
    todo = Todo(
        title=normalize_title(title),
        description=description.strip() or None,
        is_done=is_done,
    )
    db.add(todo)
    db.commit()
    return RedirectResponse(url=f"/db?page={page}", status_code=status.HTTP_303_SEE_OTHER)


@app.post("/db/todos/{todo_id}/delete", include_in_schema=False)
def delete_todo_from_dashboard(todo_id: int, page: int = Form(1), db: Session = Depends(get_db)):
    page = normalize_page(page)
    todo = db.get(Todo, todo_id)
    if todo is None:
        raise HTTPException(status_code=404, detail="Todo not found")
    db.delete(todo)
    db.commit()
    return RedirectResponse(url=f"/db?page={page}", status_code=status.HTTP_303_SEE_OTHER)


@app.post("/db/todos/{todo_id}/toggle", include_in_schema=False)
def toggle_todo_from_dashboard(todo_id: int, page: int = Form(1), db: Session = Depends(get_db)):
    page = normalize_page(page)
    todo = db.get(Todo, todo_id)
    if todo is None:
        raise HTTPException(status_code=404, detail="Todo not found")
    todo.is_done = not todo.is_done
    db.add(todo)
    db.commit()
    return RedirectResponse(url=f"/db?page={page}", status_code=status.HTTP_303_SEE_OTHER)


@app.get("/db", response_class=HTMLResponse, include_in_schema=False)
def database_dashboard(page: int = Query(1), db: Session = Depends(get_db)) -> str:
    page = normalize_page(page)
    page_size = 10
    total = db.query(Todo).count()
    done = db.query(Todo).filter(Todo.is_done.is_(True)).count()
    pending = total - done
    total_pages = max(1, (total + page_size - 1) // page_size)
    page = min(page, total_pages)
    offset = (page - 1) * page_size
    todos = list(
        db.scalars(select(Todo).order_by(Todo.id.desc()).offset(offset).limit(page_size))
    )

    with connect(DB_PATH) as sqlite:
        sqlite.row_factory = None
        columns = sqlite.execute("PRAGMA table_info(todos)").fetchall()

    rows = "".join(
        f"""
        <tr>
          <td>{todo.id}</td>
          <td>{escape(todo.title)}</td>
          <td>{escape(todo.description or "-")}</td>
          <td>
            <form class="inline-form" action="/db/todos/{todo.id}/toggle" method="post" data-preserve-scroll="true">
              <input type="hidden" name="page" value="{page}" />
              <button type="submit" class="status-button">
                <span class="pill {'done' if todo.is_done else 'pending'}">{'DONE' if todo.is_done else 'TODO'}</span>
              </button>
            </form>
          </td>
          <td>{todo.created_at}</td>
          <td>{todo.updated_at}</td>
          <td class="row-actions">
            <form class="inline-form" action="/db/todos/{todo.id}/delete" method="post" data-preserve-scroll="true">
              <input type="hidden" name="page" value="{page}" />
              <button type="submit" class="button danger">삭제</button>
            </form>
          </td>
        </tr>
        """
        for todo in todos
    )
    if not rows:
        rows = '<tr><td colspan="7"><div class="empty">아직 저장된 Todo가 없습니다. 아래 폼에서 바로 추가해보세요.</div></td></tr>'

    start_item = offset + 1 if total else 0
    end_item = offset + len(todos)
    prev_link = f"/db?page={page - 1}" if page > 1 else "#"
    next_link = f"/db?page={page + 1}" if page < total_pages else "#"
    prev_class = "pager-link" if page > 1 else "pager-link disabled"
    next_class = "pager-link" if page < total_pages else "pager-link disabled"

    schema_rows = "".join(
        f"""
        <tr>
          <td>{column[1]}</td>
          <td>{column[2]}</td>
          <td>{'YES' if column[3] == 0 else 'NO'}</td>
          <td>{'PK' if column[5] else '-'}</td>
        </tr>
        """
        for column in columns
    )

    content = f"""
    <section class="hero">
      <h1>Database Dashboard</h1>
      <p>SQLite 파일과 Todo 테이블 상태를 빠르게 확인할 수 있는 현황판입니다.</p>
      <div class="nav">
        <a href="/swagger">Swagger</a>
        <a href="/api/todos" class="secondary">Todos JSON</a>
        <a href="/" class="secondary">Home</a>
      </div>
    </section>
    <section class="grid">
      <article class="card">
        <h3>Total Todos</h3>
        <p style="font-size:2rem; margin:0;">{total}</p>
      </article>
      <article class="card">
        <h3>Completed</h3>
        <p style="font-size:2rem; margin:0;">{done}</p>
      </article>
      <article class="card">
        <h3>Pending</h3>
        <p style="font-size:2rem; margin:0;">{pending}</p>
      </article>
      <article class="card">
        <h3>SQLite File</h3>
        <p class="muted"><code>{escape(str(DB_PATH.relative_to(BASE_DIR)))}</code></p>
      </article>
    </section>
    <section class="stack">
      <article class="card">
        <h2>Add Todo</h2>
        <form action="/db/todos" method="post" data-preserve-scroll="true">
          <input type="hidden" name="page" value="{page}" />
          <div class="form-grid">
            <label>
              Title
              <input type="text" name="title" maxlength="120" placeholder="예: API 응답 구조 정리" required />
            </label>
            <label>
              Description
              <textarea name="description" maxlength="1000" placeholder="메모를 적어둘 수 있습니다."></textarea>
            </label>
            <div class="form-actions">
              <label class="checkbox">
                <input type="checkbox" name="is_done" value="true" />
                완료 상태로 추가
              </label>
              <button type="submit" class="button primary">추가</button>
            </div>
          </div>
        </form>
      </article>
      <article class="card">
        <h2>Table Schema</h2>
        <table>
          <thead>
            <tr>
              <th>Column</th>
              <th>Type</th>
              <th>Nullable</th>
              <th>Key</th>
            </tr>
          </thead>
          <tbody>{schema_rows}</tbody>
        </table>
      </article>
      <article class="card">
        <h2>Todos</h2>
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Title</th>
              <th>Description</th>
              <th>Status</th>
              <th>Created</th>
              <th>Updated</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>{rows}</tbody>
        </table>
        <div class="pager">
          <div class="pager-info">Showing {start_item}-{end_item} of {total} · Page {page} / {total_pages}</div>
          <div class="pager-nav">
            <a href="{prev_link}" class="{prev_class}">이전</a>
            <a href="{next_link}" class="{next_class}">다음</a>
          </div>
        </div>
      </article>
    </section>
    """
    return layout("Database Dashboard", content)


@app.get("/docs", include_in_schema=False)
def docs_redirect():
    return RedirectResponse(url="/swagger")
