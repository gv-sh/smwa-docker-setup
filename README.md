# Social Media Web App - MERN Stack

This project is a full-stack social media web application built using the MERN stack (MongoDB, Express.js, React.js, and Node.js). It is containerized using Docker for easy deployment and management.

## Prerequisites

- Git

## Setup Instructions

1. Clone the repository:
   ```
   git clone https://github.com/gv-sh/smwa-docker-setup
   cd smwa-docker-setup
   ```

2. Make the run script executable:
   ```
   chmod +x run.sh
   ```

3. Run the project:
   ```
   ./run.sh
   ```
   This script will:
   - Install Docker and Docker Compose if they're not already installed
   - Generate a self-signed SSL certificate
   - Build and run the Docker containers

4. If Docker was just installed, log out and log back in for group changes to take effect, then run the script again.

5. Access the application:
   - Frontend: https://localhost
   - Mongo Express: http://localhost:8081

## EC2 Deployment

1. Launch an EC2 instance with Ubuntu 20.04 or later.

2. Clone the repository and follow the setup instructions above.

3. Configure EC2 security group:
   - Allow inbound traffic on ports 80 (HTTP), 443 (HTTPS), and 8081 (Mongo Express).

4. Update your domain's DNS settings to point to your EC2 instance's public IP (if using a domain).

5. Update the `nginx.conf` file:
   - Replace `localhost` with your EC2 instance's public IP or domain name.

6. Update the `docker-compose.yml` file:
   - Replace `REACT_APP_API_URL` with your EC2 instance's public IP or domain name.

7. Run the project again:
   ```
   ./run.sh
   ```

## Troubleshooting

- If you encounter any issues, check the Docker container logs:
  ```
  docker-compose logs
  ```

- To stop the project:
  ```
  docker-compose down
  ```

- To remove all containers and volumes:
  ```
  docker-compose down -v
  ```

- If you're having permission issues with Docker, try running the commands with `sudo`.
