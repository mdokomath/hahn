(******************************************************************************)
(** * Operations on sets (unary relations) *)
(******************************************************************************)

Require Import HahnBase.
Require Import List Omega Classical Relations Setoid Morphisms.

Set Implicit Arguments.

(** Definitions of set operations *)
(******************************************************************************)

Section SetDefs.

  Variables A B : Type.
  Implicit Type f : A -> B.
  Implicit Type s : A -> Prop.
  Implicit Type ss : A -> B -> Prop.

  Definition set_empty       := fun x : A => False.
  Definition set_full        := fun x : A => True.
  Definition set_compl s     := fun x => ~ (s x).
  Definition set_union s s'  := fun x => s x \/ s' x.
  Definition set_inter s s'  := fun x => s x /\ s' x.
  Definition set_minus s s'  := fun x => s x /\ ~ (s' x).
  Definition set_subset s s' := forall x, s x -> s' x.
  Definition set_equiv s s'  := set_subset s s' /\ set_subset s' s.
  Definition set_finite s    := exists findom, forall x (IN: s x), In x findom.
  Definition set_coinfinite s:= ~ set_finite (set_compl s).
  Definition set_collect f s := fun x => exists y, s y /\ f y = x.
  Definition set_bunion s ss := fun x => exists y, s y /\ ss y x.

End SetDefs.

Arguments set_empty {A}.
Arguments set_full {A}.
Arguments set_subset {A}.
Arguments set_equiv {A}.

Notation "P ∪₁ Q" := (set_union P Q) (at level 50, left associativity, only parsing).
Notation "P ∩₁ Q" := (set_inter P Q) (at level 40, left associativity, only parsing).
Notation "P \₁ Q" := (set_minus P Q) (at level 46, only parsing).
Notation "∅₁"     := (@set_empty _) (only parsing).
Notation "a ⊆₁ b" := (set_subset a b) (at level 60, only parsing).
Notation "a ≡₁ b" := (set_equiv a b)  (at level 60, only parsing).
Notation "'⋃₁' x .. y , p" := 
  (set_bunion (fun _ => True) (fun x => .. (set_bunion (fun _ => True) (fun y => p)) ..))
  (at level 200, x binder, y binder, right associativity,
   format "'[' '⋃₁' '/ ' x .. y ,  '/ ' p ']'").
Notation "'⋃⋃₁' x < n , a" := (set_bunion (fun t => t < n) (fun x => a))
  (at level 200, x ident, right associativity).
Notation "'⋃⋃₁' x <= n , a" := (set_bunion (fun t => t <= n) (fun x => a))
  (at level 200, x ident, right associativity).

Notation "P ∪ Q" := (set_union P Q) (at level 50, left associativity) : function_scope.
Notation "P ∩ Q" := (set_inter P Q) (at level 40, left associativity) : function_scope.
Notation "P \ Q" := (set_minus P Q) (at level 46) : function_scope.
Notation "∅"     := (@set_empty _) : function_scope.
Notation "a ⊆ b" := (set_subset a b) (at level 60) : function_scope.
Notation "a ≡ b" := (set_equiv a b)  (at level 60) : function_scope.

Hint Unfold set_empty set_full set_compl set_union set_inter : unfolderDb.
Hint Unfold set_minus set_subset set_equiv set_coinfinite set_finite : unfolderDb.
Hint Unfold set_collect set_bunion : unfolderDb.

(** Basic properties of set operations *)
(******************************************************************************)

Section SetProperties.
  Local Ltac u :=
    autounfold with unfolderDb in *; ins; try solve [tauto | firstorder | split; ins; tauto].

  Variables A B : Type.
  Implicit Type a : A.
  Implicit Type f : A -> B.
  Implicit Type s : A -> Prop.
  Implicit Type ss : A -> B -> Prop.

  (** Properties of set complement. *)

  Lemma set_compl_empty : set_compl ∅₁ ≡₁ @set_full A.
  Proof. u. Qed.

  Lemma set_compl_full : set_compl (@set_full A) ≡₁ ∅₁.
  Proof. u. Qed.

  Lemma set_compl_compl s : set_compl (set_compl s) ≡₁ s.
  Proof. u. Qed.

  Lemma set_compl_union s s' :
    set_compl (s ∪₁ s') ≡₁ set_compl s ∩₁ set_compl s'.
  Proof. u. Qed.

  Lemma set_compl_inter s s' :
    set_compl (s ∩₁ s') ≡₁ set_compl s ∪₁ set_compl s'.
  Proof. u. Qed.

  Lemma set_compl_minus s s' :
    set_compl (s \₁ s') ≡₁ s' ∪₁ set_compl s.
  Proof. u. Qed.

  (** Properties of set union. *)

  Lemma set_unionA s s' s'' : (s ∪₁ s') ∪₁ s'' ≡₁ s ∪₁ (s' ∪₁ s'').
  Proof. u. Qed.

  Lemma set_unionC s s' : s ∪₁ s' ≡₁ s' ∪₁ s.
  Proof. u. Qed.

  Lemma set_unionK s : s ∪₁ s ≡₁ s.
  Proof. u. Qed.

  Lemma set_union_empty_l s : ∅₁ ∪₁ s ≡₁ s.
  Proof. u. Qed.

  Lemma set_union_empty_r s : s ∪₁ ∅₁ ≡₁ s.
  Proof. u. Qed.

  Lemma set_union_full_l s : set_full ∪₁ s ≡₁ set_full.
  Proof. u. Qed.

  Lemma set_union_full_r s : s ∪₁ set_full ≡₁ set_full.
  Proof. u. Qed.

  Lemma set_union_inter_l s s' s'' : (s ∩₁ s') ∪₁ s'' ≡₁ (s ∪₁ s'') ∩₁ (s' ∪₁ s'').
  Proof. u. Qed.

  Lemma set_union_inter_r s s' s'' : s ∪₁ (s' ∩₁ s'') ≡₁ (s ∪₁ s') ∩₁ (s ∪₁ s'').
  Proof. u. Qed.

  Lemma set_union_eq_empty s s' : s ∪₁ s' ≡₁ ∅ <-> s ≡₁ ∅ /\ s' ≡₁ ∅. 
  Proof. u. Qed.

  (** Properties of set intersection. *)

  Lemma set_interA s s' s'' : (s ∩₁ s') ∩₁ s'' ≡₁ s ∩₁ (s' ∩₁ s'').
  Proof. u. Qed.

  Lemma set_interC s s' : s ∩₁ s' ≡₁ s' ∩₁ s.
  Proof. u. Qed.

  Lemma set_interK s : s ∩₁ s ≡₁ s.
  Proof. u. Qed.

  Lemma set_inter_empty_l s : ∅₁ ∩₁ s ≡₁ ∅₁.
  Proof. u. Qed.

  Lemma set_inter_empty_r s : s ∩₁ ∅₁ ≡₁ ∅₁.
  Proof. u. Qed.

  Lemma set_inter_full_l s : set_full ∩₁ s ≡₁ s.
  Proof. u. Qed.

  Lemma set_inter_full_r s : s ∩₁ set_full ≡₁ s.
  Proof. u. Qed.

  Lemma set_inter_union_l s s' s'' : (s ∪₁ s') ∩₁ s'' ≡₁ (s ∩₁ s'') ∪₁ (s' ∩₁ s'').
  Proof. u. Qed.

  Lemma set_inter_union_r s s' s'' : s ∩₁ (s' ∪₁ s'') ≡₁ (s ∩₁ s') ∪₁ (s ∩₁ s'').
  Proof. u. Qed.

  Lemma set_inter_minus_l s s' s'' : (s \₁ s') ∩₁ s'' ≡₁ (s ∩₁ s'') \₁ s'.
  Proof. u. Qed.

  Lemma set_inter_minus_r s s' s'' : s ∩₁ (s' \₁ s'') ≡₁ (s ∩₁ s') \₁ s''.
  Proof. u. Qed.

  (** Properties of set minus. *)

  Lemma set_minusE s s' : s \₁ s' ≡₁ s ∩₁ set_compl s'.
  Proof. u. Qed.

  Lemma set_minusK s : s \₁ s ≡₁ ∅₁.
  Proof. u. Qed.

  Lemma set_minus_inter_l s s' s'' :
    (s ∩₁ s') \₁ s'' ≡₁ (s \₁ s'') ∩₁ (s' \₁ s'').
  Proof. u. Qed.

  Lemma set_minus_inter_r s s' s'' :
    s \₁ (s' ∩₁ s'') ≡₁ (s \₁ s') ∪₁ (s \₁ s'').
  Proof. u; split; ins; tauto. Qed.

  Lemma set_minus_union_l s s' s'' :
    (s ∪₁ s') \₁ s'' ≡₁ (s \₁ s'') ∪₁ (s' \₁ s'').
  Proof. u. Qed.

  Lemma set_minus_union_r s s' s'' :
    s \₁ (s' ∪₁ s'') ≡₁ (s \₁ s') ∩₁ (s \₁ s'').
  Proof. u. Qed.

  Lemma set_minus_minus_l s s' s'' :
    s \₁ s' \₁ s'' ≡₁ s \₁ (s' ∪₁ s'').
  Proof. u. Qed.

  Lemma set_minus_minus_r s s' s'' :
    s \₁ (s' \₁ s'') ≡₁ (s \₁ s') ∪₁ (s ∩₁ s'').
  Proof. u. Qed.

  (** Properties of set inclusion. *)

  Lemma set_subsetE s s' : s ⊆₁ s' <-> s \₁ s' ≡₁ ∅₁.
  Proof. u; intuition; apply NNPP; firstorder. Qed.

  Lemma set_subset_refl : reflexive _ (@set_subset A).
  Proof. u. Qed.

  Lemma set_subset_trans : transitive _ (@set_subset A).
  Proof. u. Qed.

  Lemma set_subset_empty_l s : ∅₁ ⊆₁ s.
  Proof. u. Qed.

  Lemma set_subset_empty_r s : s ⊆₁ ∅₁ <-> s ≡₁ ∅₁.
  Proof. u. Qed.

  Lemma set_subset_full_l s : set_full ⊆₁ s <-> s ≡₁ set_full.
  Proof. u. Qed.

  Lemma set_subset_full_r s : s ⊆₁ set_full.
  Proof. u. Qed.

  Lemma set_subset_union_l s s' s'' : s ∪₁ s' ⊆₁ s'' <-> s ⊆₁ s'' /\ s' ⊆₁ s''.
  Proof. u. Qed.

  Lemma set_subset_union_r1 s s' : s ⊆₁ s ∪ s'.
  Proof. u. Qed.

  Lemma set_subset_union_r2 s s' : s' ⊆₁ s ∪ s'.
  Proof. u. Qed.

  Lemma set_subset_union_r s s' s'' : s ⊆₁ s' \/ s ⊆₁ s'' -> s ⊆₁ s' ∪ s''.
  Proof. u. Qed.

  Lemma set_subset_inter_r s s' s'' : s ⊆₁ s' ∩₁ s'' <-> s ⊆₁ s' /\ s ⊆₁ s''.
  Proof. u. Qed.

  Lemma set_subset_compl s s' (S1: s' ⊆₁ s) : set_compl s ⊆₁ set_compl s'.
  Proof. u. Qed.

  Lemma set_subset_inter s s' (S1: s ⊆₁ s') t t' (S2: t ⊆₁ t') : s ∩₁ t ⊆₁ s' ∩₁ t'.
  Proof. u. Qed.

  Lemma set_subset_union s s' (S1: s ⊆₁ s') t t' (S2: t ⊆₁ t') : s ∪₁ t ⊆₁ s' ∪₁ t'.
  Proof. u. Qed.

  Lemma set_subset_minus s s' (S1: s ⊆₁ s') t t' (S2: t' ⊆₁ t) : s \₁ t ⊆₁ s' \₁ t'.
  Proof. u. Qed.

  Lemma set_subset_bunion_l s ss sb (H: forall x (COND: s x), ss x ⊆ sb) : set_bunion s ss ⊆ sb.
  Proof. u. Qed.

  Lemma set_subset_bunion_r s ss sb a (H: s a) (H': sb ⊆ ss a) : sb ⊆ set_bunion s ss.
  Proof. u. Qed.

  Lemma set_subset_bunion s s' (S: s ⊆₁ s') ss ss' (SS: forall x (COND: s x), ss x ⊆₁ ss' x) : 
    set_bunion s ss ⊆₁ set_bunion s' ss'.
  Proof. u. Qed.

  Lemma set_subset_bunion_guard s s' (S: s ⊆₁ s') ss ss' (EQ: ss = ss') : set_bunion s ss ⊆₁ set_bunion s' ss'.
  Proof. subst; u. Qed.

  Lemma set_subset_collect f s s' (S: s ⊆₁ s') : set_collect f s ⊆₁ set_collect f s'.
  Proof. u. Qed.

  (** Properties of set equivalence. *)

  Lemma set_equivE s s' : s ≡₁ s' <-> s ⊆₁ s' /\ s' ⊆₁ s.
  Proof. u; firstorder. Qed.

  Lemma set_equiv_refl : reflexive _ (@set_equiv A).
  Proof. u. Qed.

  Lemma set_equiv_symm : symmetric _ (@set_equiv A).
  Proof. u. Qed.

  Lemma set_equiv_trans : transitive _ (@set_equiv A).
  Proof. u. Qed.

  Lemma set_equiv_compl s s' (S1: s ≡₁ s') : set_compl s ≡₁ set_compl s'.
  Proof. u. Qed.

  Lemma set_equiv_inter s s' (S1: s ≡₁ s') t t' (S2: t ≡₁ t') : s ∩₁ t ≡₁ s' ∩₁ t'.
  Proof. u. Qed.

  Lemma set_equiv_union s s' (S1: s ≡₁ s') t t' (S2: t ≡₁ t') : s ∪₁ t ≡₁ s' ∪₁ t'.
  Proof. u. Qed.

  Lemma set_equiv_minus s s' (S1: s ≡₁ s') t t' (S2: t ≡₁ t') : s \₁ t ≡₁ s' \₁ t'.
  Proof. u. Qed.

  Lemma set_equiv_bunion s s' (S: s ≡₁ s') ss ss' (SS: forall x (COND: s x), ss x ≡₁ ss' x) : 
    set_bunion s ss ≡₁ set_bunion s' ss'.
  Proof. u. Qed.

  Lemma set_equiv_bunion_guard s s' (S: s ≡₁ s') ss ss' (EQ: ss = ss') : set_bunion s ss ≡₁ set_bunion s' ss'.
  Proof. subst; u. Qed.

  Lemma set_equiv_collect f s s' (S: s ≡₁ s') : set_collect f s ⊆₁ set_collect f s'.
  Proof. u. Qed.

  Lemma set_equiv_subset s s' (S1: s ≡₁ s') t t' (S2: t ≡₁ t') : s ⊆₁ t <-> s' ⊆₁ t'.
  Proof. u. Qed.

  Lemma set_equiv_exp s s' (EQ: s ≡₁ s') : forall x, s x <-> s' x.
  Proof. split; apply EQ. Qed.

  (** Absorption properties. *)

  Lemma set_union_absorb_l s s' (SUB: s ⊆₁ s') : s ∪₁ s' ≡₁ s'.
  Proof. u. Qed.

  Lemma set_union_absorb_r s s' (SUB: s ⊆₁ s') : s' ∪₁ s ≡₁ s'.
  Proof. u. Qed.

  Lemma set_inter_absorb_l s s' (SUB: s ⊆₁ s') : s' ∩₁ s ≡₁ s.
  Proof. u. Qed.

  Lemma set_inter_absorb_r s s' (SUB: s ⊆₁ s') : s ∩₁ s' ≡₁ s.
  Proof. u. Qed.

  Lemma set_minus_absorb_l s s' (SUB: s ⊆₁ s') : s \₁ s' ≡₁ ∅₁.
  Proof. u. Qed.

  (** Singleton sets *)

  Lemma set_subset_single_l a s : eq a ⊆₁ s <-> s a. 
  Proof. u; intuition; desf. Qed.

  Lemma set_subset_single_r a s :
    s ⊆₁ eq a <-> s ≡₁ eq a \/ s ≡₁ ∅₁.
  Proof.
    u; intuition; firstorder.
    destruct (classic (exists b, s b)) as [M|M]; desf.
       left; split; ins; desf; eauto.
       specialize (H _ M); desf.
    right; split; ins; eauto. 
  Qed.

  Lemma set_subset_single_single a b :
    eq a ⊆₁ eq b <-> a = b.
  Proof. u; intuition; desf; eauto using eq_sym. Qed.

  Lemma set_equiv_single_single a b :
    eq a ≡₁ eq b <-> a = b.
  Proof. u; intuition; desf; apply H; ins. Qed.

  Lemma set_nonemptyE s : ~ s ≡₁ ∅₁ <-> exists x, s x.
  Proof.
    u; intuition; firstorder.
    apply NNPP; intro; apply H0; ins; eauto. 
  Qed.

  (** Big union *)

  Lemma set_bunion_empty ss : set_bunion ∅ ss ≡₁ ∅.
  Proof. u. Qed.
  
  Lemma set_bunion_eq a ss : set_bunion (eq a) ss ≡₁ ss a.
  Proof. u; splits; ins; desf; eauto. Qed. 

  Lemma set_bunion_union_l s s' ss :
    set_bunion (s ∪₁ s') ss ≡₁ set_bunion s ss ∪₁ set_bunion s' ss.
  Proof. u. Qed. 

  Lemma set_bunion_union_r s ss ss' :
    set_bunion s (fun x => ss x ∪₁ ss' x) ≡₁ set_bunion s ss ∪₁ set_bunion s ss'.
  Proof. u. Qed. 

  Lemma set_bunion_inter_compat_l s sb ss ss' :
    set_bunion s (fun x => sb ∩₁ ss' x) ≡₁ sb ∩₁ set_bunion s ss'.
  Proof. u; split; ins; desf; eauto 8. Qed. 

  Lemma set_bunion_inter_compat_r s sb ss ss' :
    set_bunion s (fun x => ss' x ∩₁ sb) ≡₁ set_bunion s ss' ∩₁ sb.
  Proof. u; split; ins; desf; eauto 8. Qed. 

  Lemma set_bunion_minus_compat_r s sb ss ss' :
    set_bunion s (fun x => ss' x \₁ sb) ≡₁ set_bunion s ss' \₁ sb.
  Proof. u; split; ins; desf; eauto 8. Qed. 

  (** Collect *)

  Lemma set_collectE f s : set_collect f s ≡₁ set_bunion s (fun x => eq (f x)).
  Proof. u. Qed.

  Lemma set_collect_empty f : set_collect f ∅ ≡₁ ∅.
  Proof. u. Qed.
  
  Lemma set_collect_eq f a : set_collect f (eq a) ≡₁ eq (f a).
  Proof. u; splits; ins; desf; eauto. Qed. 

  Lemma set_collect_union f s s' :
    set_collect f (s ∪₁ s') ≡₁ set_collect f s ∪₁ set_collect f s'.
  Proof. u. Qed. 

  (** Finite sets *)

  Lemma set_finite_empty : set_finite (A:=A) ∅.
  Proof. exists nil; ins. Qed.

  Lemma set_finite_eq a : set_finite (eq a).
  Proof. exists (a :: nil); ins; desf; eauto. Qed.

  Lemma set_finite_le n : set_finite (fun t => t <= n).
  Proof. exists (List.seq 0 (S n)); intros; apply in_seq; ins; auto with arith. Qed.

  Lemma set_finite_lt n : set_finite (fun t => t < n).
  Proof. exists (List.seq 0 n); intros; apply in_seq; ins; auto with arith. Qed.

  Lemma set_finite_union s s' : set_finite (s ∪₁ s') <-> set_finite s /\ set_finite s'.
  Proof. 
    u; split; splits; ins; desf; eauto.
    eexists (_ ++ _); ins; desf; eauto using in_or_app.
  Qed.

  Lemma set_finite_unionI s (F: set_finite s) s' (F': set_finite s') : set_finite (s ∪₁ s').
  Proof. 
    u; desf; eauto; eexists (_ ++ _); ins; desf; eauto using in_or_app.
  Qed.

  Lemma set_finite_bunion s (F: set_finite s) ss :
    set_finite (set_bunion s ss) <-> forall a (COND: s a), set_finite (ss a).
  Proof. 
    u; split; ins; desf; eauto.
    revert s F H; induction findom; ins.
      by exists nil; ins; desf; eauto.
    specialize (IHfindom (fun x => s x /\ x <> a)); ins.
    specialize_full IHfindom; ins; desf; eauto.
      by apply F in IN; desf; eauto.
    tertium_non_datur (s a) as [X|X]. 
      eapply H in X; desf.
      eexists (findom0 ++ findom1); ins; desf. 
      tertium_non_datur (y = a); desf; eauto 8 using in_or_app.
    eexists findom0; ins; desf; apply IHfindom; eexists; splits; eauto; congruence.
  Qed.

End SetProperties.


Lemma set_finite_coinfinite_nat (s: nat -> Prop) :
  set_finite s -> set_coinfinite s.
Proof.
  assert (LT: forall l x, In x l -> x <= fold_right Init.Nat.add 0 l).
    induction l; ins; desf; try apply IHl in H; omega.
  autounfold with unfolderDb; red; ins; desf. 
  tertium_non_datur (s (S (fold_right plus 0 findom + fold_right plus 0 findom0))) as [X|X];
   [apply H in X | apply H0 in X]; apply LT in X; omega.
Qed.

Lemma set_coinfinite_fresh (s: nat -> Prop) (COINF: set_coinfinite s) :
  exists b, ~ s b /\ set_coinfinite (s ∪ eq b).
Proof.
  autounfold with unfolderDb in *.
  tertium_non_datur (forall b, s b).
    by destruct COINF; exists nil; ins; desf.
  exists n; splits; red; ins; desf.
  apply COINF; exists (n :: findom); ins; desf; eauto.
  specialize (H0 x); tauto.
Qed.

(** Add rewriting support. *)

Add Parametric Relation A : (A -> Prop) (set_subset (A:=A))
  reflexivity proved by (set_subset_refl (A:=A))
  transitivity proved by (set_subset_trans (A:=A))
  as set_subset_rel.

Add Parametric Relation A : (A -> Prop) (set_equiv (A:=A))
  reflexivity proved by (set_equiv_refl (A:=A))
  symmetry proved by (set_equiv_symm (A:=A))
  transitivity proved by (set_equiv_trans (A:=A))
  as set_equiv_rel.

Instance set_compl_Proper A : Proper (_ --> _) _ := set_subset_compl (A:=A).
Instance set_union_Proper A : Proper (_ ==> _ ==> _) _ := set_subset_union (A:=A).
Instance set_inter_Proper A : Proper (_ ==> _ ==> _) _ := set_subset_inter (A:=A).
Instance set_minus_Proper A : Proper (_ ++> _ --> _) _ := set_subset_minus (A:=A).
Instance set_bunion_Proper A B : Proper (_ ==> _ ==> _) _ := set_subset_bunion_guard (A:=A) (B:=B).

Instance set_compl_Propere A : Proper (_ ==> _) _ := set_equiv_compl (A:=A).
Instance set_union_Propere A : Proper (_ ==> _ ==> _) _ := set_equiv_union (A:=A).
Instance set_inter_Propere A : Proper (_ ==> _ ==> _) _ := set_equiv_inter (A:=A).
Instance set_minus_Propere A : Proper (_ ==> _ ==> _) _ := set_equiv_minus (A:=A).
Instance set_bunion_Propere A B : Proper (_ ==> _ ==> _) _ := set_equiv_bunion_guard (A:=A) (B:=B).
Instance set_subset_Proper A : Proper (_ ==> _ ==> _) _ := set_equiv_subset (A:=A).

Add Parametric Morphism A : (@set_finite A) with signature 
  set_subset --> Basics.impl as set_finite_mori.
Proof. red; autounfold with unfolderDb; ins; desf; eauto. Qed.

Add Parametric Morphism A : (@set_finite A) with signature 
  set_equiv ==> iff as set_finite_more.
Proof. red; autounfold with unfolderDb; splits; ins; desf; eauto. Qed.

Add Parametric Morphism A : (@set_coinfinite A) with signature 
  set_subset --> Basics.impl as set_coinfinite_mori.
Proof. unfold set_coinfinite; ins; rewrite H; ins. Qed.

Add Parametric Morphism A : (@set_coinfinite A) with signature 
  set_equiv ==> iff as set_coinfinite_more.
Proof. unfold set_coinfinite; ins; rewrite H; ins. Qed.

Add Parametric Morphism A B : (@set_collect A B) with signature 
  eq ==> set_subset ==> set_subset as set_collect_mori.
Proof. autounfold with unfolderDb; ins; desf; eauto. Qed.

Add Parametric Morphism A B : (@set_collect A B) with signature 
  eq ==> set_equiv ==> set_equiv as set_collect_more.
Proof. autounfold with unfolderDb; splits; ins; desf; eauto. Qed.

(** Add support for automation. *)

Lemma set_subset_refl2 A (x: A -> Prop) :  x ⊆₁ x. 
Proof. reflexivity. Qed.

Lemma set_equiv_refl2 A (x: A -> Prop) :  x ≡₁ x. 
Proof. reflexivity. Qed.

Hint Immediate set_subset_refl2.
Hint Resolve set_equiv_refl2.

Hint Rewrite set_compl_empty set_compl_full set_compl_compl : hahn.
Hint Rewrite set_compl_union set_compl_inter set_compl_minus : hahn.
Hint Rewrite set_union_empty_l set_union_empty_r set_union_full_l set_union_full_r : hahn.
Hint Rewrite set_inter_empty_l set_inter_empty_r set_inter_full_l set_inter_full_r : hahn.
Hint Rewrite set_bunion_empty set_bunion_eq : hahn.
Hint Rewrite set_collect_empty set_collect_eq : hahn.
Hint Rewrite set_finite_union : hahn.

Hint Rewrite set_inter_union_l set_inter_union_r set_union_eq_empty : hahn_full.
Hint Rewrite set_minus_union_l set_minus_union_r set_union_eq_empty : hahn_full.
Hint Rewrite set_subset_union_l set_subset_inter_r : hahn_full.
Hint Rewrite set_minusK set_interK set_unionK : hahn_full.
Hint Rewrite set_bunion_inter_compat_l set_bunion_inter_compat_r : hahn_full.
Hint Rewrite set_bunion_minus_compat_r : hahn_full.
Hint Rewrite set_bunion_union_l set_bunion_union_r : hahn_full.
Hint Rewrite set_collect_union : hahn_full. 

Hint Immediate set_subset_empty_l set_subset_full_r : hahn.
Hint Resolve set_subset_union_r : hahn.

Hint Immediate set_finite_empty set_finite_eq set_finite_le set_finite_lt : hahn. 
Hint Resolve set_finite_unionI set_finite_bunion : hahn.

