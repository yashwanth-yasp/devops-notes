---
date: 2025-08-28
tags:
  - ust
  - devops
  - docker
  - kubernetes
  - project
  - architecture
  - microservices
---

![[Pasted image 20250828175853.png]]

- **vote (Python/Flask)**: The user interacts with a web page served by Flask. When they click a vote button, the browser sends a POST request to the Flask server, which then pushes a JSON object containing the vote data into a list in Redis.
- **worker (.NET)**: This service runs in a continuous loop, constantly trying to pop data from the Redis list. As soon as a vote appears, the worker takes it, processes it, and writes it to the **PostgreSQL** database. This is the component that makes the vote persistent.
- **result (Node.js/ Express + Socket.IO)**: This service polls the PostgreSQL database at a regular interval (e.g., every second). If it detects any changes or fetches new data, it uses Socket.IO to push the updated results to all connected web clients in real-time, which updates the live vote table.
- **ai-analyzer (Python/Flask + Boto3)**: You are perfectly correct. The "Get AI Analysis" button on the result page triggers a direct HTTP request to the ai-analyzer service. This service then runs its own query against the PostgreSQL database, formats the data into a prompt, uses the Boto3 library to send it to AWS Bedrock, and returns the AI-generated analysis.


