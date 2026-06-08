# Golem Provider Node - Docker Installation

A robust, interactive, and automated setup to run a [Golem Network](https://golem.network/) Provider Node using Docker and Make.

Unlike headless automated scripts that often fail due to unexpected interactive prompts, this architecture acts as an orchestrator. It prepares the containerized environment and hands the terminal control over to the user for critical steps (like accepting Terms of Service and generating wallet keys), ensuring a secure and fail-proof installation.

## 🏗️ Architecture Features
* **Interactivity First:** Prevents "EOF" or "Bad file descriptor" errors by gracefully pausing the automation so the user can interact with the official Golem CLI.
* **Wallet Security:** The node's identity, cache, and ERC-20 wallet keys are mapped securely to the host machine's SSD (`./golem-data`), preventing data loss during container restarts.
* **Resource Optimization:** Pre-configured constraints tailored for high-performance processors (e.g., Xeon), including `/dev/kvm` mapping for native virtualization speeds.

## 📋 Prerequisites
Before you begin, ensure your host machine (Linux, macOS, or Windows with WSL2) has the following installed:
* [Docker](https://docs.docker.com/get-docker/)
* [Docker Compose](https://docs.docker.com/compose/install/)
* [GNU Make](https://www.gnu.org/software/make/)

## 🚀 Installation

1. Clone this repository to your local machine:
```bash
   git clone [https://github.com/your-username/golem-node-docker.git](https://github.com/your-username/golem-node-docker.git)
   cd golem-node-docker

```

2. Run the main installation pipeline:
```bash
make install

```


*Note: During the installation, the script will pause twice. You must interact with the terminal to accept the Terms of Service, define your node name, and configure your ERC-20 wallet. Simply type `exit` when prompted to resume the automation.*

## ⚙️ Management Commands

Once installed, you can manage your Golem Node using the following `make` commands:

| Command | Description |
| --- | --- |
| `make up` | Starts the Golem Provider Node in the background. |
| `make down` | Safely stops the Node without deleting your data. |
| `make status` | Displays the current node status, wallet balance, and tasks. |
| `make logs` | Tails the live Docker logs for the running node. |
| `make uninstall` | **WARNING:** Completely stops the node, deletes the Docker images, and wipes your local node identity and wallet configurations. |

## 🛣️ Roadmap

* [x] Dockerfile & Volume persistence mapping
* [x] Makefile pipeline orchestration
* [ ] Windows native compatibility installer
* [ ] Desktop Watchdog & Dashboard UI

## 📄 License

This project is licensed under the MIT License.
