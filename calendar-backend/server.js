require('dotenv').config();
const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const axios = require('axios');
const puppeteer = require('puppeteer');
const { chromium } = require('playwright'); // Using Playwright for GMA scraping
const bcrypt = require('bcrypt'); //npm install bcrypt
const emailValidator = require('email-validator'); //npm install email-validator
const jwt = require('jsonwebtoken');//npm install jsonwebtoken




const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

let currentUserId = null;

// MySQL Connection
const db = mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || 'password',
    database: process.env.DB_NAME || 'class_compass',
});

db.connect(err => {
    if (err) throw err;
    console.log('Connected to MySQL database.');
});

// Fetch Current Time in the Philippines
app.get('/calendar/time', async (req, res) => {
    try {
        const response = await axios.get('http://worldtimeapi.org/api/timezone/Asia/Manila');
        res.json(response.data);
    } catch (error) {
        console.error("Error fetching time:", error);
        res.status(500).send('Error fetching time');
    }
});

// Fetch National Holidays
app.get('/calendar/holidays', (req, res) => {
    db.query('SELECT * FROM holidays', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});

// Add and Retrieve User Notes
app.post('/calendar/notes', (req, res) => {
    const { note_date, note_text } = req.body;

    // Make sure currentUserId is defined and set
    if (!currentUserId) {
        return res.status(400).send({ message: 'User not logged in' });
    }

    // Insert note with the currentUserId
    db.query(
        'INSERT INTO user_notes (note_date, note_text, user_id) VALUES (?, ?, ?)',
        [note_date, note_text, currentUserId],
        (err) => {
            if (err) return res.status(500).send(err);
            res.status(201).send('Note added successfully');
        }
    );
});

app.get('/calendar/notes', (req, res) => {

    if (!currentUserId) {
        return res.status(401).send({ message: 'User not logged in' });
    }

    // SQL query to fetch all notes for the current user (filtered by user_id)
    const query = 'SELECT note_date, note_text FROM user_notes WHERE user_id = ?';

    db.query(query, [currentUserId], (err, results) => {
        if (err) return res.status(500).send(err);

        // Exclude the user_id from the response and return all notes for that user
        const notes = results.map(note => {
            const { user_id, ...noteWithoutUserId } = note; // Remove user_id from the result
            return noteWithoutUserId; // Return the note without user_id
        });

        // Send the filtered notes as JSON
        res.json(notes);
    });
});
// Add and Retrieve Custom Marked Days
app.post('/calendar/marked-days', (req, res) => {

    if (!currentUserId) {
        return res.status(400).send({ message: 'User not logged in' });
    }

    const { marked_date, day_type } = req.body;
    db.query('INSERT INTO custom_days (marked_date, day_type, user_id) VALUES (?, ?)', [marked_date, day_type, currentUserId], (err) => {
        if (err) return res.status(500).send(err);
        res.status(201).send('Marked day added successfully');
    });
});

app.get('/calendar/marked-days', (req, res) => {

    if (!currentUserId) {
        return res.status(401).send({ message: 'User not logged in' });
    }

    const query = 'SELECT marked_date, day_type FROM user_notes WHERE user_id = ?';

    db.query(query, [currentUserId], (err, results) => {
        if (err) return res.status(500).send(err);

        // Exclude the user_id from the response and return all notes for that user
        const notes = results.map(note => {
            const { user_id, ...noteWithoutUserId } = note; // Remove user_id from the result
            return noteWithoutUserId; // Return the note without user_id
        });

        // Send the filtered notes as JSON
        res.json(notes);
    });
});


app.delete('/calendar/notes/:date', (req, res) => {
    const noteDate = req.params.date;
    db.query('DELETE FROM user_notes WHERE note_date = ?', [noteDate], (err) => {
        if (err) return res.status(500).send(err);
        res.status(200).send('Note deleted successfully');
    });
});

// Delete a Custom Marked Day
app.delete('/calendar/marked-days/:date', (req, res) => {
    const markedDate = req.params.date;
    db.query('DELETE FROM custom_days WHERE marked_date = ?', [markedDate], (err) => {
        if (err) return res.status(500).send(err);
        res.status(200).send('Marked day deleted successfully');
    });
});




// Scrape first link with class 'story_link story' from GMA News tracking page
app.get('/scrape/gma-first-link', async (req, res) => {
    const browser = await chromium.launch(); // Launch browser with Playwright
    const page = await browser.newPage();

    try {
        console.log("Navigating to GMA News tracking page...");
        await page.goto('https://www.gmanetwork.com/news/tracking/walang_pasok/', { waitUntil: 'domcontentloaded' });

        // Wait for the first 'a' tag with class 'story_link story' to load
        await page.waitForSelector('a.story_link.story');

        // Extract the first link's href from the page
        const firstLink = await page.evaluate(() => {
            const linkElement = document.querySelector('a.story_link.story');
            if (linkElement) {
                return linkElement.href;  // Return the href attribute of the first link
            }
            return null;  // In case the link is not found
        });

        console.log("Found link:", firstLink); // Log the found link
        await browser.close();

        if (firstLink) {
            // Send the link as JSON response
            res.json({ link: firstLink });
        } else {
            res.status(404).send('No link found');
        }

    } catch (error) {
        console.error("Error scraping the first link:", error);
        await browser.close();
        res.status(500).send('Error scraping the first link');
    }
});

// Scrape GMA News Class Suspension Data
app.get('/scrape/gma-suspensions', async (req, res) => {
    const browser = await chromium.launch();
    const page = await browser.newPage();

    try {
        // Get the first link from the /scrape/gma-first-link endpoint
        const response = await axios.get('http://localhost:3000/scrape/gma-first-link');
        const firstLink = response.data.link;

        if (!firstLink) {
            return res.status(400).send('No link found to scrape suspensions');
        }

        console.log("Navigating to GMA News article:", firstLink);
        await page.goto(firstLink, { waitUntil: 'domcontentloaded', timeout: 60000 }); // Increase timeout

        // Wait for the .offset-computed elements to load
        await page.waitForSelector('.offset-computed', { timeout: 60000 });

        // Collect all p elements with class 'offset-computed'
        const suspensionsP = await page.evaluate(() => {
            const results = [];
            const pElements = document.querySelectorAll('p.offset-computed');
            pElements.forEach(p => {
                const text = p.innerText.trim();
                if (text) results.push(`${text} \n\n`);

            });
            return results;
        });

        // Collect all li elements inside ul with class 'offset-computed'
        const suspensionsUl = await page.evaluate(() => {
            const results = [];
            const ulElements = document.querySelectorAll('ul.offset-computed');
            ulElements.forEach(ul => {
                const liItems = ul.querySelectorAll('li');
                liItems.forEach(li => {
                    const text = li.innerText.trim();
                    if (text) results.push(text);
                });
            });
            return results;
        });

        console.log("Suspensions from p elements:", suspensionsP); // Log the p elements
        console.log("Suspensions from ul elements:", suspensionsUl); // Log the ul elements
        console.log(`User id from suspensions: ${currentUserId}`); // Log the

        await browser.close();

        // Concatenate the suspensions into a single string with line breaks
        const formattedMessage = [...suspensionsP, ...suspensionsUl].join('\n');

        // Send the formatted message as the response
        res.json({ message: formattedMessage });

    } catch (error) {
        console.error("Error scraping GMA News class suspension data:", error);
        await browser.close();
        res.status(500).send('Error scraping class suspension data');
    }
});


app.get('/scrape/first-weather-link', async (req, res) => {
    const browser = await chromium.launch();
    const page = await browser.newPage();

    try {
        // Navigate to the GMA weather tracking page with an increased timeout
        await page.goto('https://www.gmanetwork.com/news/tracking/weather/', { waitUntil: 'domcontentloaded', timeout: 90000 });

        // Use a broader selector in case class naming varies slightly
        await page.waitForSelector('a.story-link, a.story', { timeout: 90000 });

        // Extract the href attribute from the first matched 'a' element
        const firstLink = await page.evaluate(() => {
            const linkElement = document.querySelector('a.story-link') || document.querySelector('a.story');
            return linkElement ? linkElement.href : null;
        });

        await browser.close();

        if (firstLink) {
            console.log("Found link:", firstLink);
            res.json({ link: firstLink });
        } else {
            res.status(404).send('No link found');
        }
    } catch (error) {
        console.error("Error scraping the first weather link:", error);
        await browser.close();
        res.status(500).send('Error scraping the first weather link');
    }
});



app.get('/scrape/gma-weather', async (req, res) => {
    try {
        // Fetch the first weather link
        const response = await axios.get('http://localhost:3000/scrape/first-weather-link');
        const weatherUrl = response.data.link;

        if (!weatherUrl) {
            return res.status(404).send('No weather link found');
        }

        const browser = await chromium.launch();
        const page = await browser.newPage();

        console.log("Navigating to GMA News weather page:", weatherUrl);
        await page.goto(weatherUrl, { waitUntil: 'domcontentloaded', timeout: 90000 });

        // Wait for the required elements to load on the page
        await page.waitForSelector('.offset-computed', { timeout: 60000 });

        // Collect text from <p> and <ul> elements with class 'offset-computed'
        const weatherUpdates = await page.evaluate(() => {
            const updates = [];
            const pElements = document.querySelectorAll('p.offset-computed');
            const ulElements = document.querySelectorAll('ul.offset-computed');

            let currentSignal = '';

            for (let i = 0; i < pElements.length; i++) {
                const pText = pElements[i].innerText.trim();

                // Check if this <p> contains a "Signal No." and update `currentSignal`
                if (pText.includes("Signal No.")) {
                    currentSignal = pText; // Set as current signal level
                } else {
                    // Add areas under the current signal level
                    const ulItems = ulElements[i] ? ulElements[i].querySelectorAll('li') : [];
                    const ulText = Array.from(ulItems).map(li => li.innerText.trim()).join('\n');

                    // Group the current signal level with its areas
                    updates.push(`${currentSignal}\n\n${pText}\n${ulText}`);
                }
            }
            return updates;
        });

        await browser.close();

        // Format the response to align with the desired structure
        const formattedWeatherUpdates = weatherUpdates.join('\n\n');

        // Add an introductory message at the beginning
        const finalOutput = `\n${formattedWeatherUpdates}`;

        // Send the formatted updates as the response
        res.json({ message: finalOutput });

    } catch (error) {
        console.error("Error scraping GMA News weather updates:", error);
        res.status(500).send('Error scraping weather updates');
    }
});
app.get('/scrape/gma-volcano-link', async (req, res) => {
    const browser = await chromium.launch(); // Launch browser with Playwright
    const page = await browser.newPage();

    try {
        console.log("Navigating to GMA News tracking page...");
        await page.goto('https://www.gmanetwork.com/news/tracking/taal_volcano/', { waitUntil: 'domcontentloaded' });

        // Wait for the first 'a' tag with class 'story_link story' to load
        await page.waitForSelector('a.story_link.story');

        // Extract the first link's href from the page
        const firstLink = await page.evaluate(() => {
            const linkElement = document.querySelector('a.story_link.story');
            if (linkElement) {
                return linkElement.href;  // Return the href attribute of the first link
            }
            return null;  // In case the link is not found
        });

        console.log("Found link:", firstLink); // Log the found link
        await browser.close();

        if (firstLink) {
            // Send the link as JSON response
            res.json({ link: firstLink });
        } else {
            res.status(404).send('No link found');
        }

    } catch (error) {
        console.error("Error scraping the first link:", error);
        await browser.close();
        res.status(500).send('Error scraping the first link');
    }
});

app.get('/scrape/gma-volcano', async (req, res) => {
    try {

        const response = await axios.get('http://localhost:3000/scrape/gma-volcano-link');
        const weatherUrl = response.data.link;

        if (!weatherUrl) {
            return res.status(404).send('No Taal volcano link found');
        }

        const browser = await chromium.launch();
        const page = await browser.newPage();

        console.log("Navigating to GMA News taal volcano page:", weatherUrl);
        await page.goto(weatherUrl, { waitUntil: 'domcontentloaded', timeout: 90000 });

        // Wait for the required elements to load on the page
        console.log(`user id in volcano: ${currentUserId}`);
        await page.waitForSelector('.offset-computed', { timeout: 60000 });

        // Collect text from <p> and <ul> elements with class 'offset-computed'
        const volcanoUpdates = await page.evaluate(() => {
            const updates = [];
            const pElements = document.querySelectorAll('p.offset-computed');
            const ulElements = document.querySelectorAll('ul.offset-computed');

            let currentSignal = '';

            for (let i = 0; i < pElements.length; i++) {
                const pText = pElements[i].innerText.trim();

                // Check if this <p> contains a "Signal No." and update `currentSignal`
                if (pText.includes("Signal No.")) {
                    currentSignal = pText; // Set as current signal level
                } else {
                    // Add areas under the current signal level
                    const ulItems = ulElements[i] ? ulElements[i].querySelectorAll('li') : [];
                    const ulText = Array.from(ulItems).map(li => li.innerText.trim()).join('\n');

                    // Group the current signal level with its areas
                    updates.push(`${currentSignal}\n\n${pText}\n${ulText}`);
                }
            }
            return updates;
        });

        await browser.close();

        // Format the response to align with the desired structure
        const formattedVolcanoUpdates = volcanoUpdates.join('');

        // Add an introductory message at the beginning
        const finalOutput = `\n${formattedVolcanoUpdates}`;

        // Send the formatted updates as the response
        res.json({ message: finalOutput });

    } catch (error) {
        console.error("Error scraping GMA News Taal volcano updates:", error);

        res.status(500).send('Error scraping Taal Volcano updates');
    }
});

app.post('/login', (req, res) => {
    const { email, password } = req.body;

    // Basic validation to check if email and password are provided
    if (!email || !password) {
        return res.status(400).send({ message: 'Email and password are required' });
    }

    console.log('Received email:', email);  // Log the email
    console.log('Received password:', password);  // Log the password (don't log passwords in production!)

    // Check if the email exists in the database
    const query = 'SELECT user_id, password FROM accounts WHERE email = ?';
    db.query(query, [email], (err, results) => {
        if (err) {
            console.error('Database error:', err);
            return res.status(500).send({ message: 'Database error' });
        }

        if (results.length > 0) {
            // User exists, check if password matches (plain text comparison)
            const storedPassword = results[0].password;

            // Compare passwords directly (since both are plain text)
            if (password === storedPassword) {
                // Password matches, store user_id locally
                currentUserId = results[0].user_id;
                console.log('Login successful for email:', email);
                console.log(`user id: ${currentUserId}`);  // Log successful login

                // Return the user_id in the response without a token
                res.status(200).send({
                    message: 'Login successful',
                    user_id: currentUserId  // Send the user_id in the response
                });
            } else {
                // Password doesn't match
                console.log('Incorrect password attempt for email:', email);  // Log incorrect password attempt
                res.status(401).send({ message: 'Invalid email or password' });
            }
        } else {
            // No user found with the given email
            console.log('No user found with email:', email);  // Log no user found
            res.status(401).send({ message: 'Invalid email or password' });
        }
    });
});




app.post('/register', (req, res) => {
    const { email, password, phone, address, course, section, firstName, lastName } = req.body;

    // Basic validation to check if all fields are provided
    if (!email || !password || !phone || !address || !course || !section || !firstName || !lastName) {
        return res.status(400).send({ message: 'All fields are required' });
    }

    // Validate email format
    if (!emailValidator.validate(email)) {
        return res.status(400).send({ message: 'Invalid email format' });
    }

    // Check if email already exists
    const checkEmailQuery = 'SELECT * FROM accounts WHERE email = ?';
    db.query(checkEmailQuery, [email], (err, results) => {
        if (err) {
            console.error('Error checking email:', err);
            return res.status(500).send({ message: 'Error checking email' });
        }
        if (results.length > 0) {
            return res.status(400).send({ message: 'Email already exists' });
        }

        // Save the user with additional fields (firstName and lastName)
        const query = 'INSERT INTO accounts (email, password, phone, address, course, section, firstName, lastName) VALUES (?, ?, ?, ?, ?, ?, ?, ?)';
        db.query(query, [email, password, phone, address, course, section, firstName, lastName], (err, results) => {
            if (err) {
                console.error('Error inserting user:', err);
                return res.status(500).send({ message: 'Error saving user' });
            }
            console.log('User registered successfully');
            res.status(201).send({ message: 'User registered successfully' });
        });
    });
});


app.get('/get-user', (req, res) => {
    console.log('currentUserId is :', currentUserId);  // Log the currentUserID

    if (!currentUserId) {
        return res.status(400).send({ message: 'User not authenticated' });
    }

    const query = 'SELECT email, phone, address, course, section, firstname, lastname FROM accounts WHERE user_id = ?';
    db.query(query, [currentUserId], (err, results) => {
        if (err) {
            console.error('Error fetching user data:', err);
            return res.status(500).send({ message: 'An error occurred while retrieving the data' });
        }

        if (results.length === 0) {
            return res.status(404).send({ message: 'User not found' });
        }

        res.status(200).send(results[0]);
    });
});



app.post("/addSchedule", (req, res) => {
    const { name, instructor, startTime, endTime, day, color } = req.body;

    console.log('Received data:', req.body);
    console.log(`user id in adding class: ${currentUserId}`); // Log the entire body to check if it's correctly received

    // Check if any required field is missing
    if (!name || !instructor || !startTime || !endTime || !day || !color || !currentUserId) {
        console.log('Missing required fields');
        return res.status(400).json({ error: "Missing fields or user not authenticated" });
    }

    // Function to format time as 'HH:MM' (24-hour format)
    const formatTime = (time) => {
        const hour = time.hour < 10 ? `0${time.hour}` : time.hour;  // Add leading zero if needed
        const minute = time.minute < 10 ? `0${time.minute}` : time.minute;  // Add leading zero if needed
        return `${hour}:${minute}`;
    };

    try {
        // Ensure startTime and endTime are objects with hour and minute properties
        if (typeof startTime !== 'object' || typeof endTime !== 'object') {
            throw new Error("Invalid time format");
        }

        // Format startTime and endTime to 'HH:MM' format
        const startTime12 = formatTime(startTime);  // Convert startTime object to string
        const endTime12 = formatTime(endTime);  // Convert endTime object to string

        console.log('Formatted Start time:', startTime12);  // Check the formatted time
        console.log('Formatted End time:', endTime12);  // Check the formatted time

        // Insert the schedule into the database with currentUserId
        const query = `
          INSERT INTO schedule (name, instructor, startTime, endTime, day, color, user_id)
          VALUES (?, ?, ?, ?, ?, ?, ?)`;

        db.query(
            query,
            [name, instructor, startTime12, endTime12, day, color, currentUserId],
            (err, results) => {
                if (err) {
                    console.log('Error inserting into DB:', err);  // Log the error for troubleshooting
                    return res.status(500).json({ error: "Error adding class" });
                }
                res.status(200).json({
                    id: results.insertId,
                    name,
                    instructor,
                    startTime: startTime12,
                    endTime: endTime12,
                    day,
                    color,
                    currentUserId,  // Send currentUserId back for confirmation
                });
            }
        );
    } catch (err) {
        console.log('Error processing time:', err);  // Log specific error
        return res.status(400).json({ error: "Invalid time format or missing data" });
    }
});

app.get('/getSchedule', (req, res) => {
    // Ensure that the user is logged in
    if (!currentUserId) {
        return res.status(401).json({ error: 'User not authenticated' });
    }

    // Query the database for schedule data filtered by currentUserId
    const query = 'SELECT * FROM schedule WHERE user_id = ?';

    db.query(query, [currentUserId], (err, results) => {
        if (err) {
            console.error('Error fetching schedule data: ', err);
            return res.status(500).json({ error: 'An error occurred while fetching data.' });
        }

        // Send the schedule data as a response
        return res.status(200).json(results);
    });
});






// Delete a User Not
// Start the Server
app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});