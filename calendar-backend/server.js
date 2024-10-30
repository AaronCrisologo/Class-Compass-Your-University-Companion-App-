const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const axios = require('axios');

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

// MySQL Connection
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root', // Replace with your MySQL username
    password: 'password', // Replace with your MySQL password
    database: 'class_compass',
});

db.connect(err => {
    if (err) throw err;
    console.log('Connected to MySQL database.');
});

// API Endpoints

// Get Current Time in the Philippines
app.get('/calendar/time', async (req, res) => {
    try {
        const response = await axios.get('http://worldtimeapi.org/api/timezone/Asia/Manila');
        res.json(response.data);
    } catch (error) {
        res.status(500).send('Error fetching time');
    }
});

// Get National Holidays
app.get('/calendar/holidays', (req, res) => {
    db.query('SELECT * FROM holidays', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});

// Add a User Note
app.post('/calendar/notes', (req, res) => {
    const { note_date, note_text } = req.body;
    db.query('INSERT INTO user_notes (note_date, note_text) VALUES (?, ?)', [note_date, note_text], (err) => {
        if (err) return res.status(500).send(err);
        res.status(201).send('Note added successfully');
    });
});

// Get User Notes
app.get('/calendar/notes', (req, res) => {
    db.query('SELECT * FROM user_notes', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});

// Add a Custom Marked Day
app.post('/calendar/marked-days', (req, res) => {
    const { marked_date, day_type } = req.body;
    db.query('INSERT INTO custom_days (marked_date, day_type) VALUES (?, ?)', [marked_date, day_type], (err) => {
        if (err) return res.status(500).send(err);
        res.status(201).send('Marked day added successfully');
    });
});

// Get Custom Marked Days
app.get('/calendar/marked-days', (req, res) => {
    db.query('SELECT * FROM custom_days', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});

// Start the Server
app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});
