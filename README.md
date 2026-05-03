# Week 12: Payment Integration & E-commerce

This repository contains four Flutter projects focused on modern commerce application development. The projects cover payment gateway integration, shopping cart workflows, order management, and product review systems using Flutter, Firebase, Provider, and Stripe.

## Repository Structure

```text
Week_12/
├── payment_app/
├── ecommerce_cart_app/
├── order_management_app/
└── reviews_app/
````

---

# Projects Included

## 1. payment_app

A Flutter payment application integrated with Stripe for secure card transactions.

### Features

* Stripe account integration with API keys
* Stripe SDK initialization
* Payment Sheet implementation
* Create Payment Intent from backend
* Card payment handling
* Payment success and failure handling
* Confirmation dialog after payment
* Store transaction records in Firestore
* Stripe test card support

### Core Technologies

* Flutter
* Provider
* Firebase Core
* Cloud Firestore
* Stripe (`flutter_stripe`)

### Learning Outcomes

* Payment gateway integration
* Secure transaction flow
* Backend communication for payment intents
* Cloud database transaction logging

---

## 2. ecommerce_cart_app

A complete shopping cart and checkout flow application.

### Features

* Add products to cart
* Quantity increment / decrement
* Dynamic subtotal calculation
* Tax calculation (10%)
* Shipping fee logic
* Discount code validation
* Multi-step checkout flow:

```text
Cart -> Address -> Payment -> Confirmation
```

* Order placement
* Auto clear cart after successful order

### Core Technologies

* Flutter
* Provider

### Learning Outcomes

* State management for cart systems
* Real-time pricing calculations
* Multi-screen checkout flow
* E-commerce UX patterns

---

## 3. order_management_app

An order tracking system for managing customer purchases.

### Features

* Order history display
* Firestore order storage
* Order status tracking:

```text
Pending
Processing
Shipped
Delivered
```

* Order details page
* Delivery address and item summary
* Cancel order with status rules
* Order stepper UI
* Pull-to-refresh orders list
* Confirmation emails via Cloud Functions

### Core Technologies

* Flutter
* Firebase Firestore
* Firebase Cloud Functions
* Provider

### Learning Outcomes

* Real-world order lifecycle management
* Backend-triggered email notifications
* Stateful status UI design

---

## 4. reviews_app

A product reviews and ratings system.

### Features

* Star rating widget
* Review submission form
* Comment system
* Average rating calculation
* Review list display
* Helpful vote counter
* Sort reviews by:

```text
Recent
Helpful
High Rating
Low Rating
```

* Filter by star ratings

### Core Technologies

* Flutter
* Firebase Firestore

### Learning Outcomes

* User-generated content systems
* Rating aggregation logic
* Sorting and filtering implementation

---

# Tech Stack

## Frontend

* Flutter
* Dart

## State Management

* Provider

## Backend Services

* Firebase Core
* Cloud Firestore
* Firebase Cloud Functions

## Payment Gateway

* Stripe

---

# Installation

## Prerequisites

* Flutter SDK
* Android Studio / VS Code
* Firebase CLI
* FlutterFire CLI
* Stripe Developer Account

## Clone Repository

```bash
git clone https://github.com/your-username/week12-payment-ecommerce.git
cd week12-payment-ecommerce
```

## Install Dependencies

```bash
flutter pub get
```

## Run Any Project

```bash
cd payment_app
flutter run
```

Replace folder name with:

```text
ecommerce_cart_app
order_management_app
reviews_app
```

---

# Firebase Setup

For Firebase-based projects:

```bash
flutterfire configure
```

Ensure `firebase_options.dart` is generated.

---

# Stripe Setup

Inside `payment_app`:

1. Create Stripe account
2. Get publishable key
3. Replace key in `main.dart`

```dart
Stripe.publishableKey = "your_publishable_key";
```

4. Configure backend for Payment Intent API

---

# Educational Objectives

These projects demonstrate practical implementation of:

* Payment systems
* Cart architecture
* Checkout workflow
* Order lifecycle tracking
* Reviews and ratings systems
* Firebase integration
* Provider state management
* Scalable Flutter architecture

---

# Author

Developed as part of Week 12 coursework on Payment Integration & E-commerce using Flutter.

---

# License

This project is for educational and learning purposes.

```
```
