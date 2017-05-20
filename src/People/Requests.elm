module People.Requests exposing (..)

import Http
import Json.Decode as Decode
import People.Types exposing (..)
import Requests exposing (..)


getPatients : Cmd PatientsMsg
getPatients =
    Http.send PatientsData (Http.get "/api/patients" decodePatients)


getDoctors : Cmd DoctorsMsg
getDoctors =
    Http.send DoctorsData (Http.get ("/api/doctors") decodeDoctors)


getNurses : Cmd NursesMsg
getNurses =
    Http.send NursesData (Http.get ("/api/nurses") decodeNurses)


decodePerson =
    Decode.map4 Person
        (Decode.field "name" Decode.string)
        (Decode.field "surname" Decode.string)
        (Decode.field "email" Decode.string)
        (Decode.field "id" Decode.int)


decodePatient =
    Decode.map Patient (Decode.field "personalData" decodePerson)


decodePatients =
    Decode.list decodePatient


decodePeople : Decode.Decoder (List Person)
decodePeople =
    Decode.list decodePerson


decodeDoctor =
    Decode.map2 Doctor
        (Decode.field "personalData" decodePerson)
        (Decode.field "speciality" Decode.string)


decodeDoctors : Decode.Decoder (List Doctor)
decodeDoctors =
    Decode.list decodeDoctor


decodeNurses : Decode.Decoder (List Nurse)
decodeNurses =
    Decode.list
        (Decode.map2 Nurse
            (Decode.field "personalData" decodePerson)
            (Decode.field "isDistrictNurse" Decode.bool)
        )


deleteDoctor : Int -> Cmd DoctorsMsg
deleteDoctor id =
    Http.send DoctorDeleted
        (delete "doctors" id)


deleteNurse : Int -> Cmd NursesMsg
deleteNurse id =
    Http.send NurseDeleted
        (delete "nurses" id)


deletePatient : Int -> Cmd PatientsMsg
deletePatient id =
    Http.send PatientDeleted
        (delete "patients" id)
