const rxjs = require(`rxjs`);
const db = require(`./db`);

const express = require(`express`);

const getVisitsSubject = new rxjs.Subject();
const delVisitSubject = new rxjs.Subject();
const getVisitSubject = new rxjs.Subject();
const newVisitSubject = new rxjs.Subject();


getVisitsSubject.subscribe((args) => {
  const [req, res] = args;

  getVisitsHandler(req, res);
});

delVisitSubject.subscribe((args) => {
  const [req, res] = args;

  delVisitHandler(req, res);
});

getVisitSubject.subscribe((args) => {
  const [req, res] = args;

  getVisitsHandler(req, res);
});

newVisitSubject.subscribe((args) => {
  const [req, res] = args;

  newVisitHandler(req, res);
});


module.exports = express.Router()
                        .get(`/api/visits`, (req, res) => getVisitsSubject.next([req, res]))
                        .delete(`/api/visits/:id`, (req, res) => delVisitSubject.next([req, res]))
                        .get(`/api/visits/:id`, (req, res) => getVisitSubject.next([req, res]))
                        .post(`/api/visits`, (req, res) => newVisitSubject.next([req, res]));


function delVisitHandler(req, res) {
  rxjs.Observable
        .fromPromise(
            db.query(`delete from visit where id = $1`, [req.params.id]),
        )
        .subscribe(
            () => res.redirect(`/visits`),
            err => res.send(err),
        );
}

function newVisitHandler(req, res) {
  const { patientID, doctorID, nurseID, date } = req.body;
  const queryParams = [
    Date.parse(date || new Date()),
    patientID,
    doctorID,
    nurseID,
  ];

  const promise = db.query(`insert into visit (id, date, patient_id, doctor_id, nurse_id) values (nextval('visit_id_seq'), $1, $2, $3, $4)`, queryParams);

  rxjs.Observable
        .fromPromise(promise)
        .subscribe(
            () => res.redirect(`/visits`),
            err => res.send(err),
        );
}


function getVisitsHandler(req, res) {
  const promise = db.query(`
  select 
    visit.id, 
    date,
    json_build_object('id', patient.id, 'personal', json_build_object('id', pp.id, 'name', pp.name, 'surname', pp.surname, 'email', pp.email)) as patient,
    json_build_object('id', nurse.id, 'personal', json_build_object('id', np.id, 'name', np.name, 'surname', np.surname, 'email', np.email), 'district', nurse.is_district_nurse) as nurse,
    json_build_object('id', doctor.id, 'personal', json_build_object('id', dp.id, 'name', dp.name, 'surname', dp.surname, 'email', dp.email), 'speciality', doctor.speciality) as doctor
  
   from visit
   
   inner join patient on patient.id = visit.patient_id
   inner join person pp on pp.id = patient.person_id
   
   inner join doctor on doctor.id = visit.doctor_id
   inner join person dp on dp.id = doctor.person_id
   
   inner join nurse on nurse.id = visit.nurse_id
   inner join person np on np.id = nurse.person_id
   
   ${req.params.id ? `where visit.id = $1` : ``}
   `, [req.params.id]);


  rxjs.Observable
        .fromPromise(promise)
        .subscribe(
            (data) => {
              if (req.params.id) {
                res.send(data[0]);
              } else {
                res.send(data);
              }
            },
            err => res.send(err),
        );
}
