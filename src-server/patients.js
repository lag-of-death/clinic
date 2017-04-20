var mutablePatients = [
    { name: 'Jan', surname: 'Nowak', email: 'xd@b.pl', id: 0 },
    { name: 'Bat', surname: 'Man', email: 'xg@b.pl', id: 1 },
    { name: 'X', surname: 'Man', email: 'xe@b.pl', id: 2 },
    { name: 'Janusz', surname: 'Kowalsky', email: 'xb@b.pl', id: 3 },
];

module.exports = require('express').Router()
    .get('/api/patients', getPatientsHandler)
    .delete('/api/patients/:id', (req, res) => {
        const rest = mutablePatients.filter(patient => patient.id != req.params.id);

        mutablePatients = rest;

        res.send('okejka');
    })
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