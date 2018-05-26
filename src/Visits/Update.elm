module Visits.Update exposing (updateVisits, updateNewVisit)

import Visits.Requests exposing (getVisits, newVisit, deleteVisit)
import Visits.Types as VT
import Navigation as Nav
import Visits.Helpers


updateNewVisit : VT.NewVisitMsg -> VT.NewVisitModel -> ( VT.NewVisitModel, Cmd VT.NewVisitMsg  )
updateNewVisit msg model =
    case msg of
        VT.NoNewVisitOp ->
            ( model, Cmd.none )

        VT.SetPatient id ->
            ( { model | patientID = id }, Cmd.none )

        VT.SetDoctor id ->
            ( { model | doctorID = id }, Cmd.none )

        VT.SetNurse id ->
            ( { model | nurseID = id }, Cmd.none )

        VT.SetRoom room ->
            ( { model | room = room }, Cmd.none )

        VT.SetDate date ->
            ( { model | date = date }, Cmd.none )

        VT.SendNewVisit ->
            ( model, newVisit model )

        _ ->
            ( model, Cmd.none )


updateVisits : VT.VisitsMsg -> List VT.Visit -> ( List VT.Visit, Cmd VT.VisitsMsg, VT.VisitsMsg )
updateVisits msg model =
    case msg of
        VT.NoVisitsOp ->
            ( model, Cmd.none, VT.NoVisitsOp )

        VT.NewVisitsUrl url ->
            ( model, Nav.newUrl url, VT.NoVisitsOp )

        VT.VisitsData (Ok visits) ->
            ( visits
            , Cmd.none
            , VT.NoVisitsOp
            )

        VT.VisitData (Err _) ->
            ( model, Cmd.none, VT.NoVisitsOp )

        VT.VisitData (Ok visit) ->
            ( Visits.Helpers.addVisit model visit
            , Cmd.none
            , VT.NoVisitsOp
            )

        VT.VisitDeleted _ ->
            ( model, getVisits, VT.NoVisitsOp )

        VT.VisitsData (Err _) ->
            ( model, Cmd.none, VT.NoVisitsOp )

        VT.DelVisit id ->
            ( model, Cmd.none, VT.ReallyDelVisit id )

        VT.ReallyDelVisit id ->
            ( model, deleteVisit id, VT.NoVisitsOp )
