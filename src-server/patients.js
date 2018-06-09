const rxjs = require(`rxjs`);
const router = require(`express`).Router();
const { delEntity, getEntities, createEntity } = require(`./common`);

const getPatientsSubject = new rxjs.Subject();
const delPatientSubject = new rxjs.Subject();
const getPatientSubject = new rxjs.Subject();
const newPatientSubject = new rxjs.Subject();


getPatientsSubject.subscribe((args) => {
  const [req, res] = args;

  getEntities(req, res, `patient`);
});


delPatientSubject.subscribe((args) => {
  const [req, res] = args;

  delEntity(req, res, `patient`);
});

getPatientSubject.subscribe((args) => {
  const [req, res] = args;

  getEntities(req, res, `patient`);
});

newPatientSubject.subscribe((args) => {
  const [req, res] = args;
  const query = `insert into patient (id, person_id) values (nextval('patient_id_seq'), $1)`;

  createEntity(req, res, `patients`, (data, db) => db.query(query, [data[0].id]));
});

module.exports = router
    .get(`/api/patients`, (req, res) => getPatientsSubject.next([req, res]))
    .delete(`/api/patients/:id`, (req, res) => delPatientSubject.next([req, res]))
    .get(`/api/patients/:id`, (req, res) => getPatientSubject.next([req, res]))
    .post(`/api/patients`, (req, res) => newPatientSubject.next([req, res]));

