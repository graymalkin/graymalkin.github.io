---
title: Simon Cooksey
subtitle: Research Scientist
toc: false
---

I am a Research Scientist working for NVIDIA in the Architecture Research Group.

## Publications
### Rust for Morello: Always-on Memory Safety, Even in Unsafe Code
Memory safety issues are a serious concern in systems programming.
Rust is a systems language that provides memory safety through a combination of a static checks embodied in the type system and ad hoc dynamic checks inserted where this analysis becomes impractical.
The Morello prototype architecture from ARM uses capabilities, fat pointers augmented with object bounds information, to catch failures of memory safety.
This paper presents a compiler from Rust to the Morello architecture, together with a comparison of the performance of Rust's runtime safety checks and the hardware-supported checks of Morello.
The cost of Morello's always-on memory safety guarantees is 39% in our 19 benchmark suites from the Rust crates repository (comprising 872 total benchmarks). For this cost, Morello's capabilities ensure that even unsafe Rust code benefits from memory safety guarantees.

<details class="pub">
<summary>
<div><i>Rust for Morello: Always-on Memory Safety, Even in Unsafe Code</i></div>
<br />
Sarah Harris, <b>Simon Cooksey</b>, Michael Vollmer, Mark Batty
</summary>
<a href="/papers/ecoop23.pdf" target="_blank">[PDF]</a> | <a href="https://github.com/kent-weak-memory/rust" target="_blank">[GitHub]</a>
<pre language="BibTeX">
@InProceedings{SHarris:2023,
  author ={Harris, Sarah and Cooksey, Simon and Vollmer, Michael and Batty, Mark},
  title ={{Rust for Morello: Always-On Memory Safety, Even in Unsafe Code}},
  booktitle ={37th European Conference on Object-Oriented Programming (ECOOP 2023)},
  pages ={39:1--39:27},
  series ={Leibniz International Proceedings in Informatics (LIPIcs)},
  ISBN ={978-3-95977-281-5},
  ISSN ={1868-8969},
  year ={2023},
  volume ={263},
  editor ={Ali, Karim and Salvaneschi, Guido},
  publisher ={Schloss Dagstuhl -- Leibniz-Zentrum f{\"u}r Informatik},
  address ={Dagstuhl, Germany},
  URL ={https://drops.dagstuhl.de/opus/volltexte/2023/18232},
  URN ={urn:nbn:de:0030-drops-182322},
  doi ={10.4230/LIPIcs.ECOOP.2023.39},
  annote ={Keywords: Compilers, Rust, Memory Safety, CHERI}
}</pre>
</details>

### Mixed-Proxy Extensions to NVIDIA PTX

An extension of NVIDIA's PTX ISA to support mixing load and store operations that target different proxies of memory. This gives well-defined semantics to programs with both, for example, constant loads and generic stores to the same address.
The memory model extension was built in the relational model checking tool, Alloy, and we showed that our extension to the PTX model is sound and complete with respect to the existing industrial model.

<details class="pub">
<summary>
<div><i>Mixed-Proxy Extensions for the NVIDIA PTX Memory Consistency Model</i></div>
<br />
★ <i>Honorable Mention, IEEE Micro Top Picks 2023!</i>
<br />
Daniel Lustig, <b>Simon Cooksey</b>, Olivier Giroux
</summary>
<a href="papers/isca22.pdf" target="_blank">[PDF]</a>
<pre language="BibTeX">@inproceedings{DLustig:2022,
  author = {Lustig, Daniel and Cooksey, Simon and Giroux, Olivier},
  title = {Mixed-Proxy Extensions for the NVIDIA PTX Memory Consistency Model: Industrial Product},
  booktitle = {Proceedings of the 49th Annual International Symposium on Computer Architecture},
  pages = {1058-1070},
  publisher = {Association for Computing Machinery},
  year = {2022},
  isbn = {9781450386104},
  address = {New York, NY, USA},
  url = {https://doi.org/10.1145/3470496.3533045},
  doi = {10.1145/3470496.3533045},
  numpages = {13},
  location = {New York, New York},
  series = {ISCA '22}
}</pre>
</details>


### Pomsets with Predicate Transformers

Pomsets with Predicate Transformers (PwT) is a recent fully denotational semantics for weak memory consistency.
It captures program dependencies by embedding a logic into predicate transformers which compose to create proof burdens necessary to remove dependencies which are syntactic only from list of dependencies actually present in a program.
I developed an OCaml tool to automatically evaluate PwT over a series of litmus tests. Appears in the proceedings of POPL 2022.

<details class="pub">
<summary>
<div><i>The Leaky Semicolon: Compositional Semantic Dependencies for Relaxed-Memory Concurrency</i></div>
<br >
Alan Jeffery, James Riely, Mark Batty, <b>Simon Cooksey</b>, Ilya Kaysin, Anton Podkopaev
</summary>
<a href="papers/popl22.pdf" target="_blank">[PDF]</a>
<pre language="BibTeX">@inproceedings{AJeffrey:2022,
  title={The Leaky Semicolon: Compositional Semantic Dependencies for Relaxed-Memory Concurrency},
  author={Jeffrey, Alan and Riely, James and Batty, Mark and Cooksey, Simon and Kaysin, Ilya and Podkopaev, Anton},
  booktitle={Proceedings of the 49th {ACM} {SIGPLAN} Symposium on Principles of Programming Languages, {POPL} 2022, Philadelphia, USA, January 18-20, 2022},
  editor={Rajeev Alur and Hongseok Yang},
  pages={54--84},
  publisher={{ACM}},
  year={2022},
  url={https://doi.org/10.1145/3498716}
}
</pre>
</details>

### Modular Relaxed Dependencies

Modular Relaxed Dependencies (MRD) is a denotational semantics for weak memory consistency in C and C++.
As well as helping to define the denotation, I built an evaluation tool (MRDer) in OCaml to enable fast calculation of the semantics against a corpus of litmus tests.
Further, I proved meta-theoretic properties about the semantics with respect to industry standard models of C/C++.

<details class="pub">
<summary>
<i>P2850: Minimal compiler preserved dependencies</i>.
ISO/IEC JTC1/SC22/WG21.
<br >
Mark Batty, <b>Simon Cooksey</b>
</summary>
<a href="/iso-papers/p2850/p2850r0.html" rel="noreferrer" target="_blank">Online working document</a>
<pre language="BibTeX">@techreport{MBatty:P2850,
    author="Batty, Mark and Cooksey, Simon",
    title="Minimal compiler preserved dependencies",
    institution="ISO/IEC JTC1/SC22/WG21",
    month="June",
    year="2023",
    number="P2850R0"
}</pre>
</details>

<details class="pub">
<summary>
<i>Modular Relaxed Dependencies in Weak Memory Concurrency</i>. 
ESOP 2020.
<br >
Marco Paviotti, <b>Simon Cooksey</b>, Anouk Paradis, Daniel Wright, Scott Owens, Mark Batty
</summary>
<a href="papers/esop20.pdf" target="_blank">[PDF]</a>
<pre language="BibTeX">@inproceedings{MPaviotti:ESOP20,
  title={Modular Relaxed Dependencies in Weak Memory Concurrency},
  author={Pavoitti, Marco and Cooksey, Simon and Paradis, Anouk and Wright, Daniel and Owens, Scott and Batty, Mark},
  booktitle="Programming Languages and Systems",
  editor="M{\"u}ller, Peter",
  year="2020",
  publisher="Springer International Publishing",
  address="Cham",
  pages="599--625",
}
</pre>
</details>

<details class="pub">
<summary>
<i>P1780R0: Modular Relaxed Dependencies: A new approach to the Out-Of-Thin-Air Problem</i>.
ISO/IEC JTC1/SC22/WG21.
<br >
Mark Batty, <b>Simon Cooksey</b>, Scott Owens, Anouk Paradis, Marco Paviotti, Daniel Wright
</summary>
<a href="https://wg21.link/p1780" rel="noreferrer" target="_blank">Online working document</a>
<pre language="BibTeX">@techreport{MBatty:P1780,
  author="Batty, Mark and Cooksey, Simon and Owens, Scott and Paradis, Anouk and Paviotti, Marco and Wright, Daniel",
  title="Modular Relaxed Dependencies: A new approach to the Out-Of-Thin-Air Problem",
  institution="ISO/IEC JTC1/SC22/WG21",
  month="June",
  year="2019",
  number="P1780R0"
}</pre>
</details>

### PrideMM

PrideMM is a tool written in OCaml which provides an API for building Second Order logical formulae and uses this API to express memory models.
We use cutting edge Quantified Boolean Formulae (QBF) solvers to efficiently simulate a new class of memory model which solve the thin-air problem.
We encode the problems in a high-level second order logic giving us flexibility in problem expression.
This then gets translated into a QBF model checking problem for a solver to efficiently execute.

<details class="pub">
<summary>
<i>PrideMM: Second Order Model Checking for Memory Consistency Models</i>. TAPAS 2019.
<br >
<b>Simon Cooksey</b>, Sarah Harris, Mary Batty, Radu Grigore, Mikoláš Janota
</summary>
<a href="papers/tapas19.pdf" target="_blank">[PDF]</a>
<pre language="BibTeX">@inproceedings{SCooksey:TAPAS19,
  author="Cooksey, Simon and Harris, Sarah and Batty, Mark and Grigore, Radu and Janota, Mikol\'{a}\v{s}",
  title="PrideMM: Second Order Model Checking for Memory Consistency Models",
  booktitle="10th Workshop on Tools for Automatic Program Analysis",
  year="2019"
}</pre>
</details>

## Grants
### Embedded Rust for Morello in Defence Applications
_Defence and Security Accelerator, 2023_

I am Principal Investigator for a grant of £87,763 (100% FEC) on a project to extend our Rust for Morello compiler to embedded targets on the Morello platform.

### Complementing Capabilities: Introducing Pointer-Safe Programming to DSbD Tech
_Innovate UK ICSF, 2022_

I am a Researcher Co-Investigator for a grant of £494,770 (80% FEC) responding to the Innovate UK call to extend the DSbD ecosystem with new CHERI-compatible software.
This work will be focussed on porting the Rust compiler to CHERI and formally demonstrating how the guarantees provided by Rust join up nicely with the guarantees of the capability hardware.

### Fixing the Thin-Air Problem: ISO Dissemination
_VeTSS, 2020_

I am a named researcher and co-author of a VeTSS grant of £60,455 (80% FEC) to pursue further integration of MRD into the ISO C++ Standard.
This grant funds travel to ISO meetings, and research time for me to prepare papers ahead of these meetings.

### CapC: Capability C Semantics, Tools and Reasoning
_Digital Security by Design, 2020_

I am a named researcher and co-author of a Digital Security by Design grant of £485,168 (80% FEC).
This is a longer term project to build verified concurrent libraries for the CHERI platform.
CHERI is an interesting extension to ARM where memory accesses are tagged with capabilities to keep code secure.

## Postgraduate
I completed my PhD in the Programming Languages and Systems group at the University of Kent.
I worked with my supervisor [Mark Batty][mark] researching weak memory behaviours and compiler verification.

In June 2020 I received the [Kent Postgraduate Prize][prize], recognising the impact of my research.

[mark]: https://www.kent.ac.uk/computing/people/3126/batty-mark
[prize]: https://blogs.kent.ac.uk/graduateschoolnews/2020/05/19/graduate-school-prizes-2020/

## Industrial Experience
### NVIDIA
As an intern at NVIDIA I extended the Memory Consistency Model for NVIDIA’s virtual instruction set (PTX) to support "memory views".
This enables writing well-defined programs which mix generic load and store operations with specialised load and store operations for texture, surface and constant accesses.

### XMOS
I worked for the Bristol based semiconductor company [XMOS][xmos].
XMOS produce a line of multi-core embedded processors called the xCORE.
I built tools and applications for the platform, including a port of an MP3 library, `lib_mp3` and adaptations to their debugging toolchain to enable remote debugging of hardware targets over the network, and to allow interfacing the debugger with a fast simulator.

[xmos]: https://www.xmos.com

## Undergraduate
I graduated from the University of Kent with a First in _Computer Science with a Year in Industry_.

### TinkerSoc
I was the president of [TinkerSoc][TinkerSoc], a society dedicated to making things, particularly electronics.

[TinkerSoc]: https://tinkersoc.org

## Contact
I am now on Mastodon at <a rel="me" href="https://types.pl/@graymalkin">\@graymalkin\@types.pl</a>.

You can contact me via email, [simon@graymalk.in](mailto:simon@graymalk.in).

My CV is available [here](./cv.pdf).

