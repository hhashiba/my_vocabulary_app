module Main exposing (main)

import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Nav
import Css
import Html exposing (Html, a, div, h1, text)
import Html.Attributes exposing (href)
import Page.Edit as Edit
import Page.ListPage as ListPage
import Page.Register as Register
import Page.Top as Top
import Route exposing (Route)
import Url exposing (Url)


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }


type alias Model =
    { page : Page
    , route : Route
    , navKey : Nav.Key
    }


type Page
    = NotFoundPage
    | TopPage Top.Model
    | ListPage ListPage.Model
    | RegisterPage Register.Model
    | EditPage Edit.Model


type Msg
    = ListPageMsg ListPage.Msg
    | RegisterPageMsg Register.Msg
    | EditPageMsg Edit.Msg
    | LinkClicked UrlRequest
    | UrlChanged Url


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init () url navKey =
    let
        model =
            { page = NotFoundPage
            , route = Route.parseUrl url
            , navKey = navKey
            }
    in
    initCurrentPage ( model, Cmd.none )


initCurrentPage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
initCurrentPage ( model, cmd ) =
    let
        ( currentPage, mappedCmds ) =
            case model.route of
                Route.Top ->
                    ( TopPage Top.init, Cmd.none )

                Route.List language ->
                    let
                        ( pageModel, pageCmd ) =
                            ListPage.init language
                    in
                    ( ListPage pageModel
                    , Cmd.map ListPageMsg pageCmd
                    )

                Route.Register ->
                    let
                        ( pageModel, pageCmd ) =
                            Register.init model.navKey
                    in
                    ( RegisterPage pageModel
                    , Cmd.map RegisterPageMsg pageCmd
                    )

                Route.Word language wordId ->
                    let
                        ( pageModel, pageCmd ) =
                            Edit.init language wordId model.navKey
                    in
                    ( EditPage pageModel
                    , Cmd.map EditPageMsg pageCmd
                    )

                _ ->
                    ( TopPage Top.init, Cmd.none )
    in
    ( { model | page = currentPage }
    , Cmd.batch [ cmd, mappedCmds ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( ListPageMsg pageMsg, ListPage pageModel ) ->
            let
                ( updatePageModel, updateCmd ) =
                    ListPage.update pageMsg pageModel
            in
            ( { model | page = ListPage updatePageModel }
            , Cmd.map ListPageMsg updateCmd
            )

        ( RegisterPageMsg pageMsg, RegisterPage pageModel ) ->
            let
                ( updatePageModel, updateCmd ) =
                    Register.update pageMsg pageModel
            in
            ( { model | page = RegisterPage updatePageModel }
            , Cmd.map RegisterPageMsg updateCmd
            )

        ( EditPageMsg pageMsg, EditPage pageModel ) ->
            let
                ( updatePageModel, updatePageCmd ) =
                    Edit.update pageMsg pageModel
            in
            ( { model | page = EditPage updatePageModel }
            , Cmd.map EditPageMsg updatePageCmd
            )

        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.navKey (Url.toString url) )

                Browser.External _ ->
                    ( model, Cmd.none )

        ( UrlChanged url, _ ) ->
            let
                newRoute =
                    Route.parseUrl url
            in
            initCurrentPage <|
                ( { model | route = newRoute }, Cmd.none )

        ( _, _ ) ->
            ( model, Cmd.none )


view : Model -> Document Msg
view model =
    { title = "My Vocabulary"
    , body =
        [ viewHeader
        , currentView model.page
        ]
    }


viewHeader : Html Msg
viewHeader =
    div
        Css.mainViewHeaderStyle
        [ h1
            Css.mainViewHeaderH1Style
            [ a
                (href "/" :: Css.mainViewHeaderAStyle)
                [ text "My Vocabulary" ]
            ]
        ]


currentView : Page -> Html Msg
currentView page =
    case page of
        TopPage pageModel ->
            Top.view pageModel

        ListPage pageModel ->
            ListPage.view pageModel
                |> Html.map ListPageMsg

        RegisterPage pageModel ->
            Register.view pageModel
                |> Html.map RegisterPageMsg

        EditPage pageModel ->
            Edit.view pageModel
                |> Html.map EditPageMsg

        _ ->
            text "Oops"
