from __future__ import annotations

import sys

from .database import Base, engine, SessionLocal
from .models import Todo


def build_todo(index: int) -> Todo:
    return Todo(
        title=f"Mock Todo {index}",
        description=f"자동 생성된 샘플 Todo #{index}",
        is_done=index % 3 == 0,
    )


def parse_count(argv: list[str]) -> int:
    if len(argv) < 2:
        return 10

    raw = argv[1].strip()
    if not raw.isdigit():
        raise ValueError("count must be a positive integer")

    count = int(raw)
    if count < 1:
        raise ValueError("count must be at least 1")
    return count


def main() -> int:
    try:
        count = parse_count(sys.argv)
    except ValueError as exc:
        print(f"error: {exc}")
        return 1

    Base.metadata.create_all(bind=engine)

    db = SessionLocal()
    try:
        todos = [build_todo(index) for index in range(1, count + 1)]
        db.add_all(todos)
        db.commit()
    finally:
        db.close()

    print(f"Inserted {count} mock todos")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
