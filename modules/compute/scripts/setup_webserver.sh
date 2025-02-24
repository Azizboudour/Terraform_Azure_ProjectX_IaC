#!/bin/bash

# Update package index
apt-get update

# Install necessary packages
apt-get install -y nginx

# Format and mount the data disk
DISK_PATH="/dev/disk/azure/scsi1/lun10"
MOUNT_POINT="/var/www/html"

# Check if disk exists
if [ -e $DISK_PATH ]; then
    # Check if disk is already partitioned
    if ! lsblk $DISK_PATH-part1 > /dev/null 2>&1; then
        # Create a partition
        echo "Creating partition on $DISK_PATH"
        echo -e "n\np\n1\n\n\nw" | fdisk $DISK_PATH
    fi
    
    # Format the partition if not already formatted
    if ! blkid "$DISK_PATH-part1" > /dev/null 2>&1; then
        echo "Formatting partition"
        mkfs.ext4 "$DISK_PATH-part1"
    fi
    
    # Create mount point directory if it doesn't exist
    mkdir -p $MOUNT_POINT
    
    # Backup the original content
    cp -r /var/www/html/* /tmp/ || true
    
    # Add to fstab for persistence across reboots
    if ! grep -q "$DISK_PATH-part1" /etc/fstab; then
        echo "$DISK_PATH-part1 $MOUNT_POINT ext4 defaults,nofail 0 2" >> /etc/fstab
        mount -a
    fi
    
    # Copy backed up content to the new disk
    cp -r /tmp/* $MOUNT_POINT/ || true
    
    # Set proper permissions
    chown -R www-data:www-data $MOUNT_POINT
fi

# Create a simple welcome page
cat > $MOUNT_POINT/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>ProjectX Demo Site</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f5f5f5;
            color: #333;
        }
        .container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            max-width: 800px;
            margin: 0 auto;
        }
        h1 {
            color: #0066cc;
        }
        .info {
            background-color: #e9f7fe;
            border-left: 4px solid #0066cc;
            padding: 15px;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to ProjectX!</h1>
        <div class="info">
            <p>This server was deployed using Terraform and Azure.</p>
            <p>Server hostname: $(hostname)</p>
            <p>Server IP: $(hostname -I | awk '{print $1}')</p>
        </div>
        <p>Infrastructure as Code (IaC) deployment successful!</p>
    </div>
</body>
</html>
EOF

# Restart Nginx
systemctl restart nginx

# Enable Nginx to start at boot
systemctl enable nginx

echo "Web server setup complete!"