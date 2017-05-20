const rp         = require('request-promise');
const {location} = require('./config');

var visits = [
    {
        patient: null,
        doctors: [],
        nurses: [],
        date: new Date().toDateString(),
        id: 0
    }
];

module.exports = require('express').Router()
    .get('/api/visits', getVisitsHandler)
    .delete('/api/visits/:id', delVisitHandler)
    .post('/api/visits', newVisitHandler);

function getVisitsHandler(req, res) {
    const options = {
        method: 'GET',
        uri: `${location}/patient/1`,
        resolveWithFullResponse: false
    };

    rp
        .get(options)
        .then(data => {

            res.send(visits.map(visit => {
                return Object.assign({}, visit, {
                    patient: {
                        personalData: JSON.parse(data)
                    }
                })
            }));
        })
        .catch(err => {
            console.log(err);
        });
}

function delVisitHandler(req, res) {
    visits = visits.filter(visit => visit.id !== parseInt(req.params.id));

    res.send('OK');
}

function newVisitHandler(req, res) {
    res.send('OK');
}
