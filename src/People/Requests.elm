module People.Requests exposing (..)

import Http
import Json.Decode as Decode
import People.Types exposing (..)
import Requests exposing (..)


getPatients : Cmd PatientsMsg
getPatients =
    Http.send PatientsData (Http.get "/api/patients" decodePatients)


getPatient : Int -> Cmd PatientsMsg
getPatient id =
    Http.send PatientData (Http.get ("/api/patients/" ++ (toString id)) decodePatient)


getDoctors : Cmd DoctorsMsg
getDoctors =
    Http.send DoctorsData (Http.get ("/api/doctors") decodeDoctors)


getDoctor : Int -> Cmd DoctorsMsg
getDoctor id =
    Http.send DoctorData (Http.get ("/api/doctors/" ++ (toString id)) decodeDoctor)


getNurses : Cmd NursesMsg
getNurses =
    Http.send NursesData (Http.get ("/api/nurses") decodeNurses)


getNurse : Int -> Cmd NursesMsg
getNurse id =
    Http.send NurseData (Http.get ("/api/nurses/" ++ (toString id)) decodeNurse)


decodePerson : Decode.Decoder Person
decodePerson =
    Decode.map4 Person
        (Decode.field "name" Decode.string)
        (Decode.field "surname" Decode.string)
        (Decode.field "email" Decode.string)
        (Decode.field "id" Decode.int)


decodePatient : Decode.Decoder Patient
decodePatient =
    Decode.map2 Patient
        (Decode.field "personalData" decodePerson)
        (Decode.field "id" Decode.int)


decodePatients : Decode.Decoder (List Patient)
decodePatients =
    Decode.list decodePatient


decodePeople : Decode.Decoder (List Person)
decodePeople =
    Decode.list decodePerson


decodeDoctor : Decode.Decoder Doctor
decodeDoctor =
    Decode.map3 Doctor
        (Decode.field "personalData" decodePerson)
        (Decode.field "speciality" Decode.string)
        (Decode.field "id" Decode.int)


decodeDoctors : Decode.Decoder (List Doctor)
decodeDoctors =
    Decode.list decodeDoctor


decodeNurse : Decode.Decoder Nurse
decodeNurse =
    (Decode.map3 Nurse
        (Decode.field "personalData" decodePerson)
        (Decode.field "isDistrictNurse" Decode.bool)
        (Decode.field "id" Decode.int)
    )


decodeNurses : Decode.Decoder (List Nurse)
decodeNurses =
    Decode.list decodeNurse


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
