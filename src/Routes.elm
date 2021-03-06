module Routes
    exposing
        ( Route
            ( PatientId
            , Patients
            , NewPatient
            , Doctors
            , DoctorId
            , Nurses
            , NurseId
            , Visits
            , VisitId
            , NewVisit
            , NewNurse
            , NewDoctor
            , AllStaff
            )
        , parseRoute
        )

import Navigation exposing (Location)
import UrlParser exposing (int, top, (</>))


parseRoute : Location -> Maybe Route
parseRoute location =
    UrlParser.parsePath routeParser location


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


routeParser : UrlParser.Parser (Route -> a) a
routeParser =
    UrlParser.oneOf
        [ UrlParser.map Patients top
        , UrlParser.map Patients (UrlParser.s "patients")
        , UrlParser.map PatientId (UrlParser.s "patients" </> int)
        , UrlParser.map NewPatient (UrlParser.s "patients" </> UrlParser.s "new")
        , UrlParser.map Visits (UrlParser.s "visits")
        , UrlParser.map VisitId (UrlParser.s "visits" </> int)
        , UrlParser.map NewVisit (UrlParser.s "visits" </> UrlParser.s "new")
        , UrlParser.map Nurses (UrlParser.s "nurses")
        , UrlParser.map NurseId (UrlParser.s "nurses" </> int)
        , UrlParser.map NewNurse (UrlParser.s "nurses" </> UrlParser.s "new")
        , UrlParser.map Doctors (UrlParser.s "doctors")
        , UrlParser.map DoctorId (UrlParser.s "doctors" </> int)
        , UrlParser.map NewDoctor (UrlParser.s "doctors" </> UrlParser.s "new")
        , UrlParser.map AllStaff (UrlParser.s "all")
        ]
