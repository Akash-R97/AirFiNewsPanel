# AirFi News Panel 📰 (iOS Assignment)

This iOS application simulates the AirFi News Panel — a secure internal platform for managing article submissions and approvals. Built using Swift, Core Data, and MVVM, it emphasizes clean architecture, offline-first capabilities, and professional UI practices.

---

## ✨ Features

- 🔒 **Login Flow** for `Author` and `Reviewer` roles
- ✍️ **Author Panel** to:
  - View your own articles
  - Sync articles to server (mocked)
- ✅ **Reviewer Panel** to:
  - View unapproved articles grouped by author
  - Select & approve articles
  - Persist approval state locally
- 🔁 **Offline-First** Design
  - All data stored in Core Data
  - No external APIs or backend — purely mock-driven
- 🔃 **Pagination** on Reviewer side for performance
- 📱 Fully adaptive UI built with UIKit and AutoLayout

---

## 🛠 Architecture

- **MVVM** with Service + Repository layers
- **Core Data** for persistent local storage
- **MockAPIService** to simulate network sync
- **AutoSyncManager** to sync data only when local changes exist

---

## 📂 Project Structure

```
AirFiNewsPanel/
│
├── Models/
│   ├── ArticleMetadata
│   └── ArticleDetail
│
├── DTOs/
│   ├── ArticleMetadataDTO.swift
│   └── ArticleDetailDTO.swift
│
├── Services/
│   └── MockAPIService.swift
│
├── Repository/
│   └── ArticleRepository.swift
│
├── ViewModels/
│   ├── AuthorNewsViewModel.swift
│   └── ReviewerNewsViewModel.swift
│
├── Views/
│   ├── AuthorNewsViewController.swift
│   ├── ReviewerNewsViewController.swift
│   └── ReviewerNewsTableViewCell.swift
```

---

## 🧪 Testing Guidelines

- ✅ Verify login and role-based redirection
- ✅ Test Author sync functionality
- ✅ Scroll and approve articles as Reviewer
- ✅ Ensure state persists across app launches
- ✅ Check pagination & UI rendering for large datasets

---

## 🚀 Getting Started

1. Clone the repo  
   ```bash
   git clone https://github.com/your-username/AirFiNewsPanel.git
   ```

2. Open in **Xcode 15+**

3. Run on simulator or device

---

## 📌 Notes

- Only articles with new local changes are synced.
- Approved articles are filtered out per reviewer’s name.
- `approvedBy` is stored as `[String]` in Core Data using a value transformer.

---

## 👨‍💻 Author

Akash Razdan  
[LinkedIn](https://www.linkedin.com/in/akashrazdan) • iOS Developer

---

## 🧠 About This Repo

This project was built as part of a professional take-home assignment for AirFi. It follows industry practices in architecture, code quality, and design. Structured to support discussion in interviews and system design rounds.
