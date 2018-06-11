const { setUpDelStream, setUpCreateStream, setUpGetStream } = require(`./common`);
const rxjs = require(`rxjs`);
const router = require(`express`).Router();

const getDoctorsSubject = new rxjs.Subject();
const delDoctorSubject = new rxjs.Subject();
const getDoctorSubject = new rxjs.Subject();
const newDoctorSubject = new rxjs.Subject();

setUpGetStream(getDoctorsSubject, `doctor`, [`speciality`]);
setUpGetStream(getDoctorSubject, `doctor`, [`speciality`]);
setUpDelStream(delDoctorSubject, `doctor`);
setUpCreateStream(newDoctorSubject, `doctors`, (req) => {
  const query = `insert into doctor (id, person_id, speciality) values (nextval('doctor_id_seq'), $1, $2)`;

  return (data, db) => db.query(query, [data[0].id, req.body.speciality]);
});

module.exports = router
    .get(`/api/doctors`, (req, res) => getDoctorsSubject.next([req, res]))
    .get(`/api/doctors/:id`, (req, res) => getDoctorSubject.next([req, res]))
    .delete(`/api/doctors/:id`, (req, res) => delDoctorSubject.next([req, res]))
    .post(`/api/doctors`, (req, res) => newDoctorSubject.next([req, res]));
