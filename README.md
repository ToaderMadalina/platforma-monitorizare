Platforma de Monitorizare - Documentatie

Descrierea proiectului

Acest proiect implementeaza un sistem de monitorizare a resurselor unui server sau container, folosind un script Bash pentru colectarea informațiilor despre:
•	Memorie RAM
•	CPU si procesele cu cel mai mare consum
•	Spațiu pe disc
•	Retele si interfete
•	Numarul total de procese active

Proiectul este containerizat cu Docker si poate fi rulat pe o masina locala sau pe un server remote. Infrastructura necesara rularii poate fi creata automat folosind Terraform (EC2, S3, SSH key-pair).

________________________________________
Structura proiectului

platforma-monitorizare/

├── ansible/                       
│   └── playbooks/
│           ├── deploy_platform.yaml
│           ├── install_docker.yml
│   └── inventory.ini

├── backup/                        
│   └── dockerfile

├── docker/                       
│   └── backup/                        
│           └── dockerfile
│   └── monitoring/                        
│           └── dockerfile           
│   └── docker-compose.yml


│
├── jenkins/                       # Pipeline și fișiere Jenkins
│   └── pipelines/
            └── backup                       
│               └── Jenkinsfile
│           └── monitoring/
│               ├── Dockerfile
│               ├── Jenkinsfile
│               └── monitoring.sh

├── k8s/                     
│   ├── deployment.yaml
│   └── hpa.yaml
│   └── service-nginx.yaml

├── monitoring/                        
│   └── dockerfile


├── scripts/                     
│   ├── monitoring.sh
│   └── backup.py
│

├── terraform/                     # Configurații Terraform pentru infrastructură
│   ├── backend.tf
│   └── main.tf
│

│
└── README.md                       # Documentația proiectului

_

Explicatia fisierelor

### 1 Dockerfile

- Bazat pe `alpine:latest`.
- Instalează `bash`, `procps` și `iproute2`.
- Copiază scriptul `monitoring.sh` în container.
- Setează drepturi de execuție pentru script.

### 2 monitoring.sh

- Script bash care colectează datele de sistem și le salvează într-un fișier log (`system-state.log`).
- Variabilă de mediu:
  - `INTERVAL` - intervalul (în secunde) între colectările de date. Implicit: 5s.
  - `LOG_FILE` - numele fișierului log. Implicit: `system-state.log`.
- Exemplu de rulare:

docker run --rm -v /docker/monitoring/data:/data madalinatoader/monitorizare-image /bin/sh /app/monitoring.sh


### 3 Terraform

- `main.tf`:
  - Creează bucket S3 în LocalStack.
  - Creează key pair SSH.
  - Creează security group care permite SSH.
  - Creează o instanță EC2 dummy (folosită pentru testare locală).
- `backend.tf`:
  - Configurează backend-ul local pentru stocarea state-ului Terraform.
- `terraform.tfstate`:
  - Nu trebuie urcat pe Git. Conține starea curentă a infrastructurii.

  
_______________________________________
Instalare și cerințe
1. Docker
   Comenzi pentru build și rulare Docker
   Asigură-te că Docker este instalat pe sistem:
	docker --version
2. Jenkins
Pentru rularea pipeline-ului:
•	Jenkins instalat pe server sau local
•	Credentiale pentru Docker Hub (dockerhub-creds)
•	Pluginuri: Pipeline, Docker Pipeline, Credentials Binding
3. Terraform
Pentru infrastructura pe AWS/LocalStack:
•	Terraform >= 1.5
•	AWS CLI configurat sau LocalStack
________________________________________
Configurări și variabile de mediu
•	INTERVAL: intervalul (în secunde) la care scriptul actualizează logul.
Valoare implicită: 5
Poate fi suprascris astfel:
export INTERVAL=10
•	AWS_ACCESS_KEY_ID și AWS_SECRET_ACCESS_KEY: credențiale pentru AWS sau LocalStack
•	AWS_DEFAULT_REGION: regiunea AWS/LocalStack
•	Volume pentru Docker: /docker/monitoring/data
Aici sunt salvate fișierele de log (system-state.log).
________________________________________

Rulare proiect
________________________________________ 

1. Build Docker Image
În directorul jenkins/pipelines/monitoring:
docker build -t madalinatoader/monitorizare-image .
•	Creează imaginea Docker cu scriptul de monitorizare inclus.
2. Rulare container
docker run --rm -v /docker/monitoring/data:/data madalinatoader/monitorizare-image /bin/sh /app/monitoring.sh
•	-v /docker/monitoring/data:/data: montează volumul pentru a salva logul pe host
•	/bin/sh /app/monitoring.sh: rulează scriptul Bash
3. Verificarea logurilor
Logul generat de script:
tail -f /docker/monitoring/data/system-state.log
Trebuie să vezi ieșirea actualizată la intervalul setat:
Date & Time: 2025-11-08 12:34:56
Hostname: tsm
Memory Usage:
...
Network Interfaces:
eth0 192.168.0.100
...
System state updated in /data/system-state.log (interval: 5s)
________________________________________
Pipeline Jenkins
Pipeline-ul Jenkins:
•	Clonază repository-ul
•	Rulează shellcheck pentru scriptul Bash
•	Construiește imaginea Docker
•	Face login și push în Docker Hub
•	Rulează containerul pentru monitorizare
Exemplu de rulare:
jenkins/pipelines/monitoring/Jenkinsfile
•	Dacă pipeline-ul eșuează, verificați logul în Jenkins pentru detalii.
________________________________________
Terraform (Infrastructură)
1. Configurare LocalStack
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
•	Folosit pentru testarea infrastructurii fără AWS real
•	Endpoint LocalStack: http://localhost:4566
2. Backend S3 pentru state
terraform {
  backend "s3" {
    bucket                      = "monitoring-data"
    key                         = "terraform.tfstate"
    region                      = "us-east-1"
    endpoint                    = "http://localhost:4566"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}
•	bucket: bucket-ul unde se salvează terraform.tfstate
•	endpoint: pentru LocalStack sau AWS real
•	force_path_style: necesar pentru compatibilitate cu LocalStack
3. Aplicarea infrastructurii
cd terraform
terraform init  - initializeaza Terraform si backend-ul
terraform apply -auto-approve     Creeaza infrastructura
Verificăm bucket-ul creat:
# Listeaza S3 
aws --endpoint-url=http://localhost:4566 s3 ls

# Listeaza instantele EC2
aws --endpoint-url=http://localhost:4566 ec2 describe-instances

# Verifica generarea key pair

aws --endpoint-url=http://localhost:4566 ec2 describe-key-pairs


terraform destroy -auto-approve - distrug infrastructura

________________________________________
Comenzi utile
•	Build Docker image:
docker build -t madalinatoader/monitorizare-image jenkins/pipelines/monitoring
•	Rulare container:
docker run --rm -v /docker/monitoring/data:/data madalinatoader/monitorizare-image /bin/sh /app/monitoring.sh
•	Verificare log:
tail -f /docker/monitoring/data/system-state.log
•	Terraform:
terraform init
terraform apply -auto-approve
________________________________________
Testarea aplicației
•	După rularea containerului Docker, logul trebuie să apară în /docker/monitoring/data/system-state.log.
•	În Jenkins, pipeline-ul trebuie să se încheie cu succes și imaginea să fie pusă pe Docker Hub.
•	În LocalStack, bucket-ul monitoring-data trebuie să conțină terraform.tfstate.
________________________________________
Note suplimentare
•	Scriptul de monitorizare folosește comenzi standard Linux: free, uptime, ps, df, ip.
•	Pentru rularea pe Alpine Linux, este recomandat să folosiți /bin/sh în loc de /bin/bash.
•	Toate intervalele, credențialele și directoarele pot fi suprascrise prin variabile de mediu.
