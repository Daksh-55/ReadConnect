# 📚 ReadConnect

ReadConnect is a smart and simple library management app designed to connect readers with local libraries. It helps readers easily find, request, and borrow books while allowing librarians to efficiently manage approvals, pickups, and returns.

Youtube - https://www.youtube.com/watch?v=x0_nnMgpraY
---

## 🚀 Features

### For Readers
- 🔍 Search for books in the library.
- 📊 Check real-time availability.
- 📥 Request books for borrowing.
- ⏳ Borrow for 7 days after pickup.
- 🔔 Get notified when books are ready for pickup.

### For Librarians
- ✅ Approve or reject book requests.
- 📦 Mark books as "Ready to Pick Up".
- 📅 Track pickup and return dates.
- ♻ Manage availability counts automatically.
- ⚠ Handle overdue returns (optional).

---

## 🛠 Tech Stack
- **Frontend:** Flutter
- **Backend:** Supabase (PostgreSQL + Auth + Storage)
- **Database:** Supabase PostgreSQL
- **Authentication:** Supabase Auth

---

## 📂 Database Schema (Supabase Example)

### `books` Table
| Column           | Type      | Description                         |
|------------------|-----------|-------------------------------------|
| id               | uuid      | Primary key                         |
| title            | text      | Book title                          |
| author           | text      | Book author                         |
| total_copies     | int       | Total copies in library             |
| available_copies | int       | Currently available copies          |

### `users` Table
| Column     | Type   | Description               |
|------------|--------|---------------------------|
| id         | uuid   | Primary key (linked to auth.users) |
| name       | text   | User's name               |
| role       | text   | `reader` or `librarian`   |

### `requests` Table
| Column       | Type      | Description                              |
|--------------|-----------|------------------------------------------|
| id           | uuid      | Primary key                              |
| user_id      | uuid      | ID of the requesting reader              |
| book_id      | uuid      | ID of the requested book                 |
| status       | text      | `pending`, `approved`, `picked_up`, `returned`, `overdue` |
| request_date | timestamp | Date of request                          |
| pickup_date  | timestamp | Date of pickup                           |
| return_date  | timestamp | Date of return                           |

---

## 🔄 Borrowing Flow
1. Reader searches for a book.
2. If available → Reader sends a request.
3. Librarian approves request → Book is "Ready to Pick Up".
4. Reader picks up book → Borrow period starts (7 days).
5. Reader returns book → Librarian marks as returned and count increases.

---

## 📌 Future Improvements
- 📲 Push notifications for due dates.
- 🏷 Fine calculation for overdue books.
- 📖 eBook availability integration.
- 🌍 Multi-library support.

---

## 📜 License
This project is licensed under the MIT License.
