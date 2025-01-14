// Import required modules
const express = require('express');
const bodyParser = require('body-parser');

const app = express();
const port = 3000;

// In-memory storage for scripts and feedback (for demo purposes)
const scripts = {};   // { username: "some lua script" }
const feedback = {};  // { username: "executed successfully" }
const gameLogs = [];  // Array to store game logs

// Middleware to parse JSON request bodies
app.use(bodyParser.json());

// Endpoint to get the script for a specific username
app.get('/api/executes/:username', (req, res) => {
    const username = req.params.username;
    if (scripts[username]) {
        res.send(scripts[username]); // Send the stored script
    } else {
        res.send('-- nothing here'); // Send a default message if no script exists
    }
});

// Endpoint to post feedback after script execution
app.post('/api/executes/:username/feedback', (req, res) => {
    const username = req.params.username;
    const { message } = req.body;

    if (!message) {
        return res.status(400).json({ error: 'Feedback message is required' });
    }

    feedback[username] = message;
    console.log(`Feedback from ${username}: ${message}`);
    res.json({ success: true, message: 'Feedback received' });
});

// Endpoint to post a new script for a specific username
app.post('/api/executes/:username', (req, res) => {
    const username = req.params.username;
    const { script } = req.body;

    if (!script) {
        return res.status(400).json({ error: 'Script content is required' });
    }

    scripts[username] = script;
    console.log(`New script added for ${username}: ${script}`);
    res.json({ success: true, message: 'Script added successfully' });
});

// Endpoint to receive game logs
app.post('/api/gamelog', (req, res) => {
    const gameInfo = req.body;

    if (!gameInfo.gameId || !gameInfo.gameName || !gameInfo.creator) {
        return res.status(400).json({ error: 'Incomplete game information' });
    }

    gameLogs.push(gameInfo);
    console.log('Game log received:', gameInfo);
    res.json({ success: true, message: 'Game log received' });
});

// Start the server
app.listen(port, () => {
    console.log(`SoriaDora API server running on http://localhost:${port}`);
});
