Laravel Backend on EC2 with RDS
This repository contains the backend of a Laravel application deployed on an EC2 instance and connected to an Amazon RDS instance. It provides the necessary setup instructions and configuration details for getting the environment up and running.

Prerequisites
Amazon EC2 Instance running a supported version of Linux (e.g., Ubuntu 20.04).
Amazon RDS Instance running MySQL, PostgreSQL, or another supported database.
Composer for managing Laravel dependencies.
PHP (version 8.x or higher).
Nginx for serving the application.
Git for version control.
Setup Steps
1. Set up EC2 Instance
Launch an EC2 instance with an appropriate security group to allow HTTP (port 80), SSH (port 22), and any necessary database ports (e.g., 3306 for MySQL).

SSH into your EC2 instance:


ssh -i your-key.pem ec2-user@your-ec2-public-ip
2. Install Required Packages
Install PHP, Nginx, Composer, and other dependencies on the EC2 instance:


# Update the system
sudo apt update && sudo apt upgrade -y

# Install Nginx
sudo apt install nginx -y

# Install PHP (ensure the version matches Laravel's requirements)
sudo apt install php php-fpm php-mysql php-cli php-curl php-mbstring php-xml php-zip -y

# Install Composer globally
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Start Nginx and PHP-FPM services
sudo systemctl start nginx
sudo systemctl start php7.4-fpm
sudo systemctl enable nginx
sudo systemctl enable php7.4-fpm
3. Clone the Laravel Project
Clone the Laravel repository into the appropriate directory:


# Change to the directory where you want to install the Laravel project
cd /var/www

# Clone the repository
sudo git clone https://github.com/Maged2344/backend-app.git backend-app

# Change ownership to the web server user
sudo chown -R www-data:www-data laravel-app
4. Install Laravel Dependencies
Install the necessary Laravel dependencies using Composer:



cd /var/www/laravel-app

# Install Composer dependencies
composer install

# Set the proper permissions
sudo chmod -R 775 storage bootstrap/cache
5. Configure Environment
Create a .env file in the project root, if it doesn’t already exist:


cp .env.example .env
Edit the .env file and configure the database connection to use the RDS instance:




sudo ln -s /etc/nginx/sites-available/laravel /etc/nginx/sites-enabled/
7. Test Nginx Configuration and Restart
Test the Nginx configuration for syntax errors:


sudo nginx -t
If the test passes, reload Nginx to apply the changes:


sudo systemctl restart nginx
8. Migrate the Database
Run the Laravel database migrations to set up the database schema:


php artisan migrate
9. Access the Application
Once the application is set up, you should be able to access it via the EC2 instance’s public IP or a domain name pointing to the EC2 instance.

In a browser, navigate to:

http://44.204.61.67/

You should see your Laravel application running.

10. Enable Nginx to Start on Boot
To ensure Nginx starts automatically after reboot:

sudo systemctl enable nginx
![image](https://github.com/user-attachments/assets/c553254a-7117-4ed2-8a4b-6678180566b6)
![image](https://github.com/user-attachments/assets/d1099d65-6e5e-4885-8bdb-e3c9a403d272)
