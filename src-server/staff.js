const rxjs = require(`rxjs`);
const express = require(`express`);
const request = require(`request`);

const getStaffSubject = new rxjs.Subject();
const get = rxjs.Observable.bindNodeCallback(request);

const getNursesStream = get(`${process.env.HOSTNAME}/api/nurses`);
const getDoctorsStream = get(`${process.env.HOSTNAME}/api/doctors`);

const nursesSteam = getNursesStream.map(data => data[1])
                                   .map(JSON.parse)
                                   .map(data => data.map(toPerson.bind(null, `nurse`)))
                                   .timeout(5000)
                                   .catch(() => rxjs.Observable.of(``));

const doctorsStream = getDoctorsStream.map(data => data[1])
                                      .map(JSON.parse)
                                      .map(data => data.map(toPerson.bind(null, `doctor`)))
                                      .timeout(5000)
                                      .catch(() => rxjs.Observable.of(``));

getStaffSubject
    .flatMap(res =>
        rxjs.Observable
            .forkJoin(nursesSteam, doctorsStream, rxjs.Observable.of(res))
            .catch(() => rxjs.Observable.of([`no data`, `no data`, res])),
    )
    .subscribe(
        (data) => {
          const lastItemIdx = data.length - 1;
          const resp = data[lastItemIdx];
          const nursesAndDoctors = data.splice(0, lastItemIdx);

          resp.send(nursesAndDoctors[0].concat(nursesAndDoctors[1]));
        },
    );

module.exports = express.Router()
                        .get(`/api/staff`, (req, res) => getStaffSubject.next(res));

function toPerson(who, person) {
  return {
    id: person.id,
    personal: person.personal,
    who,
  };
}
