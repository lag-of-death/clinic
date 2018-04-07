const { delEntity, createEntity, getEntities } = require(`./common`);
const express = require(`express`);

const rxjs = require(`rxjs`);

const getNursesSubject = new rxjs.Subject();
const delNurseSubject = new rxjs.Subject();
const getNurseSubject = new rxjs.Subject();
const newNurseSubject = new rxjs.Subject();

getNursesSubject.subscribe((args) => {
  const [req, res] = args;

  getEntities(req, res, `nurse`, [`is_district_nurse as district`]);
});

delNurseSubject.subscribe((args) => {
  const [req, res] = args;

  delEntity(req, res, `nurse`);
});

getNurseSubject.subscribe((args) => {
  const [req, res] = args;

  getEntities(req, res, `nurse`, [`is_district_nurse as district`]);
});

newNurseSubject.subscribe((args) => {
  const [req, res] = args;
  const query = `insert into nurse (id, person_id, is_district_nurse) values (nextval('patient_id_seq'), $1, $2)`;

  createEntity(req, res, `nurses`, (data, db) => db.query(query, [data[0].id, req.body.isDistrictNurse === `on`]));
});

module.exports = express.Router()
                        .get(`/api/nurses`, (req, res) => getNursesSubject.next([req, res]))
                        .get(`/api/nurses/:id`, (req, res) => getNurseSubject.next([req, res]))
                        .delete(`/api/nurses/:id`, (req, res) => delNurseSubject.next([req, res]))
                        .post(`/api/nurses`, (req, res) => newNurseSubject.next([req, res]));
