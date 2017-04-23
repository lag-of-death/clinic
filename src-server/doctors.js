var doctors = [{name: "Thomas", surname: "Alban", email: "a@b.com", id: 0}];

module.exports = require('express').Router()
    .get('/api/doctors', getDoctorsHandler)
    .delete('/api/doctors/:id', delDoctorHandler)
    .post('/api/doctors', newDoctorHandler);

function getDoctorsHandler(req, res) {
    res.send(doctors);
}

function delDoctorHandler(req, res) {
    doctors = [];

    res.send('OK');
}

function newDoctorHandler(req, res) {
    res.send('OK');
}