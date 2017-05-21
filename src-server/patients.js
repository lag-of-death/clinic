const rp           = require('request-promise');
const {location}   = require('./config');
const {getPatient} = require('./common');

module.exports = require('express').Router()
    .get('/api/patients', getPatientsHandler.bind(null, location))
    .delete('/api/patients/:id', delPatientHandler.bind(null, location))
    .get('/api/patients/:id', getPatientHandler)
    .post('/api/patients', newPatientHandler.bind(null, location));

function getPatientHandler(req, res) {
    return getPatient(req.params.id)
        .then(data => {
            res.send(data);
        })
        .catch(err => {
            res.send(err);
        })
}

function getPatientsHandler(location, req, res) {
    const options = {
        method: 'GET',
        uri: `${location}/patient`,
        resolveWithFullResponse: false
    };

    return rp(options)
        .then(patients => res.send(
            JSON.parse(patients)
                .map(patient => ({
                    personalData: patient
                }))
            )
        )
        .catch(err => res.redirect('/'));
}

function delPatientHandler(location, req, res) {
    const options = {
        method: 'DELETE',
        uri: `${location}/patient/${req.params.id}`,
        resolveWithFullResponse: true
    };

    return rp(options)
        .then(() => res.send('OK'))
        .catch((err) => res.send('ERR'));
}

function newPatientHandler(location, req, res) {
    const options = {
        method: 'POST',
        uri: `${location}/patient`,
        body: JSON.stringify(Object.assign({}, req.body, {id: null})),
        headers: {
            'content-type': 'application/json'
        }
    };

    return rp(options)
        .then(() => res.redirect('/patients'))
        .catch(err => {
            console.log(err);

            res.redirect('/patients')
        });
}
