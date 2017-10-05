var sql = require("mssql");
var express = require("express");
var url = require('url');
var bodyParser = require('body-parser');
var multer = require('multer'); // v1.0.5
var cors = require('cors')

var app = express();

app.use(cors())
app.use(bodyParser.json()); // for parsing application/json
app.use(bodyParser.urlencoded({ extended: true })); // for parsing application/x-www-form-urlencoded

var config = {
    user: "USER",
    server: "SERVER",
    password: "PASSWORD", 
    "domain": "HOME",
    database: "DATABASE",
	port: "PORT"
};

var cp = new sql.ConnectionPool(config); //cp = connection pool

///////////////////////////////////SELECT //////////////////////////////////////
app.get('/Product', function(req, res) {

	// create Request object
	var request = new sql.Request(cp);

	var q = url.parse(req.url, true);

	request.input('ProductId', sql.Int, q.query.id);
	request.execute('GetProducts', (err, recordset) => {
		if (err) 
		{
			console.log(err);	
			res.status(400);
			res.send(err.originalError.info.message);
		}		
		else
		{
			res.status(200);
			res.send(recordset.recordsets);
		}
	});
});

app.get('/Store', function(req, res) {

	// create Request object
	var request = new sql.Request(cp);

	var q = url.parse(req.url, true);

	request.input('StoreId', sql.Int, q.query.id);
	request.execute('GetStores', (err, recordset) => {

		if (err) 
		{
			console.log(err);	
			res.status(400);
			res.send(err.originalError.info.message);
		}		
		else
		{
			res.status(200);
			res.send(recordset.recordsets);
		}
	});
});


app.get('/SalePrice', function(req, res) {

	// create Request object
	var request = new sql.Request(cp);

	var q = url.parse(req.url, true);

	request.input('ProductId', sql.Int, q.query.ProductId);
	request.input('StoreId', sql.Int, q.query.StoreId);
	request.execute('GetSalePrice', (err, recordset) => {

		if (err) 
		{
			console.log(err);	
			res.status(400);
			res.send(err.originalError.info.message);
		}		
		else
		{
			res.status(200);
			res.send(recordset.recordsets);
		}
	});
});



/////////////////////////////////DELETE////////////////////////
app.delete('/Product', function(req, res) {

	// create Request object
	var request = new sql.Request(cp);

	var q = url.parse(req.url, true);

	request.input('ProductId', sql.Int, q.query.id);
	request.execute('DeleteProducts', (err, recordset) => {

		if (err) 
		{
			console.log(err);	
			res.status(400);
			res.send(err.originalError.info.message);
		}		
		else
		{
			res.status(200);
			res.send('Success');
		}
	});
});

app.delete('/Store', function(req, res) {

	// create Request object
	var request = new sql.Request(cp);

	var q = url.parse(req.url, true);

	request.input('StoreId', sql.Int, q.query.id);
	request.execute('DeleteStores', (err, recordset) => {

		if (err) 
		{
			console.log(err);	
			res.status(400);
			res.send(err.originalError.info.message);
		}		
		else
		{
			res.status(200);
			res.send('Success');
		}
	});
});

//////////////////////////////////INSERT //////////////////////////////////////////////////


app.post('/Product', function(req, res) {

	// create Request object
	var request = new sql.Request(cp);

	request.input('ProductType', sql.VarChar(10), req.body.ProductType);
	request.input('ProductName', sql.VarChar(250), req.body.ProductName);
	request.input('ProductDescription', sql.VarChar(300), req.body.ProductDescription);
	request.execute('InsertProducts', (err, recordset) => {
		if (err) 
		{
			console.log(err);	
			res.status(400);
			res.send(err.originalError.info.message);
		}		
		else
		{
			res.status(200);
			res.send('Success');
		}
	});
});

app.post('/Store', function(req, res) {

	// create Request object
	var request = new sql.Request(cp);
	
	request.input('StoreName', sql.VarChar(250), req.body.StoreName);
	request.input('City', sql.VarChar(250), req.body.City);
	request.execute('InsertStores', (err, recordset) => {

		if (err) 
		{
			console.log(err);	
			res.status(400);
			res.send(err.originalError.info.message);
		}		
		else
		{
			res.status(200);
			res.send('Success');
		}
	});
});

/////////////////////////////////////////////// UPDATE /////////////////


app.put('/Product', function(req, res) {

	// create Request object
	var request = new sql.Request(cp);
	
	var q = url.parse(req.url, true);
	
	console.log(q.query.id);
	console.log(req.body.ProductType);
	console.log(req.body.ProductName);
	console.log(req.body.ProductDescription);
	
	request.input('ProductId', sql.Int, q.query.id);
	request.input('ProductType', sql.VarChar(10), req.body.ProductType);
	request.input('ProductName', sql.VarChar(250), req.body.ProductName);
	request.input('ProductDescription', sql.VarChar(300), req.body.ProductDescription);
	request.execute('UpdateProducts', (err, recordset) => {

		if (err) 
		{
			console.log(err);	
			res.status(400);
			res.send(err.originalError.info.message);
		}		
		else
		{
			res.status(200);
			res.send('Success');
		}
	});
});


app.put('/Store', function(req, res) {

	var request = new sql.Request(cp);
	
	var q = url.parse(req.url, true);

	request.input('StoreId', sql.Int, q.query.id);
	request.input('StoreName', sql.VarChar(250), req.body.StoreName);
	request.input('City', sql.VarChar(250), req.body.City);
	request.execute('UpdateStores', (err, recordset) => {

		if (err) 
		{
			console.log(err);	
			res.status(400);
			res.send(err.originalError.info.message);
		}		
		else
		{
			res.status(200);
			res.send('Success');
		}
	});
});

////////////////////////////INSERT-UPDATE(SalePrice)////////////////////////////////////
app.post('/SalePrice', function(req, res) {

	// create Request object
	var request = new sql.Request(cp);
	
	request.input('SalePriceXML', sql.XML, req.body.SalePriceXML);
	request.execute('ManageSalePrice', (err, recordset) => {

		if (err) 
		{
			console.log(err);	
			res.status(400);
			res.send(err.originalError.info.message);
		}		
		else
		{
			res.status(200);
			res.send('Success');
		}
	});
});

cp.connect().then(function() {
	var server = app.listen(5000, function() {
		console.log('running');
	});
}).catch(function(err) {
  console.error('Error creating connection pool', err);
});