var mysql = require('mysql');
var express = require('express');
var session = require('express-session');
var bodyParser = require('body-parser');
var path = require('path');

var connection = mysql.createConnection({
	host     : 'localhost',
	user     : 'root',
	password : 'Password123!',
	database : 'cs253_asgn4_data'
});

var app = express();
app.use(session({
	secret: 'secret',
	resave: true,
	saveUninitialized: true
}));
app.use(bodyParser.urlencoded({extended : true}));
app.use(bodyParser.json());

app.get('/', function(request, response) {
	response.sendFile(path.join(__dirname + '/login.html'));
});

app.post('/auth', function(request, response) {
	var username = request.body.username;
	var password = request.body.password;
	if (username && password) {
		var temp=connection.query('SELECT * FROM user_data WHERE email = ? AND password = ?', [username, password], function(error, results, fields) {
			
            if (results.length > 0) {
				request.session.loggedin = true;
				request.session.username = username;
				response.redirect('/home');
			} else {
				response.send('Hacker caught red-handed!');
			}			
			response.end();
		});
        console.log(temp.sql);
	} else {
		response.send('Enter login data');
		response.end();
	}
});

app.get('/home', function(request, response) {
	if (request.session.loggedin) {
		response.send('Success!');
	} else {
		response.send('Try logging in!');
	}
	response.end();
});

app.listen(3000);
