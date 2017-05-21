const rp         = require('request-promise');
const {location} = require('./config');

module.exports = {
    getPatient: getPatient.bind(null, location),
    sendSingleEntity
};

function getPatient(location, id) {
    const options = {
        method: 'GET',
        uri: `${location}/patient/${id}`,
        resolveWithFullResponse: false
    };

    return rp.get(options);
}

function sendSingleEntity(res, entities, id) {
    return res.send(entities.find(entity => entity.personalData.id === parseInt(id)));
}
