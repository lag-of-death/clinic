module Localization.Types exposing (Language(..), Locals, englishLocals, polishLocals)


type alias Locals =
    { patients : String
    , patient : String
    , all : String
    , nurses : String
    , nurse : String
    , room : String
    , doctors : String
    , doctor : String
    , visits : String
    , add : String
    , choose : String
    , date : String
    , staff : String
    , details : String
    , delete : String
    , roomNumber : String
    , districtNurse : String
    , surname : String
    , name : String
    , email : String
    , yes : String
    , no : String
    , id : String
    , speciality : String
    , newDoctor : String
    , newVisit : String
    , newPatient : String
    , areYouSure : String
    , error : String
    , newVisitErr : String
    , newVisitOk : String
    , cancel : String
    , ok : String
    , surgeon : String
    , pediatrician : String
    , laryngologist : String
    , dentist : String
    , endocrinologist : String
    , gastrologist : String
    , newNurse : String
    , day : String
    , hour : String
    , month : String
    , months :
        { january : String
        , february : String
        , march : String
        , april : String
        , may : String
        , june : String
        , july : String
        , august : String
        , september : String
        , october : String
        , november : String
        , december : String
        }
    }


polishLocals : Locals
polishLocals =
    { patients = "pacjenci"
    , patient = "pacjent"
    , nurses = "pielegniarki"
    , nurse = "pielęgniarka"
    , all = "wszyscy"
    , doctors = "lekarze"
    , doctor = "lekarz"
    , room = "pokój"
    , date = "data"
    , visits = "wizyty"
    , add = "dodaj"
    , choose = "wybierz"
    , staff = "personel"
    , delete = "usuń"
    , details = "szczegóły"
    , roomNumber = "numer pokoju"
    , districtNurse = "pielęgniarka środowiskowa"
    , surname = "nazwisko"
    , name = "imię"
    , email = "e-mail"
    , yes = "tak"
    , no = "nie"
    , id = "id"
    , speciality = "specjalizacja"
    , newDoctor = "nowy doktor"
    , newVisit = "nowa wizyta"
    , newPatient = "nowy pacjent"
    , newNurse = "nowa pielęgniarka"
    , areYouSure = "Czy jesteś pewien?"
    , error = "błąd"
    , ok = "ok"
    , cancel = "anuluj"
    , newVisitOk = "Wizyta została zarejestrowana."
    , newVisitErr = "Pacjent, pielęgniarka lub lekarz są juz umówieni na wizytę w wybranym terminie lub pokoju."
    , gastrologist = "gastrolog"
    , dentist = "dentysta"
    , endocrinologist = "endokrynolog"
    , laryngologist = "laryngolog"
    , pediatrician = "pediatra"
    , surgeon = "chirurg"
    , day = "dzień"
    , hour = "godzina"
    , month = "miesiąc"
    , months =
        { january = "styczeń"
        , february = "luty"
        , march = "marzec"
        , april = "kwiecień"
        , may = "maj"
        , june = "czerwiec"
        , july = "lipiec"
        , august = "sierpień"
        , september = "wrzesień"
        , october = "październik"
        , november = "listopad"
        , december = "grudzień"
        }
    }


englishLocals : Locals
englishLocals =
    { patients = "patients"
    , patient = "patient"
    , nurses = "nurses"
    , nurse = "nurse"
    , all = "all"
    , doctors = "doctors"
    , room = "room"
    , date = "date"
    , visits = "visits"
    , add = "add"
    , choose = "choose"
    , staff = "staff"
    , delete = "delete"
    , details = "details"
    , doctor = "doctor"
    , roomNumber = "room number"
    , districtNurse = "district nurse"
    , surname = "surname"
    , name = "name"
    , email = "email"
    , yes = "yes"
    , no = "no"
    , id = "id"
    , speciality = "speciality"
    , newDoctor = "new doctor"
    , newVisit = "new visit"
    , newPatient = "new patient"
    , newNurse = "new nurse"
    , areYouSure = "Are you sure?"
    , error = "error"
    , ok = "ok"
    , cancel = "cancel"
    , newVisitOk = "Appointment was made."
    , newVisitErr = "We are sorry, date or room for patient/nurse/doctor was already reserved."
    , gastrologist = "gastrologist"
    , dentist = "dentist"
    , endocrinologist = "endocrinologist"
    , laryngologist = "laryngologist"
    , pediatrician = "pediatrician"
    , surgeon = "surgeon"
    , day = "day"
    , month = "month"
    , hour = "hour"
    , months =
        { january = "January"
        , february = "February"
        , march = "March"
        , april = "April"
        , may = "May"
        , june = "June"
        , july = "July"
        , august = "August"
        , september = "September"
        , october = "October"
        , november = "November"
        , december = "December"
        }
    }


type Language
    = EN
    | PL
