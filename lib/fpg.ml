open Formule
open Automata
open Marqueur

type ('a, 'b) either =
  | Left of 'a
  | Right of 'b

type game_state =
  int * (T.SV.elt formule, (int * T.SV.elt formule) pbf) either

let deg s m =
  S.cardinal (snd (M.find s m))

exception Found_elem of int

let set_nth n s =
  try
    let _ = S.fold (fun x acc -> if acc = n then raise (Found_elem x) else acc+1) s 0 in
    failwith "elem not in set"
  with
  | Found_elem i -> i

let gsphi (m : (T.SV.t * S.t) M.t)  ((s,qt) : game_state) : game_state list =
  match qt with
  | Left q ->
     [(s, Right (tau (deg s m) (q, fst (M.find s m))))]
  | Right t ->
     match t with
     | Et_pbf (a,b) | Ou_pbf (a,b) ->
        [(s, Right a); (s, Right b)]
     | P_pbf (c,q) ->
        [(set_nth c (snd (M.find s m)),Left q)]
     | B_pbf _ -> []
