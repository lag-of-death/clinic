const rp = require('request-promise');
const { location } = require('./config');

module.exports = {
  getEntity: getEntity.bind(null, location),
  delEntity: delPerson.bind(null, location),
  newEntity: newEntity.bind(null, location),
};


function getEntity(location, pathEnd) {
  const options = {
    method: 'GET',
    uri: `${location}/${pathEnd}`,
    resolveWithFullResponse: false,
  };

  return rp.get(options).then(data => JSON.parse(data));
}

function newEntity(location, endPath, body) {
  const options = {
    method: 'POST',
    uri: `${location}/${endPath}`,
    body: JSON.stringify(body),
    headers: {
      'content-type': 'application/json',
    },
  };

  return rp(options);
}


function delPerson(location, endPath) {
  const options = {
    method: 'DELETE',
    uri: `${location}/${endPath}`,
    resolveWithFullResponse: true,
  };

  return rp(options);
}
