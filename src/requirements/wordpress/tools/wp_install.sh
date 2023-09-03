#!/bin/sh

#This line checks if the wp-config.php file does not exist in the current directory. 
 #If it doesn't exist, the script proceeds with WordPress installation and configuration. If the file already exists, 
 #it assumes that WordPress is already set up and does nothing.
if [ ! -e wp-config.php ]; then

    #changes the ownership of the /var/www/ directory and its contents to the www-data user and group. 
     #This is typically done to ensure that the web server process (often running as www-data) has the necessary permissions 
     #to write and manage files within the web root directory.
    chown -R www-data:www-data /var/www/

    #downloads WordPress core files
    sudo -u www-data sh -c "wp core download"

    #Generates a wp-config.php configuration file with database connection details, such as the database name, username, 
     #password, host, and character set.
    sudo -u www-data sh -c "wp config create --dbname=$WORDPRESS_DB_NAME --dbuser=$WORDPRESS_DB_USER --dbpass=$WORDPRESS_DB_PASSWORD --dbhost=$WORDPRESS_DB_HOST --dbcharset='utf8'"

    #Installs WordPress with specified settings, including the site URL, site title, admin user details (username, password, 
     #email), and skips sending email notifications during the installation.
    sudo -u www-data sh -c "wp core install --url=$WORDPRESS_URL --title=Inception --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL --skip-email"
 
    #Creates a user with author role. This line appears to create a guest user with the specified username, email, and password.
    sudo -u www-data sh -c "wp user create $WORDPRESS_GUEST_USER $WORDPRESS_GUEST_EMAIL --role=author --user_pass=$WORDPRESS_GUEST_PASSWORD"
    
    #Updates all WordPress plugins.
    sudo -u www-data sh -c "wp plugin update --all"
fi

#This line creates a symbolic link (ln -s) to the PHP-FPM binary (php-fpm) from the /usr/sbin/ directory and places it in the 
 #/usr/bin/ directory. This is typically done to ensure that the php-fpm command can be executed from the command line without 
 #specifying its full path.
ln -s $(find /usr/sbin -name 'php-fpm*') /usr/bin/php-fpm

#Finally, this line executes the PHP-FPM server (php-fpm) with the -F flag, which tells PHP-FPM to run in the foreground. 
 #This is a common way to start the PHP-FPM process and keep it running to handle PHP requests for the web server.
exec /usr/bin/php-fpm -F