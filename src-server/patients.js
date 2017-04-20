var mutablePatients = [
    { name: 'Jan', surname: 'Nowak', email: 'xd@b.pl', id: 1 },
    { name: 'Bat', surname: 'Man', email: 'xg@b.pl', id: 2 },
    { name: 'X', surname: 'Man', email: 'xe@b.pl', id: 3 },
    { name: 'Janusz', surname: 'Kowalsky', email: 'xb@b.pl', id: 4 },
];

module.exports = require('express').Router()
    .get('/api/patients', getPatientsHandler)
    .post('/api/patients', newPatientHandler);

function getPatientsHandler(req, res) {
    res.json(mutablePatients);
}

function newPatientHandler(req, res) {
    mutablePatients.push(Object.assign(
        {},
        { id: mutablePatients.length + 1 },
        req.body)
    );

    if (0) {
        res.send('Validation error.');
    } else {
        res.redirect('/patients');
    }
}