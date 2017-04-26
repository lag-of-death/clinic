var doctors = [
    {
        speciality: "surgeon",
        name: "Thomas",
        surname: "Alban",
        email: "a@b.com",
        id: 0
    },
    {
        speciality: "psychiatrist",
        name: "Andrew",
        surname: "Gringo",
        email: "da@be.de",
        id: 1
    }
];

module.exports = require('express').Router()
    .get('/api/doctors', getDoctorsHandler)
    .delete('/api/doctors/:id', delDoctorHandler)
    .post('/api/doctors', newDoctorHandler);

function getDoctorsHandler(req, res) {
    res.send(doctors);
}

function delDoctorHandler(req, res) {
    console.log(req.params);


    doctors = doctors.filter(doctor => doctor.id !== parseInt(req.params.id));

    res.send('OK');
}

function newDoctorHandler(req, res) {
    res.send('OK');
}