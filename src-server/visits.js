const {getPatient} = require('./common');

var visits = [
    {
        patient: 1,
        doctors: [{
            speciality: 'surgeon',
            personalData: {
                id: 1,
                surname: 'Pitt',
                name: 'Bragg',
                email: '4@B.pl'
            }
        }],
        nurses: [{
            isDistrictNurse: true,
            personalData: {
                id: 0,
                surname: 'McDolan',
                name: 'Sara',
                email: 'a@B.pl'
            }
        }],
        date: new Date().toDateString(),
        id: 0
    }
];

module.exports = require('express').Router()
    .get('/api/visits', getVisitsHandler)
    .delete('/api/visits/:id', delVisitHandler)
    .get('/api/visits/:id', getVisitHandler)
    .post('/api/visits', newVisitHandler);

function getVisitHandler(req, res) {
    const visit = visits.find(visit => visit.id === parseInt(req.params.id));

    if (visit) {
        getPatient(visit.patient)
            .then(data => toVisitWithPatient(visit, data))
            .then(res.send.bind(res))
            .catch(err => console.log(err));
    } else {
        res.send({});
    }
}

function getVisitsHandler(req, res) {
    const visitsWithPatients = visits
        .map(visit => {
            return getPatient(visit.patient)
                .then(patient => {
                    return toVisitWithPatient(visit, patient);
                })
        });

    return Promise
        .all(visitsWithPatients)
        .then(res.send.bind(res))
        .catch(err => console.log(err));
}

function delVisitHandler(req, res) {
    visits = visits.filter(visit => visit.id !== parseInt(req.params.id));

    res.send('OK');
}

function newVisitHandler(req, res) {
    res.send('OK');
}

function toVisitWithPatient(visit, data) {
    return Object.assign({}, visit, {
        patient: {
            personalData: JSON.parse(data)
        }
    })
}
