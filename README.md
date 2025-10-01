

```markdown
# 🏃 Step Tracker Full System  

A complete system consisting of:  
1. **Mobile Application** (Flutter) – tracks steps locally and syncs with the backend.  
2. **Backend API** (Node.js + MongoDB) – stores and retrieves step data.  
3. **Web Application** (Next.js/React) – displays and analyzes step data.  

---

## 📂 Project Structure




## ⚙️ Backend Setup & Deployment  

### 1. Prerequisites
- Node.js & npm installed ([Download Node.js](https://nodejs.org/en/download))  
- MongoDB account ([MongoDB Atlas](https://www.mongodb.com/))  
- Render account ([Render](https://render.com/))  
- GitHub account (to host backend code)  

### 2. Local Setup
```bash
cd backend
npm install
````

Create a `.env` file in the backend folder:

```env
MONGODB_URI=your_mongodb_connection_uri
```

Run the backend locally:

```bash
npm run dev
```

### 3. Deploy to Render

1. Push your backend code to GitHub.
2. Go to [Render Dashboard](https://render.com/).
3. Create a **New Web Service** → connect GitHub repo.
4. Add environment variables (Settings → Environment):

   * `MONGODB_URI=your_mongodb_connection_uri`
5. Deploy.
6. You’ll get a live API endpoint, e.g.:

   ```
   https://steps-tracker-1.onrender.com
   ```

✅ Backend supports:

* `POST /steps` → Save step data
* `GET /steps` → Retrieve step data

---

## 🌐 Web Application Setup & Deployment

### 1. Local Setup

```bash
cd webapp
npm install
npm run dev
```

Runs locally at: [http://localhost:3000](http://localhost:3000)

### 2. Deploy to Vercel

1. Push code to GitHub.
2. Go to [Vercel](https://vercel.com/).
3. Connect GitHub → Import Repository.
4. Deploy → Vercel provides a live link.

---

## 📱 Mobile Application (Flutter)

This app reads step counter data, stores it locally, and syncs with the backend.

### 1. Prerequisites

* Windows PC/Laptop
* Git ([Download](https://git-scm.com/downloads))
* Flutter SDK ([Install Flutter](https://docs.flutter.dev/get-started/install/windows))
* Android Studio ([Download](https://developer.android.com/studio))
* VS Code (Optional, recommended with **Flutter** & **Dart** extensions)
* A USB cable + Android device

### 2. Environment Setup

* Install **Flutter SDK** to `C:\src\flutter` (avoid `Program Files`).
* Add `C:\src\flutter\bin` to **System PATH**.
* Run:

  ```bash
  flutter doctor
  ```

  Fix any missing dependencies.

### 3. Configure Phone

* Enable **Developer Options**: Tap *Build Number* 7 times.
* Enable **USB Debugging** (Settings → Developer Options).

### 4. Run Mobile App

```bash
cd mobile
flutter pub get
flutter run
```

* Select your device.
* The app installs and runs automatically.

⚠️ **Note for iOS Users**: Building for iPhone requires macOS and Xcode. Windows cannot directly build/run on iOS.

---

## 📦 Dependencies & Libraries

### Backend

* Express.js
* Mongoose (MongoDB ODM)
* dotenv (env variables)

### Web App

* Next.js / React
* Tailwind CSS
* Axios (for API calls)

### Mobile App

* Flutter
* pedometer package
* http package

---

## 🏗️ Design Choices

* **Flutter** for cross-platform mobile support.
* **Node.js + MongoDB** for a simple, scalable backend.
* **Next.js** for SEO-friendly, fast-loading web UI.
* **Cloud Deployment**: Render (backend) + Vercel (frontend) for free hosting and CI/CD integration.



* ## 📱 System Behavior & Data Flow  

### Mobile App (Flutter)  
- When you walk, the app **tracks your steps** using the pedometer sensor.  
- Every **6 minutes**:  
  - The total walked steps are **sent to the backend API**.  
  - The local step counter is **reset to 0**.  
  - The steps walked before reset are **added to the "last reset" segment**, so no steps are lost.  
- This ensures the backend receives **chunked 6-minute step records**, instead of a continuous running total.  

### Backend (Node.js + MongoDB)  
- Stores all incoming step data per user/session.  
- Exposes API endpoints:  
  - `POST /steps` → Save steps from mobile.  
  - `GET /steps` → Retrieve steps for visualization.  

### Web App (Next.js + Chart.js)  
- Fetches the latest steps data from the backend **every 2 minutes**.  
- Displays steps in a **line/bar chart** built with **Chart.js**.  
- The chart groups and divides steps **by days**, allowing daily comparisons.

## 🏗️ Why This Design?  

- **Chunked updates from mobile (every 6 min)** → prevents sending too many API requests and keeps data structured in small, meaningful intervals.  
- **Auto-refresh web app (every 2 min)** → provides near real-time visualization without manual refresh.  
- **Chart.js** → lightweight, flexible charting library perfect for daily step tracking and trends.  
- **Daily aggregation** → ensures users can easily see progress and patterns over multiple days.  


---



---

## 🚀 Demonstration

### Live Options:

* **Web App (Vercel link)** → [[Deployed site](https://step-tracker-full.vercel.app)]
* **Backend API (Render link)** → [[API endpoint](https://step-tracker-backend-1.onrender.com)/steps] Accepts Post and Get methods the payload example
```bash
  {
  "date": "2025-09-29",
  "steps": 1234
}
```

### Local Testing:

1. Run **backend** (`npm run dev`)
2. Run **webapp** (`npm run dev`)
3. Run **mobile** (`flutter run`)

---

✅ You now have a **full working system** (Mobile + Backend + Web).

## ⚠️ General Considerations  

- Due to **time limitations**, the mobile application may show some **instability** when running continuously.  
- The feature that **saves data locally** is still under development and may require additional time to finalize.  
- Current implementation focuses on **demonstrating the full workflow** (Mobile → Backend → Web App) rather than **complete production-level stability** as that requires more time.  
- Some behaviors may vary slightly depending on device model, Android version, or development environment.  



