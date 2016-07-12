module TreeView.Models exposing (..)

import Style
import Style.Properties exposing (..)
import Color exposing (rgba)
import Time exposing (second)

type alias TreeNodeId = String
type alias IndentLevel = Int

type alias TreeNode a =
  { id: TreeNodeId,
    name: String,
    expanded: Bool,
    selected: Bool,
    parent: Maybe TreeNodeId,
    userData: a,
    style: Style.Animation
  }

type alias TreeModel a = List (TreeNode a)

initialStyle: Style.Animation
initialStyle =
  Style.init [ MaxHeight 9999999 Px ]
 -- Style.init [ MaxHeight 0.0 Px ]

initialModel: TreeModel a
initialModel =
  []

getSelectedNode : TreeModel a -> Maybe (TreeNode a)
getSelectedNode model =
  let
    filtered = List.filter (\n -> n.selected) model
  in
    List.head filtered

findNode : (TreeNode a -> Bool) -> TreeModel a -> Maybe (TreeNode a)
findNode matcher model =
  List.filter matcher model
    |> List.head

findNodeById : TreeNodeId -> TreeModel a -> Maybe (TreeNode a)
findNodeById nodeId model =
  findNode (\n -> n.id == nodeId) model

selectNodeAndExpandParents : TreeNode a -> TreeModel a -> TreeModel a
selectNodeAndExpandParents node model =
  let
    parents = getParents node model
    handleNode = \n ->
      if n.id == node.id then
          setSelected True n
      else if List.member n parents then
          setSelected False n
            |> expandCollapse n.id True
      else
          setSelected False n
  in
    List.map handleNode model

getParents : TreeNode a -> TreeModel a -> List (TreeNode a)
getParents node model =
  case node.parent of
    Nothing ->
      []
    Just parentId ->
      let
        parentNode = findNodeById parentId model
      in
        case parentNode of
          Nothing ->
            -- should never happen if model invariant is good
            []
          Just n ->
            -- parent exists, let's recurse...
            [ n ] ++ (getParents n model)

setSelected : Bool -> TreeNode a -> TreeNode a
setSelected selected node =
  if node.selected == selected then
    node
  else
    { node | selected = selected }

deselectAll : TreeModel a -> TreeModel a
deselectAll model =
  let
    deselect = setSelected False
  in
    List.map deselect model

expandCollapse: TreeNodeId -> Bool -> TreeNode a -> TreeNode a
expandCollapse nodeId expanded n =
  -- let
  --   (newProp, duration) = case expanded of
  --     True ->
  --       (MaxHeight 99999999 Px, 1*second)
  --     False ->
  --       (MaxHeight 0 Px, 0.5*second)
  --
  --   newStyle =
  --     Style.animate
  --       |> Style.duration duration
  --       |> Style.easing (\x -> x^10)
  --       |> Style.to [ newProp ]
  --       |> Style.on n.style
  -- in
  --   if n.id == nodeId then
  --     { n | expanded = expanded
  --         , style = newStyle }
  --   else
  --     n
  if n.id == nodeId then
    { n | expanded = expanded }
  else
    n
