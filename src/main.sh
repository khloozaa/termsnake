#!/usr/bin/env bash
WD=28 HT=18 FL=${HOME:-.}/.termsnake_highscore
(( BASH_VERSINFO[0] > 4 )) || { echo "needs bash 5+" >&2; exit 1; }
read -r rw cl < <(stty size); (( cl && (cl < 2*WD || rw < HT+2) )) && { echo "Terminal too small: need $((2*WD))x$((HT+2))" >&2; exit 1; }
[[ -r $FL ]] && read -r bs < $FL; [[ $bs =~ ^[0-9]+$ ]] || bs=0
trap '(( sc > bs )) && bs=$sc; echo $bs > $FL; printf "\e[0m\e[?25h\e[?1049l"; stty echo' EXIT
trap 'exit 0' INT TERM
stty -echo; printf '\e[?1049h\e[?25l\e[2J'

P() { printf -v tx '\e[%d;%dH\e[48;5;%dm  ' $(($1/WD+1)) $(($1%WD*2+1)) $2; bf+=$tx; }
E() { P $1 $(( ($1%WD+$1/WD)%2 ? 236 : 234 )); }
S() { printf '\e[%d;1H\e[0m Score: %d   Best: %d   %s\e[K' $((HT+1)) $sc $bs "$mg"; }
F() { fr=(); for ((ix=0;ix<WD*HT;ix++)); do ((gr[ix])) || fr+=($ix); done; ((${#fr[@]})) || return 1; fd=${fr[(RANDOM<<15|RANDOM)%${#fr[@]}]}; P $fd 196; }

gm=0
while :; do
    if (( ! gm )); then
        gr=() bo=() tq=(); hd=0 tl=0 dx=1 dy=0 sc=0 dd=0 wn=0 ps=0 mg= bf=
        for ((ix=0;ix<WD*HT;ix++)); do gr[ix]=0; E $ix; done
        for cx in 8 9 10; do ce=$((HT/2*WD+cx)); bo[hd++]=$ce; gr[ce]=1; P $ce $((cx==10?46:34)); done
        F; printf '%s\e[0m' "$bf"; bf=; S; gm=1
    fi

    ms=$((150-sc*3)); ((ms<60)) && ms=60
    en=$((${EPOCHREALTIME/./}+ms*1000))
    while (( (lf=en-${EPOCHREALTIME/./}) > 0 )); do
        printf -v lf 0.%06d $lf
        IFS= read -rsn1 -t $lf ky || continue
        [[ $ky == $'\e' ]] && { IFS= read -rsn2 -t .01 rs || exit 0; case $rs in '[A') ky=w;; '[B') ky=s;; '[C') ky=d;; '[D') ky=a;; esac; }
        ky=${ky,,}
        [[ $ky == q ]] && exit 0
        [[ $ky == p || $ky == ' ' ]] && { ps=$((!ps)); mg=; ((ps)) && mg=PAUSED; S; continue; }
        ((ps)) && continue
        case $ky in w) nx=0 ny=-1;; s) nx=0 ny=1;; a) nx=-1 ny=0;; d) nx=1 ny=0;; *) continue;; esac
        lx=$dx ly=$dy; ((${#tq[@]})) && { lx=${tq[-1]% *}; ly=${tq[-1]#* }; }
        (( nx==lx && ny==ly || nx+lx==0 && ny+ly==0 || ${#tq[@]}>1 )) || tq+=("$nx $ny")
    done
    ((ps)) && continue

    ((${#tq[@]})) && { dx=${tq[0]% *}; dy=${tq[0]#* }; tq=("${tq[@]:1}"); }
    hc=${bo[hd-1]} tc=${bo[tl]}; cx=$((hc%WD+dx)) cy=$((hc/WD+dy)); nc=$((cy*WD+cx))
    dd=$(( cx<0 || cx>=WD || cy<0 || cy>=HT || gr[nc] && nc!=tc ))
    (( dd )) || {
        (( nc != fd )) && { gr[tc]=0; E $tc; unset 'bo[tl]'; ((tl++)); }
        P $hc 34; bo[hd++]=$nc; gr[nc]=1; P $nc 46
        (( nc == fd )) && { ((sc++)); F || { wn=1; dd=1; }; S; }
        printf '%s\e[0m' "$bf"; bf=
    }
    (( dd )) && {
        ((sc>bs)) && bs=$sc; mg="GAME OVER"; ((wn)) && mg="YOU WIN!"; S
        while :; do IFS= read -rsn1 ky || exit 0; [[ $ky == [qQ] ]] && exit 0; [[ $ky ]] || break; done
        gm=0
    }
done
