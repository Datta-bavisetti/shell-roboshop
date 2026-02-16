# RoboShop

RoboShop is a **cloud‑native microservices-based e‑commerce application** deployed on **AWS**.
This project focuses on **automating the end‑to‑end setup** of the complete RoboShop stack using **Shell Scripts**, following DevOps best practices.

The architecture consists of a frontend, multiple backend microservices, and polyglot persistence (multiple databases), all provisioned and configured automatically.

---

## Architecture Overview

RoboShop follows a **microservices architecture** where each service has a clear responsibility:

### Frontend

* Acts as the entry point for users (browser-based UI)
* Communicates with backend services via REST APIs

### Backend Microservices

* **Catalogue** – Manages product information
* **User** – Handles user authentication and profiles
* **Cart** – Manages shopping cart data
* **Shipping** – Calculates shipping and order fulfillment
* **Payment** – Handles payment processing and triggers dispatch events

### Databases & Messaging

* **MongoDB** – Used by Catalogue and User services
* **Redis** – Used by Cart service for fast in-memory operations
* **MySQL** – Used by Shipping service for relational data
* **RabbitMQ** – Message broker used by Payment service to communicate with Dispatch

### Dispatch Service

* Consumes messages from RabbitMQ
* Handles order dispatch asynchronously

---

## Automation Scope

All components are **installed, configured, and started automatically** using **Shell Scripts**.

Automation includes:

* OS-level package installation
* Repository configuration
* Service installation and configuration
* Systemd service setup
* Logging and error handling

This eliminates manual intervention and ensures **repeatable, reliable deployments**.

---

## Tech Stack

* **Cloud**: AWS (EC2)
* **Automation**: Shell Scripting (Bash)
* **Application Architecture**: Microservices
* **Databases**: MongoDB, MySQL, Redis
* **Message Queue**: RabbitMQ
* **Frontend**: Web UI (Nginx-based)
* **Backend**: Polyglot services
  
---

## Learning Outcomes

* Hands-on experience with microservices deployment
* Strong understanding of polyglot persistence
* Shell scripting for real-world DevOps automation
* AWS infrastructure familiarity
