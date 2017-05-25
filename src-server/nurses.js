const { delEntity, newEntity, getEntity } = require('./common');

module.exports = require('express').Router()
    .get('/api/nurses', getNursesHandler)
    .get('/api/nurses/:id', getNurseHandler)
    .delete('/api/nurses/:id', delNurseHandler)
    .post('/api/nurses', newNurseHandler);

function getNursesHandler(req, res) {
  getEntity('nurse')
        .then(nurses => res.send(nurses))
        .catch(() => res.redirect('/'));
}

function getNurseHandler(req, res) {
  getEntity(`nurse/${req.params.id}`)
      .then((nurse) => {
        res.send(nurse);
      });
}

function delNurseHandler(req, res) {
  delEntity(`nurse/${req.params.id}`)
        .then(() => res.send('OK'))
        .catch(() => res.send('ERR'));
}

function newNurseHandler(req, res) {
  console.log(req.body);

  const nurse = {
    isDistrictNurse: req.body.isDistrictNurse === 'on',
    personalData: {
      name: req.body.name,
      surname: req.body.surname,
      email: req.body.email,
      id: null,
    },
  };

  console.log(nurse);

  newEntity('nurse', nurse)
      .then(() => res.redirect('/nurses'))
      .catch((err) => {
        console.log(err);

        res.redirect('/nurses');
      });
}
