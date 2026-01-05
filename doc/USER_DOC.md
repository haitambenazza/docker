# WordPress User Documentation

## Overview

This project includes a WordPress instance running in Docker. WordPress is a popular open-source content management system (CMS) that allows you to create, manage, and publish content easily.

## Accessing WordPress

### Admin Dashboard
1. Navigate to `https://hbenazza.42.fr/wp-admin`
2. Log in with your admin credentials
3. You'll have access to the WordPress dashboard to manage your site

### Front-end Website
Visit `https://hbenazza.42.fr` to see your public WordPress site

## Basic Operations

### Creating Posts
1. In the Admin Dashboard, go to **Posts** → **Add New**
2. Enter your post title
3. Write your content in the editor
4. Set categories and tags as needed
5. Click **Publish** to make it live

### Creating Pages
1. Go to **Pages** → **Add New**
2. Enter your page title and content
3. Configure page settings (parent page, template, etc.)
4. Click **Publish**

### Managing Content
- **Edit**: Hover over any post/page and click **Edit** to modify
- **Delete**: Click **Delete** to remove content
- **Categories**: Organize posts by categories
- **Tags**: Add tags to posts for better organization

### Media Management
1. Go to **Media** → **Library** to manage images and files
2. Upload new media via **Media** → **Add New**
3. Insert media into posts/pages using the editor

### Managing Users
1. Navigate to **Users** to view all users
2. Click **Add New** to create additional user accounts
3. Set user roles (Administrator, Editor, Author, Contributor, Subscriber)
4. Each role has different permission levels

## Site Settings

### General Settings
- **Site Title**: Your website name
- **Tagline**: Your site's motto
- **WordPress Address & Site Address**: URLs for your site
- **Timezone**: Set your local timezone

Access via **Settings** → **General**

### Appearance
- **Themes**: Choose and customize your site's look
- **Widgets**: Add widgets to sidebars
- **Menus**: Create and manage navigation menus

## Plugins

Plugins extend WordPress functionality. To manage plugins:
1. Go to **Plugins** in the admin menu
2. Activate/deactivate plugins as needed
3. Use **Add New** to search and install plugins

## Troubleshooting

### Can't Access WordPress
- Ensure the container is running: `docker-compose up`
- Check your internet connection
- Verify the domain in your hosts file

### Posts Not Showing
- Check if posts are published (not in draft)
- Verify categories and tags are assigned
- Clear your browser cache

### Slow Performance
- Check available server resources
- Optimize images before uploading
- Disable unused plugins

## Important Notes

- Always keep WordPress and plugins updated
- Regularly backup your content
- Use strong passwords for user accounts
- Be cautious with admin account permissions

## Support

For more information about WordPress, visit the official documentation:
- [WordPress.org](https://wordpress.org)
- [WordPress Support](https://wordpress.org/support/)
