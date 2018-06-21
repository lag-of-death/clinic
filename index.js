const express    = require(`express`);
const spa        = require(`express-spa`);
const bodyParser = require(`body-parser`);

const nursesRouter   = require(`./src-server/nurses`);
const doctorsRouter  = require(`./src-server/doctors`);
const patientsRouter = require(`./src-server/patients`);
const visitsRouter   = require(`./src-server/visits`);
const staffRouter    = require(`./src-server/staff`);

const port      = process.env.PORT || 5000;
const publicDir = `${__dirname}/public`;

express()
    .use(bodyParser.urlencoded({ extended: true }))
    .use(bodyParser.json())
    .use(nursesRouter)
    .use(doctorsRouter)
    .use(patientsRouter)
    .use(visitsRouter)
    .use(staffRouter)
    .use(express.static(publicDir))
    .use(spa(`${publicDir}/index.html`))
    .get(`*`, (req, res) => {
      if (req.url.split(`.`)[1] === `css`) {
        res.sendFile(`${publicDir}/styles.css`);
      } else {
        res.sendFile(`${publicDir}/index.js`);
      }
    })
    .listen(port, () => console.log(`Node app is running on port`, port));
