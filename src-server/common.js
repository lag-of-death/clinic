const rxjs = require(`rxjs`);
const db = require(`./db`);

module.exports = {
  delEntity,
  createEntity,
  getEntities,
};

function delEntity(req, res, entityName) {
  rxjs.Observable
        .fromPromise(
            db.tx(() =>
                db.query(`delete from ${entityName} where id = $1 returning person_id`, [req.params.id])
                  .then(data => db.query(`delete from person where id = $1`, [data[0].person_id])),
            ),
        )
        .subscribe(
            () => res.send(`OK`),
            (err) => {
              console.log(`ERR`, err);

              res.send(`ERR`);
            },
        );
}

function createEntity(req, res, callback, passedQuery) {
  const query = `insert into person (email, name, surname, id) values ($1, $2, $3, nextval('person_id_seq')) returning id`;

  rxjs.Observable
        .fromPromise(
            db.tx(() => db.query(query, [req.body.email, req.body.name, req.body.surname])
                           .then(data => passedQuery(data, db)), [],
            ),
        )
        .subscribe(
            (data) => {
              console.log(data);

              res.redirect(`/${callback}`);
            },
            (err) => {
              console.log(`ERR`, err);

              res.redirect(`/${callback}`);
            },
        );
}

function getEntities(req, res, entityName, entitiFields = []) {
  const additionalFields = entitiFields.length ? `, ${entitiFields.map(field => `${entityName}.${field}`).join(`,`)}` : ``;
    const query          = `SELECT ${entityName}.id, json_build_object('name', name, 'surname', surname, 'email', email, 'id', person.id) as personal ${additionalFields} from ${entityName} inner join person on person.id = person_id ${req.params.id ? `where ${entityName}.id = $1` : ``} order by surname`;

  return rxjs.Observable
               .fromPromise(db.query(query, [req.params.id]))
               .subscribe(
                   data =>
                       res.send(req.params.id ? data[0] : data),
                   (err) => {
                     console.log(`ERR`, err);

                     res.send(err);
                   },
               );
}
