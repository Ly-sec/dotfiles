
# Dotfiles

Welcome to my dotfiles repository! This repo contains the configuration files I use for my Linux setup, including custom configurations for **Hyprland**, **Waybar**, **Waypaper**, **Swaync**, **Rofi**, and more. It's optimized for both **aesthetic appeal** and **functionality**, ensuring a smooth and productive environment.

---

## 🚀 Setup Instructions

The `setup.sh` script will **create symlinks** from `~/dotfiles` to the corresponding configuration directories inside your `~/.config/` folder. It will also give you the option to back up any existing configuration directories before replacing them with the symlinks.


## 📄 Notes

- The `setup.sh` script will **create symlinks** from `~/dotfiles` to the corresponding configuration directories inside your `~/.config/` folder. It will also give you the option to back up any existing configuration directories before replacing them with the symlinks.

- If you want to add additional configurations, simply modify the files in `~/dotfiles/` and rerun the setup.

---

### Step-by-Step Setup

---

### **1. Clone the Repository**

First, clone the dotfiles repository to your home directory:

```bash
git clone https://github.com/Ly-sec/dotfiles.git ~/dotfiles
```

---

### **2. Run the Setup Script**

Navigate to the `~/dotfiles` directory and run the `setup.sh` script:

```bash
cd ~/dotfiles
./setup.sh
```

The `setup.sh` script will:
- **Move** your existing configuration folders (e.g., `~/.config/hypr`, `~/.config/waybar`, etc.) into the `~/dotfiles` folder if they exist.
- **Create symlinks** in your `~/.config/` directory that point to the corresponding folders in `~/dotfiles/`.

This way, you can easily manage and edit your config files from a centralized location.

---

### **3. Restart Services or Your System**

Once the script completes:
- Restart any relevant services (e.g., **Hyprland**, **Waybar**).
- You can also log out and log back in to see the changes.

Your system will now be set up with the dotfiles from this repository!

---

## 🛠️ Custom Configurations

This repository contains configurations for the following tools:

- **Hyprland**: My custom window manager setup.
- **Waybar**: Status bar with color-coordinated modules and a cyberpunk aesthetic.
- **Waypaper**: Wallpaper manager with automatic color theme syncing.
- **Swaync**: Notification daemon for consistent notifications.
- **Rofi**: Application launcher with a custom theme.

---

## 💡 Customization

Feel free to modify the configuration files to suit your own needs. If you make changes and want to share them, create a pull request, and I’ll be happy to review and merge!

---

## 🌱 Prerequisites

This setup assumes you're running a Linux-based OS and using tools like **Hyprland**, **Waybar**, and **Rofi**. You’ll need the following dependencies:

- **Hyprland**
- **Waybar**
- **Waypaper**
- **Swaync**
- **Rofi**
- **Pywal** (for automatic color generation from wallpapers)

---

## 🔧 Contributing

If you'd like to contribute to my dotfiles repository, feel free to fork it, make your changes, and open a pull request. Contributions are always welcome!

---

## 📝 License

This repository is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

---
