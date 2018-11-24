const rxjs = require(`rxjs`);
const db   = require(`./db`);

module.exports = {
  setUpDelStream,
  setUpCreateStream,
  setUpGetStream,
};

function delEntity(req, res, entityName) {
  return rxjs.Observable
               .fromPromise(
                   db.tx(() =>
                       db.query(`delete from ${entityName} where id = $1 returning person_id`, [req.params.id])
                         .then(data => db.query(`delete from person where id = $1`, [data[0].person_id])),
                   ),
               )
               .flatMap(() => rxjs.Observable.of(res));
}

function createEntity(req, res, callback, passedQuery) {
  const query = `
    insert into person (email, name, surname, id) 
    values ($1, $2, $3, nextval('person_id_seq')) returning id`;

  return rxjs.Observable
               .fromPromise(
                   db.tx(() =>
                       db.query(
                           query,
                           [req.body[`e-mail`], req.body.name, req.body.surname])
                         .then(data => passedQuery(data, db)), [],
                   ),
               )
               .flatMap(() => rxjs.Observable.of(res));
}

function getEntities(req, res, entityName, entityFields = []) {
  const additionalFields =
              entityFields.length
                  ? `, ${entityFields.map(field => `${entityName}.${field}`).join(`,`)}`
                  : ``;

  const query = `
    SELECT 
        ${entityName}.id, 
        json_build_object('name', name, 'surname', surname, 'email', email, 'id', person.id) as personal             
        ${additionalFields} from ${entityName} 
        inner join person on person.id = person_id 
        ${req.params.id ? `where ${entityName}.id = $1` : ``} 
        order by surname`;

  const queryObservable = rxjs.Observable.fromPromise(db.query(query, [req.params.id]));

  return rxjs.Observable.forkJoin(
        queryObservable,
        rxjs.Observable.of(res),
        rxjs.Observable.of(req),
    );
}

function setUpGetStream(subject, entityName, optionalAttrs) {
  return subject.flatMap(([req, res]) => getEntities(req, res, entityName, optionalAttrs))
                  .subscribe(
                      (data) => {
                        const resp   = data[1];
                        const req    = data[2];
                        const people = data[0];

                        resp.send(req.params.id ? people[0] : people);
                      },
                      (err) => {
                        throw `Should never get here. Add timeout for this. ${err}`;
                      },
                  );
}

function setUpDelStream(subject, entityName) {
  return subject
        .flatMap(([req, res]) => delEntity(req, res, entityName))
        .subscribe(
            (resp) => {
              resp.send(`OK`);
            },
            () => {
              throw `should never get here`;
            },
        );
}

function setUpCreateStream(subject, url, callback) {
  return subject
        .flatMap(([req, res]) => createEntity(req, res, `patients`, callback(req)))
        .subscribe(
            (resp) => {
              resp.redirect(`/${url}`);
            },
        );
}
