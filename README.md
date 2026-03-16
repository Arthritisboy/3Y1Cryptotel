# Cryptotel — Hotel Reservation + Crypto Payments 🏨💰

**Technologies:** Dart, Flutter, Node.js, Express, MongoDB, MetaMask / Web3 modal

A modern hotel reservation platform that enables seamless bookings with secure cryptocurrency payments for fast, private, and global access.

---

## Team 👥

![Team Photo](./assets/team-photo.png)

| Name | Role |
|------|------|
| Ang, Jaydeebryann | Full-Stack |
| Flores, Lance Kian F. | Full-Stack |
| Reyes, Christer Dale M. | Backend Developer |
| Centino, Jem Harold S. | UI Designer |
| Borje, Janylle A. | Front-end |


## Project structure 🗂️

* `/mobile` — Flutter mobile app (BLoC pattern, web3 modal integration).
* `/api` — Node.js + Express backend (MongoDB models, REST APIs).

## Features ✨

* Browse and book hotel rooms with images and availability
* Secure crypto payments (wallet connect / MetaMask via Web3 modal)
* User authentication (JWT)
* Image upload and management
* Real-time or near-real-time booking confirmation
* Admin endpoints for managing rooms and bookings

## Quick start 🚀

### Prerequisites

* Node.js (v16+ recommended)
* npm or yarn
* Flutter SDK
* MongoDB (local or Atlas)
* A crypto wallet (MetaMask or any WalletConnect-compatible wallet) for testing payments

### Backend (API)

```bash
# from repo root
cd api
npm install
# create an .env file with required variables (example below)
npm run start
```

**Recommended .env variables** (create `api/.env`):

```
MONGO_URI=<your_mongo_connection_string>
JWT_SECRET=<strong_jwt_secret>
CLOUDINARY_URL=<optional cloudinary url>
EMAIL_USER=<smtp user for nodemailer>
EMAIL_PASS=<smtp password>
PORT=5000
```

**Run in production**

```bash
# start with production env
npm run start:prod
```

### Mobile (Flutter)

```bash
cd mobile
flutter pub get
flutter run
```

Notes:

* The Flutter app uses `web3modal_flutter` (or similar) to connect wallets for crypto payments — test using MetaMask mobile/browser or any WalletConnect-compatible wallet.
* Project uses the BLoC pattern (`bloc` / `flutter_bloc`) and stores some secure data using `flutter_secure_storage`.

## Environment & Configuration

* Backend expects a running MongoDB instance and credentials configured in `api/.env`.
* Mobile app should point to the API base URL (update the API base constant in the app configuration or `.env` equivalent).

## Deployment

* The API contains a `vercel.json` and can be deployed to platforms like Vercel for serverless hosting (or to any Node hosting).
* The Flutter app can be built for Android/iOS or published to app stores.


