# SoriaDora API & Script Documentation

SoriaDora is a two-way Lua execution and logging system designed to work with Roblox games. It retrieves scripts from a server, executes them, sends feedback, and logs game information at regular intervals.

This repository contains two main components:

1. **API Server (`index.js`)** – [View on GitHub](https://github.com/hacker123as/SoriaDora/blob/main/index.js)  
2. **Lua Client Script (`main.lua`)** – [View on GitHub](https://github.com/hacker123as/SoriaDora/blob/main/main.lua)

---

## How It Works

### Overview

1. **Script Execution**  
   The Lua client script fetches executable Lua code from the API server at `https://tuerss.com/api/executes/:username` every 2 seconds.
   
2. **Feedback Sending**  
   After executing the script, the Lua client sends feedback (success or failure) to the API server at `https://tuerss.com/api/executes/:username/feedback`.
   
3. **Game Logging**  
   Every 2 seconds, the Lua client also sends game information (game name, description, creator, etc.) to `https://tuerss.com/api/gamelog`.

---

## API Endpoints

### 1. **GET `/api/executes/:username`**

**Description:**  
Retrieves a Lua script for the given Roblox username. If no script is available, it returns `-- nothing here`.

**Response Examples:**

- If a script exists:
  ```lua
  print("Hello, world!")
  ```

- If no script exists:
  ```lua
  -- nothing here
  ```

---

### 2. **POST `/api/executes/:username`**

**Description:**  
Allows adding a Lua script for a specific Roblox username.

**Request Body Example:**

```json
{
  "script": "print('Hello from SoriaDora!')"
}
```

**Response Example:**

```json
{
  "success": true,
  "message": "Script added successfully"
}
```

---

### 3. **POST `/api/executes/:username/feedback`**

**Description:**  
Accepts feedback after script execution.

**Request Body Example:**

```json
{
  "message": "executed successfully"
}
```

**Response Example:**

```json
{
  "success": true,
  "message": "Feedback received"
}
```

---

### 4. **POST `/api/gamelog`**

**Description:**  
Logs game information such as game ID, name, description, creator, and player count.

**Request Body Example:**

```json
{
  "gameId": "123456789",
  "gameName": "Awesome Roblox Game",
  "description": "This is a fun Roblox game!",
  "creator": "JohnDoeDev",
  "playerCount": 12,
  "maxPlayers": 50
}
```

**Response Example:**

```json
{
  "success": true,
  "message": "Game log received"
}
```

---

## Files

### 1. **API Server (`index.js`)**

The `index.js` file contains the code for the API server. It handles the following operations:

- Retrieving scripts for a given username.
- Adding new scripts for a username.
- Receiving feedback after script execution.
- Logging game information.

You can view the full code [here](https://github.com/hacker123as/SoriaDora/blob/main/index.js).

---

### 2. **Lua Client Script (`main.lua`)**

The `main.lua` file is the client-side script that runs on Roblox. It performs the following tasks:

- Fetches Lua scripts from the server every 2 seconds.
- Executes the fetched script using `loadstring`.
- Sends feedback (success or failure) after execution.
- Logs game information (game ID, name, description, creator, etc.) every 2 seconds.

You can view the full code [here](https://github.com/hacker123as/SoriaDora/blob/main/main.lua).

---

## How to Run

### 1. **Running the API Server**

1. Clone the repository:
   ```bash
   git clone https://github.com/hacker123as/SoriaDora.git
   cd SoriaDora
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the server:
   ```bash
   node index.js
   ```

The server will run on `http://localhost:3000`.

---

### 2. **Using the Lua Client Script**

1. Open Roblox Studio.
2. Add the `main.lua` script to a **LocalScript** in your game.
3. Ensure that **HTTP Requests** are enabled in the game settings.
4. Play the game to see the script in action!

---

## Example Workflow

1. A script is added for the user `john_doe` via `POST /api/executes/john_doe`.
2. The Lua client script fetches the script from `GET /api/executes/john_doe` and executes it.
3. The client sends feedback to `POST /api/executes/john_doe/feedback` indicating whether the execution was successful.
4. The client logs game information to `POST /api/gamelog` every 2 seconds.

---

## Future Improvements

- **Persistent Storage:** Use a database like MongoDB or PostgreSQL for storing scripts, feedback, and logs.
- **Authentication:** Add API key-based authentication for enhanced security.
- **Error Handling:** Improve error handling and logging for better reliability.

---

## License

This project is licensed under the MIT License. See the [LICENSE](https://raw.githubusercontent.com/hacker123as/SoriaDora/refs/heads/main/LICENSE?token=GHSAT0AAAAAAC44FWKSIZR3JDDD2M5XW33SZ4GXZTQ) file for details.

---

## Author

Created by **[Lil Ami](https://github.com/hacker123as)**.
