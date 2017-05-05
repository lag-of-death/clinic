var nurses = [
    {
        speciality: "dialysis",
        name: "Anna",
        surname: "Novak",
        email: "anna@novak.com",
        id: 0,
        isDistrictNurse: false,
    },
    {
        speciality: "cardiac",
        name: "Marry",
        surname: "Lou",
        email: "marry@lou.de",
        id: 1,
        isDistrictNurse: true,
    }
];

module.exports = require('express').Router()
    .get('/api/nurses', getNursesHandler)
    .delete('/api/nurses/:id', delNurseHandler)
    .post('/api/nurses', newNurseHandler);

function getNursesHandler(req, res) {
    res.send(nurses);
}

function delNurseHandler(req, res) {
    nurses = Nurses.filter(doctor => doctor.id !== parseInt(req.params.id));

    res.send('OK');
}

function newNurseHandler(req, res) {
    res.send('OK');
}