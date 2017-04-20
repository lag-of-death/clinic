var mutablePatients = [
    { name: 'Jan Nowak', id: 1 },
    { name: 'Bat Man', id: 2 },
    { name: 'X Man', id: 3 },
    { name: 'Janusz Kowalsky', id: 4 },
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