var express = require('express');
var app = express();
var handlebars = require('handlebars');
var fs = require('fs');
var path = require('path');
var bodyParser = require('body-parser');
var cookieParser = require('cookie-parser');
var cookieSession = require('cookie-session');

var formTemplate = fs.readFileSync(path.join(__dirname, 'form.html'), 'utf8');

var config = require('./config.json');

var auth = function(req, res, next) {
	var user = req.session.user;
	var users = config.users;
  if (!user || !users[user.username] || users[user.username] !== user.password) {
		res.send(handlebars.compile(formTemplate)({url:req.url}));
  }
  return next();
};
app.use(cookieParser(config.cookieSecret));
app.use(cookieSession({
	keys: ['key1', 'key2']
}));

app.use(bodyParser.urlencoded({ extended: false }));

app.post('/login',function(req, res){
	var redirecturl = req.body.redirecturl;
	var user = req.body.username;
	var password = req.body.password;
	req.session.user = {username: user, password: password};
	res.redirect(redirecturl);
});

app.use(auth);

app.use(express.static('preview'));

app.listen(process.env.PORT || 8080);
