module Main exposing (..)

import Browser
import Html exposing (Html, button, div, h1, input, nav, span, text)
import Html.Attributes exposing (class, placeholder, type_)
import Html.Events exposing (onClick, onInput)
import Sidebar exposing (SidebarItem, SidebarModel, SidebarMsg, sidebar, updateSidebar)



---- MODEL ----


type CourseId
    = CourseId Int


type alias Course =
    { id : CourseId
    , title : String
    , price : Float
    }


type alias NavbarModel =
    { total : Float }


type alias Model =
    { sidebars : List SidebarModel
    , courses : List Course
    , searchText : Maybe String
    , navbar : NavbarModel
    }


init : ( Model, Cmd Msg )
init =
    ( Model
        [ { id = "repositories", name = "Repositories", icon = "fa-archive", items = [ SidebarItem "Item1" "#", SidebarItem "Item2" "#" ], collapsed = False }
        , { id = "items", name = "Items", icon = "fa-gears", items = [ SidebarItem "Item1" "#", SidebarItem "Item2" "#" ], collapsed = False }
        , { id = "services", name = "Services", icon = "fa-gear", items = [ SidebarItem "Item1" "#", SidebarItem "Item2" "#" ], collapsed = False }
        ]
        [ Course (CourseId 1) "test" 100.0
        , Course (CourseId 2) "test 2" 200.0
        , Course (CourseId 3) "Essentials 2" 400.0
        , Course (CourseId 4) "Essentials 2" 400.0
        , Course (CourseId 5) "Essentials 2" 450.0
        , Course (CourseId 6) "Essentials 2" 400.0
        , Course (CourseId 7) "Essentials 2" 200.0
        ]
        Nothing
        { total = 0 }
    , Cmd.none
    )



---- UPDATE ----


type NavbarMsg
    = SearchInput String


type Msg
    = SidebarMsg SidebarMsg
    | NavbarMsg NavbarMsg
    | BuyCourse CourseId


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SidebarMsg m ->
            ( { model | sidebars = List.map (updateSidebar m) model.sidebars }, Cmd.none )

        BuyCourse id ->
            let
                total =
                    List.filter (\x -> x.id == id) model.courses |> List.map .price |> List.sum
            in
            ( { model | navbar = { total = model.navbar.total + total } }, Cmd.none )

        NavbarMsg m ->
            case m of
                SearchInput input ->
                    ( { model | searchText = Just input }, Cmd.none )



---- VIEW ----


navbar : NavbarModel -> Html Msg
navbar model =
    nav [ class "flex justify-between items-center bg-white m-0 p-2 shadow-lg" ]
        [ div [ class "flex-initial w-1/2 mx-auto" ]
            [ input [ class "justify-center w-full border p-2 rounded", placeholder "Search courses", type_ "text", onInput (SearchInput >> NavbarMsg) ] []
            ]
        , div [ class "flex items-center" ]
            [ span [ class "tracking-wide" ] [ text "Total:" ], span [ class "pl-2 font-semibold" ] [ text <| String.fromFloat model.total, text "$" ] ]
        ]


view : Model -> Html Msg
view model =
    let
        courses =
            case model.searchText of
                Just filterText ->
                    List.filter (\x -> String.contains (String.toUpper filterText) (String.toUpper x.title)) model.courses

                Nothing ->
                    model.courses
    in
    div [ class "w-full" ]
        [ div [ class "flex" ]
            [ div [ class "flex-none w-64" ]
                [ Html.map SidebarMsg (sidebar model.sidebars)
                ]
            , div [ class "flex-grow" ]
                [ div [] [ navbar model.navbar ]
                , div [ class "flex" ] (List.map viewCourse courses)
                ]
            ]
        ]


viewCourse : Course -> Html Msg
viewCourse course =
    div [ class "m-2 p-2 shadow w-1/5 rounded border-l-4 border-blue-300 flex flex-col" ]
        [ h1 [ class "text-xl font-semibold tracking-wide leading-loose" ] [ text course.title ]
        , span [ class "text-sm text-gray-800" ] [ text "Price:" ]
        , span [ class "font-semibold text-sm text-gray-800" ] [ text <| String.fromFloat course.price ]
        , button
            [ class "mt-2 p-1 py-2 bg-indigo-700 hover:bg-indigo-500 text-indigo-200 rounded"
            , onClick <| BuyCourse course.id
            ]
            [ text "Buy" ]
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
