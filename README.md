

🧾 Full README.md

# 🚀 Anroot (CrossLinux)

<p align="center">
  <img src="https://img.shields.io/badge/CrossLinux-Anroot-blue?style=for-the-badge">
  <img src="https://img.shields.io/badge/Platform-Termux%20%7C%20Android-green?style=for-the-badge">
  <img src="https://img.shields.io/badge/Installer-One--Line-orange?style=for-the-badge">
</p>

---

## 📌 About

**Anroot** is a simple and fast Linux environment installer for Android (Termux).  
It allows you to install and run Ubuntu with GUI support using a single command.

Powered by **CrossLinux**.

---

## ✨ Features

- ⚡ One-line installation
- 🐧 Ubuntu (Jammy XFCE) support
- 🖥️ GUI via VNC server
- 📦 Automatic dependency setup
- 🎨 Custom logo (figlet + lolcat)
- 🔧 Auto fix for common Termux errors
- 🚀 Beginner friendly

---

## ⚡ Installation

### 🔹 One-line install (Recommended)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/crossberry-in/anroot/refs/heads/main/setup.sh)
```

---

🔹 Alternative (wget)
```bash
wget -qO- https://raw.githubusercontent.com/crossberry-in/anroot/refs/heads/main/setup.sh | bash

```
---

▶️ Usage

🔐 Login to Ubuntu

udroid login jammy:xfce4

🖥️ Start GUI Desktop

vncserver :1


---

🔑 Default Credentials

Password: secret



---

📱 Requirements

📦 Termux (latest version)

💾 Minimum 4GB free storage

🌐 Stable internet connection

📲 Android 8+ recommended



---

🌐 Official Website

👉 https://crossberry.vercel.app


---

🛠️ Troubleshooting

❌ curl error / SSL issue

termux-change-repo
apt update && apt full-upgrade -y
pkg reinstall curl openssl libngtcp2 -y


---

❌ Permission denied

chmod +x setup.sh


---

❤️ Support

If you like this project:

⭐ Star this repository

🔗 Share with friends

💡 Contribute improvements



---

🤝 Contributing

Pull requests are welcome.
For major changes, open an issue first to discuss.


---

📄 License

This project is licensed under the MIT License.


---

👨‍💻 Author

CrossLinux Team


---

🚀 Future Plans

Custom CrossLinux command (crosslinux)

GUI launcher app (APK)

More distro support

Auto updates system



---

<p align="center">
  Made with ❤️ by CrossLinux
</p>
```
---
