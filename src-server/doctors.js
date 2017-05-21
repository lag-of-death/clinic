const {sendSingleEntity} = require('./common');

var doctors = [
    {
        speciality: "surgeon",
        personalData: {
            name: "Thomas",
            surname: "Alban",
            email: "a@b.com",
            id: 0
        }
    },
    {
        speciality: "psychiatrist",
        personalData: {
            name: "Andrew",
            surname: "Gringo",
            email: "da@be.de",
            id: 1
        }
    }
];

module.exports = require('express').Router()
    .get('/api/doctors', getDoctorsHandler)
    .get('/api/doctors/:id', getDoctorHandler)
    .delete('/api/doctors/:id', delDoctorHandler)
    .post('/api/doctors', newDoctorHandler);

function getDoctorsHandler(req, res) {
    res.send(doctors);
}

function getDoctorHandler(req, res) {
    sendSingleEntity(res, doctors, req.params.id);
}

function delDoctorHandler(req, res) {
    doctors = doctors.filter(doctor => doctor.personalData.id !== parseInt(req.params.id));

    res.send('OK');
}

function newDoctorHandler(req, res) {
    res.send('OK');
}