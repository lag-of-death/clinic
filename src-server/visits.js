var visits = [
    {
        patient: 2,
        doctors: [0],
        nurses: [0],
        date: new Date().toDateString(),
        id: 0
    },
    {
        patient: 1,
        doctors: [0],
        nurses: [0],
        date: new Date().toDateString(),
        id: 0
    }
];

module.exports = require('express').Router()
    .get('/api/visits', getVisitsHandler)
    .delete('/api/visits/:id', delVisitHandler)
    .post('/api/visits', newVisitHandler);

function getVisitsHandler(req, res) {
    res.send(visits);
}

function delVisitHandler(req, res) {
    visits = visits.filter(visit => visit.id !== parseInt(req.params.id));

    res.send('OK');
}

function newVisitHandler(req, res) {
    res.send('OK');
}
