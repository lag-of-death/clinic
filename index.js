var express = require('express');
var app = express();

app.set('port', process.env.PORT || 5000);

app.use('/', express.static(__dirname + '/public'));

app.get('/patients-data', function (req, res) {
    res.json([
        { name: 'Jan Nowak', id: 1 },
        { name: 'Bat Man', id: 2 },
        { name: 'X Man', id: 3 },
        { name: 'Janusz Kowalsky', id: 4 },
    ]);
});

app.listen(app.get('port'), function () {
    console.log('Node app is running on port', app.get('port'));
});