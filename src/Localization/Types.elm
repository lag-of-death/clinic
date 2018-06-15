module Localization.Types exposing (..)


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
    , date : String
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
    }


polishLocals : Locals
polishLocals =
    { patients = "pacjenci"
    , patient = "pacjent"
    , nurses = "pielegniarki"
    , nurse = "pielegniarka"
    , all = "wszyscy"
    , doctors = "lekarze"
    , doctor = "lekarz"
    , room = "pokoj"
    , date = "data"
    , visits = "wizyty"
    , add = "dodaj"
    , choose = "wybierz"
    , staff = "personel"
    , delete = "usun"
    , details = "szczegoly"
    , roomNumber = "numer pokoju"
    , districtNurse = "pielegniarka srodowiskowa"
    , surname = "nazwisko"
    , name = "imie"
    , email = "email"
    , yes = "tak"
    , no = "nie"
    , id = "id"
    , speciality = "specjalizacja"
    , newDoctor = "nowy doktor"
    , newVisit = "nowa wizyta"
    , newPatient = "nowy pacjent"
    , newNurse = "nowa pielegniarka"
    , areYouSure = "czy napewno"
    , error = "blad"
    , ok = "ok"
    , cancel = "anuluj"
    , newVisitOk = "wizyta zarejestrowana"
    , newVisitErr = "pacjent, pielegniarka lub lekarz sa juz umowienia na wizyte w zaproponowanym terminie lub pokoju"
    , gastrologist = "gastrolog"
    , dentist = "dentysta"
    , endocrinologist = "endokrynolog"
    , laryngologist = "laryngolog"
    , pediatrician = "pediatra"
    , surgeon = "chirurg"
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
    , areYouSure = "are you sure"
    , error = "error"
    , ok = "ok"
    , cancel = "cancel"
    , newVisitOk = "appointment was made"
    , newVisitErr = "we are sorry, date or room for patient/nurse/doctor already reserved"
    , gastrologist = "gastrologist"
    , dentist = "dentist"
    , endocrinologist = "endocrinologist"
    , laryngologist = "laryngologist"
    , pediatrician = "pediatrician"
    , surgeon = "surgeon"
    }


type Language
    = EN
    | PL
