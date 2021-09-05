var express = require('express');
var env = require('./env');
var connector = require('./run');

var cors = require('cors');


var app = express();
// app.use(express.json());
app.use(cors());
app.use(express.urlencoded({extended : false}));
// var PORT = 5000;


app.all('*', async function (req, res) {
   if (req.method ===  'POST'){
    req.body = JSON.stringify(req.body);
    var lambdaResponcePromise = connector.handler(req);
    var lambdaResponce= await lambdaResponcePromise;
    res.send((lambdaResponce));
} else {
    res.send({ code: 221, msg: 'Invalid Request Type :' + req.method });
}
});



app.listen(env.PORT, function () {
    console.log('SDK0306 -- Server runing at http://127.0.0.1:' + env.PORT);
    
})


