const { location } = require('./config');
const { getEntity, newEntity, delEntity } = require('./common');

module.exports = require('express').Router()
    .get('/api/patients', getPatientsHandler.bind(null, location))
    .delete('/api/patients/:id', delPatientHandler.bind(null, location))
    .get('/api/patients/:id', getPatientHandler)
    .post('/api/patients', newPatientHandler.bind(null, location));

function getPatientHandler(req, res) {
  return getEntity(`patient/${req.params.id}`)
        .then((data) => {
          res.send(data);
        })
        .catch((err) => {
          res.send(err);
        });
}

function getPatientsHandler(location, req, res) {
  getEntity('patient')
      .then(patients => res.send(patients))
      .catch(() => res.redirect('/'));
}

function delPatientHandler(location, req, res) {
  delEntity(`patient/${req.params.id}`)
        .then(() => res.send('OK'))
        .catch(() => res.send('ERR'));
}

function newPatientHandler(location, req, res) {
  return newEntity('patient', Object.assign({}, req.body, { id: null }))
      .then(() => res.redirect('/patients'))
      .catch((err) => {
        console.log(err);

        res.redirect('/patients');
      });
}
