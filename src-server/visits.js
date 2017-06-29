const { delEntity, getEntity, newEntity } = require('./common');

module.exports = require('express').Router()
    .get('/api/visits', getVisitsHandler)
    .delete('/api/visits/:id', delVisitHandler)
    .get('/api/visits/:id', getVisitHandler)
    .post('/api/visits', newVisitHandler);

function getVisitHandler(req, res) {
  getEntity(`visit/${req.params.id}`)
      .then(transformDate)
      .then(visit => res.send(visit));
}

function getVisitsHandler(req, res) {
  getEntity('visit')
      .then(visits => visits.map(transformDate))
      .then(visits => res.send(visits));
}

function delVisitHandler(req, res) {
  delEntity(`visit/${req.params.id}`)
        .then(() => res.send('OK'))
        .catch(() => res.send('ERR'));
}

function newVisitHandler(req, res) {
  const visit = {
    patientId: parseInt(req.body.patientID, 10),
    doctorsIds: toInts(req.body.doctorID),
    nursesIds: toInts(req.body.nurseID),
    date: +new Date(req.body.date),
    id: null,
  };

  newEntity('visit', visit)
        .then(() => res.redirect('/visits'))
        .catch((err) => {
          console.log(err);

          res.redirect('/visits');
        });
}

function transformDate(visit) {
  return Object.assign({}, visit, { date: new Date(visit.date) });
}

function toInts(entities) {
  return entities
        .map(entity => parseInt(entity, 10))
        .filter(entity => entity);
}
