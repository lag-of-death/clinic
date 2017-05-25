const { delEntity, newEntity, getEntity } = require('./common');

module.exports = require('express').Router()
    .get('/api/doctors', getDoctorsHandler)
    .get('/api/doctors/:id', getDoctorHandler)
    .delete('/api/doctors/:id', delDoctorHandler)
    .post('/api/doctors', newDoctorHandler);

function getDoctorsHandler(req, res) {
  getEntity('doctor')
        .then(doctors => res.send(doctors))
        .catch(() => res.redirect('/'));
}

function getDoctorHandler(req, res) {
  getEntity(`doctor/${req.params.id}`)
        .then((doctor) => {
          res.send(doctor);
        });
}

function delDoctorHandler(req, res) {
  delEntity(`doctor/${req.params.id}`)
        .then(() => res.send('OK'))
        .catch(() => res.send('ERR'));
}

function newDoctorHandler(req, res) {
  const body = req.body;

  const doctor = {
    speciality: body.speciality,
    personalData: {
      name: body.name,
      surname: body.surname,
      email: body.email,
      id: null,
    },
  };

  newEntity('doctor', doctor)
        .then(() => res.redirect('/doctors'))
        .catch((err) => {
          console.log(err);

          res.redirect('/doctors');
        });
}
