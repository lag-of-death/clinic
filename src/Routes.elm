module Routes exposing
    ( Route(..)
    , parseRoute
    )

import Url exposing (Url)
import Url.Parser exposing ((</>), int, top)


parseRoute : Url -> Maybe Route
parseRoute location =
    Url.Parser.parse routeParser location


type Route
    = PatientId Int
    | Patients
    | NewPatient
    | Doctors
    | DoctorId Int
    | Nurses
    | NurseId Int
    | Visits
    | VisitId Int
    | NewVisit
    | NewNurse
    | NewDoctor
    | AllStaff


routeParser : Url.Parser.Parser (Route -> a) a
routeParser =
    Url.Parser.oneOf
        [ Url.Parser.map Patients top
        , Url.Parser.map Patients (Url.Parser.s "patients")
        , Url.Parser.map PatientId (Url.Parser.s "patients" </> int)
        , Url.Parser.map NewPatient (Url.Parser.s "patients" </> Url.Parser.s "new")
        , Url.Parser.map Visits (Url.Parser.s "visits")
        , Url.Parser.map VisitId (Url.Parser.s "visits" </> int)
        , Url.Parser.map NewVisit (Url.Parser.s "visits" </> Url.Parser.s "new")
        , Url.Parser.map Nurses (Url.Parser.s "nurses")
        , Url.Parser.map NurseId (Url.Parser.s "nurses" </> int)
        , Url.Parser.map NewNurse (Url.Parser.s "nurses" </> Url.Parser.s "new")
        , Url.Parser.map Doctors (Url.Parser.s "doctors")
        , Url.Parser.map DoctorId (Url.Parser.s "doctors" </> int)
        , Url.Parser.map NewDoctor (Url.Parser.s "doctors" </> Url.Parser.s "new")
        , Url.Parser.map AllStaff (Url.Parser.s "all")
        ]
