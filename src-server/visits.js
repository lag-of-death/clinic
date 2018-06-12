const db      = require(`./db`);
const rxjs    = require(`rxjs`);
const express = require(`express`);

const { of, fromPromise, forkJoin } = rxjs.Observable;

const delVisitSubject  = new rxjs.Subject();
const getVisitSubject  = new rxjs.Subject();
const newVisitSubject  = new rxjs.Subject();
const getVisitsSubject = new rxjs.Subject();

setUpDelStream(delVisitSubject);
setUpGetStream(getVisitSubject);
setUpGetStream(getVisitsSubject);
setUpCreateStream(newVisitSubject);

module.exports = express.Router()
                        .get(`/api/visits`, (req, res) => getVisitsSubject.next([req, res]))
                        .delete(`/api/visits/:id`, (req, res) => delVisitSubject.next([req, res]))
                        .get(`/api/visits/:id`, (req, res) => getVisitSubject.next([req, res]))
                        .post(`/api/visits`, (req, res) => newVisitSubject.next([req, res]));

function delVisitHandler(req, res) {
  return fromPromise(db.query(`delete from visit where id = $1`, [req.params.id]))
        .flatMap(() => of({ res }))
        .catch(err => of({ err, res }));
}

function newVisitHandler(req, res) {
  const { patientID, doctorID, nurseID, date, room } = req.body;

  const queryParams = [
    +new Date(date),
    patientID,
    doctorID,
    nurseID,
    room,
  ];

  const select = `
    select count(*) 
    from visit 
    where ((patient_id = $1 or doctor_id = $2 or nurse_id = $3) 
    and date = $5) 
    or (room = $4 and date = $5)
    `;

  const selectAsPromise = db.query(select, [patientID, doctorID, nurseID, room, +new Date(date)]);
  const selectAsStream  = fromPromise(selectAsPromise);

  return selectAsStream
        .flatMap((data) => {
          if (data[0].count >= 1) {
            return of({ res, err: true });
          } else {
            const insert = `
                 insert into visit (id, date, patient_id, doctor_id, nurse_id, room) 
                 values (nextval('visit_id_seq'), $1, $2, $3, $4, $5)`;

            const insertAsPromise = db.query(insert, queryParams);

            return fromPromise(insertAsPromise).flatMap(() => of({ res }));
          }
        });
}

function getVisitsHandler(req, res) {
  const promise = db.query(`
  select 
    visit.id, 
    visit.room,
    date,
    json_build_object('id', patient.id, 'personal', 
    json_build_object('id', pp.id, 'name', pp.name, 'surname', pp.surname, 'email', pp.email)) as patient,
    
    json_build_object('id', nurse.id, 'personal', 
    json_build_object('id', np.id, 'name', np.name, 'surname', np.surname, 'email', np.email), 
    'district', nurse.is_district_nurse) as nurse,
    
    json_build_object('id', doctor.id, 'personal', 
    json_build_object('id', dp.id, 'name', dp.name, 'surname', dp.surname, 'email', dp.email), 
    'speciality', doctor.speciality) as doctor
  
   from visit
   
   inner join patient on patient.id = visit.patient_id
   inner join person pp on pp.id = patient.person_id
   
   inner join doctor on doctor.id = visit.doctor_id
   inner join person dp on dp.id = doctor.person_id
   
   inner join nurse on nurse.id = visit.nurse_id
   inner join person np on np.id = nurse.person_id
   
   ${req.params.id ? `where visit.id = $1` : ``}
   order by date
   `, [req.params.id]);

  return forkJoin([
    fromPromise(promise),
    of(res),
    of(req),
  ]);
}

function setUpGetStream(stream) {
  return stream
        .flatMap(([req, res]) => getVisitsHandler(req, res))
        .subscribe(
            (data) => {
              const req    = data[2];
              const resp   = data[1];
              const visits = data[0];

              if (req.params.id) {
                resp.send(visits[0]);
              } else {
                resp.send(visits);
              }
            },
        );
}

function setUpDelStream(stream) {
  return stream
        .flatMap(([req, res]) => delVisitHandler(req, res))
        .subscribe(
            ({ res, err }) => {
              if (err) {
                res.send(err);
              } else {
                res.redirect(`/visits`);
              }
            },
        );
}

function setUpCreateStream(stream) {
  return stream
        .flatMap(([req, res]) => newVisitHandler(req, res))
        .subscribe(
            ({ res, err }) => {
              if (!err) {
                res.json(`Appointment was made.`);
              } else {
                res.status(422);
                res.json(`We are sorry, date or room for patient/nurse/doctor already reserved.`);
              }
            },
        );
}
