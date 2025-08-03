
# Platforma de Monitorizare a Starii unui Sistem

## Scopul Proiectului
- [Descriere detaliata a scopului proiectului. ]

### Arhitectura proiectului
Acest subpunct este OPTIONAL.
- [Desenati in excalidraw sau in orice tool doriti arhitectura generala a proiectului si includeti aici poza cu descrierea pasilor]

## Structura Proiectului
[Aici descriem rolul fiecarui director al proiectului. Descrierea trebuie sa fie foarte pe scurt la acest pas. O sa intrati in detalii la pasii urmatori.]
- `/scripts`: [Puneti aici ce rol are directorul de scripturi si ce face fiecare script]
- `/docker`: [Descriere Dockerfiles și docker-compose.yml. Aici descrieti legatura dintre fiecare Dockerfile si scripturile de mai sus (vedeti comentariul din fiecare Dockerfile)]
- `/ansible`: [Descriere playbook-uri și inventory]
- `/jenkins`: [Descrierea rolului acestui director si a subdirectoarelor.]
- `/terraform`: [Descriere configurare Terraform]

## Setup și Rulare
- [Instrucțiuni de setup local și remote. Aici trebuiesc puse absolut toate informatiile necesare pentru a putea instala si rula proiectul pe o instanta de Ubuntu complet noua. De exemplu listati aici si ce tool-uri trebuiesc instalate (Ansible, SSH config, useri, maisini virtuale noi, etc) pasii de instal si poze].
- [Includeti aici pasii detaliati de rulat Ansible (comenzi si poze)]
- [Cum verificam ca totul a rulat cu succes? Cateva comenzi prin care verificam ca Ansible a instalat ce trebuia (si poze) ]

## CI/CD și Automatizari
- [Descriere pipeline-uri Jenkins. Puneti aici cat mai detaliat ce face fiecare pipeline de jenkins cu poze facute la build-urile rulate. Detaliati cat puteti de mult procesul de CI/CD folosit.]
- Poze si detalii cu restul cerintelor de Ci/CD (cum ati creat userul nou ce are access doar la resurseel proiectului, cum ati creat un View now pentru proiect, etc)
- Daca ati implementat si punctul E optional atunci detaliati si setupul de minikube.


## Terraform și AWS
- [Instrucțiuni pentru rularea Terraform și configurarea AWS]
- [Daca o sa folositi pentru testare localstack in loc de AWS real puneti aici toti pasii pentru install localstack.]
- [FOARTE IMPORTANT: Listati aici pas cu pas cum ati rulat si testat aplicatia, cu instructiunile folosite si poze concrete ale rularilor voastre.] 

## Depanare si investigarea erorilor
- [Unde sunt logate mesajele]
- [Orice considerati util ca informatie legat de logare]
- [Cum accesam logurile aplicatiei si cum ne logam pe fiecare container pentru eventualele depanari de probleme] 


## Resurse
- [Listati aici orice link catre o resursa externa il considerti relevant]
- Exemplu de URL:
- [Sintaxa Markdown](https://www.markdownguide.org/cheat-sheet/)