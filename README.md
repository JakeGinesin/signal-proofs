Formally verifying Signal's [PQXDH](https://signal.org/docs/specifications/pqxdh/) + [Double Ratchet](https://signal.org/docs/specifications/doubleratchet/) with [ProVerif](https://en.wikipedia.org/wiki/ProVerif). Honestly I think the existing state-of-the-art models of Signal in the symbolic cryptographic model [make no sense](https://github.com/Inria-Prosecco/pqxdh-analysis) and aren't clean at all. So, this exists. I also mechanized [previous offline initiator deniability results for PQXDH](https://eprint.iacr.org/2024/741.pdf).

In sum, I prove:
- secrecy, authentication, and forward secrecy for [X3DH](https://signal.org/docs/specifications/x3dh/) in `x3dh.pv`
- secrecy, authentication, forward secrecy, and post-quantum forward secrecy for PQXDH in `pqxdh.pv`
- secrecy, authentication, forward secrecy, and post-quantum forward secrecy for PQXDH composed with Double Ratchet in `signal.pv`
- post-compromise security for PQXDH composed with Double Ratchet in `signal-pcs.pv`
- deniability for the initiator in the offline judge model for PQXDH composed with Double Ratchet in `signal-initiator-deny.pv`. 
- showing deniability for the responder in the offline judge model does not hold for PQXDH with Double Ratchet in `signal-initiator-nodeny.pv`

# Environment Setup
1. Install the [nix package manager](https://nixos.org/download/)
2. Navigate to the current directory, and run `nix develop`. You will get dropped into a devshell with the correct version of [ProVerif](https://en.wikipedia.org/wiki/ProVerif). Feel free to execute another shell (i.e. `zsh`) if you have something against `bash`.

# Notes on Proverif reachability
In each model, there exists several queries designed to ensure reachability and no deadlocks. First, 
each model has an event "start" that is positioned *before* the PeerA/PeerB processes begin. We simply check `query event(start())`, which asks ProVerif if it is the case `NOT event(start)`. This query will always return *false* because in every possible execution of the protocol, `event start()` is triggered. Thus, broadly, testing reachability involves ensuring `query event(event-name())` always resolves to false. 

This flavor of query is present in each model and highly necessary, as it ensures other properties are never trivially violated or trivially satisfied.

# Notes on Proverif deniability
To reason about deniability, I use observational equivalence with an offline attacker to judge a scenario where the initiator (or responder) attempts to simulate a transcript without knowing the identifying private key material. This technique was used twice before, for [KEMTLS](https://eprint.iacr.org/2022/1111) in [Tamarin](https://en.wikipedia.org/wiki/Tamarin_Prover) and [Wireguard](https://eprint.iacr.org/2025/1179) in [SAPIC+](https://www.usenix.org/conference/usenixsecurity22/presentation/cheval) (which exports to both Proverif and Tamarin).
