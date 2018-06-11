const { delEntity, createEntity, setUpGetStream } = require(`./common`);
const rxjs = require(`rxjs`);

const getDoctorsSubject = new rxjs.Subject();
const delDoctorSubject = new rxjs.Subject();
const getDoctorSubject = new rxjs.Subject();
const newDoctorSubject = new rxjs.Subject();

setUpGetStream(getDoctorsSubject, `doctor`, [`speciality`]);
setUpGetStream(getDoctorSubject, `doctor`, [`speciality`]);


delDoctorSubject.subscribe((args) => {
  const [req, res] = args;

  delEntity(req, res, `doctor`);
});


newDoctorSubject.subscribe((args) => {
  const [req, res] = args;
  const query = `insert into doctor (id, person_id, speciality) values (nextval('doctor_id_seq'), $1, $2)`;

  createEntity(req, res, `doctors`, (data, db) => db.query(query, [data[0].id, req.body.speciality]));
});

const router = require(`express`).Router();

module.exports = router
    .get(`/api/doctors`, (req, res) => getDoctorsSubject.next([req, res]))
    .get(`/api/doctors/:id`, (req, res) => getDoctorSubject.next([req, res]))
    .delete(`/api/doctors/:id`, (req, res) => delDoctorSubject.next([req, res]))
    .post(`/api/doctors`, (req, res) => newDoctorSubject.next([req, res]));
