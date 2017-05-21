const { sendSingleEntity } = require('./common');

let nurses = [
  {
    personalData: {
      name: 'Anna',
      surname: 'Novak',
      email: 'anna@novak.com',
      id: 0,
    },
    isDistrictNurse: false,
  },
  {
    personalData: {
      name: 'Marry',
      surname: 'Lou',
      email: 'marry@lou.de',
      id: 1,
    },
    isDistrictNurse: true,
  },
];

module.exports = require('express').Router()
    .get('/api/nurses', getNursesHandler)
    .get('/api/nurses/:id', getNurseHandler)
    .delete('/api/nurses/:id', delNurseHandler)
    .post('/api/nurses', newNurseHandler);

function getNursesHandler(req, res) {
  res.send(nurses);
}

function getNurseHandler(req, res) {
  sendSingleEntity(res, nurses, req.params.id);
}

function delNurseHandler(req, res) {
  nurses = nurses.filter(nurse => nurse.personalData.id !== parseInt(req.params.id, 10));

  res.send('OK');
}

function newNurseHandler(req, res) {
  res.send('OK');
}
