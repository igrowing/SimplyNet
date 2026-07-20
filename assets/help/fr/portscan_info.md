# Qu'est-ce qu'un scan de ports (Port Scan) ?

Comment les hackers ou les experts en sécurité trouvent-ils les points de vulnérabilité d'un appareil ?

Ils le font grâce à un outil appelé scan de ports (Port Scan).

## 1. L'analogie : un bâtiment sécurisé avec 65 536 portes

Imaginez un immense immeuble de bureaux ou un complexe résidentiel sécurisé.

* L'Host (l'adresse IP ou le domaine) est l'adresse postale du bâtiment. Elle vous amène jusqu'au portail principal.
* Une fois à l'intérieur, le bâtiment compte exactement 65 536 portes numérotées (appelées Ports).
* Derrière chaque porte se trouve une entreprise ou un service spécifique. Par exemple, derrière la Porte 80 se trouve un gestionnaire de sites web, et derrière la Porte 554 un flux de caméra de sécurité.

  💡 Un scan de ports, c'est comme un agent de sécurité qui parcourt les couloirs, frappe aux portes et vérifie lesquelles sont ouvertes, verrouillées ou complètement abandonnées.

Si une porte est Ouverte, cela signifie qu'un service est activement en cours d'exécution derrière elle et à l'écoute de connexions. Si elle est Fermée, la porte est verrouillée et il n'y a personne à l'intérieur.

## 2. Choisir votre cible : ports connus (Well-Known) vs plage personnalisée

Vous pouvez choisir quelles « portes » vérifier :

### A. Ports connus (vérifier le hall principal)

Sur les 65 536 portes possibles, la grande majorité sont vides. Par défaut, internet réserve les 1 024 premières portes aux services standard et officiels.

* Porte 80 : sites web standard (HTTP)
* Porte 443 : sites web sécurisés (HTTPS)
* Porte 21 : partage de fichiers (FTP)
* Porte 22 : contrôle à distance sécurisé (SSH)
* En quoi cela vous aide : scanner les ports connus, c'est comme vérifier uniquement les halls principaux et les quais de chargement du bâtiment. C'est incroyablement rapide (quelques secondes seulement) et couvre 99 % de ce que recherche un utilisateur normal.

### B. Plage définie par l'utilisateur (fouiller chaque pièce)

Parfois, des applications personnalisées, des appareils domotiques ou des caméras se cachent derrière des numéros de porte inhabituels (comme la Porte 8080 ou la Porte 32400) pour rester discrets.

* En quoi cela vous aide : vous pouvez demander à l'application de scanner une plage personnalisée — par exemple, de la Porte 1 à la Porte 2048. L'application frappe consciencieusement à chacune de ces portes, l'une après l'autre, pour trouver les services cachés.

## 3. Les protocoles : TCP vs UDP

Les « portes » d'un ordinateur parlent deux langues différentes. Selon vos réglages, l'application frappe avec des styles différents :

### 1. TCP (la poignée de main polie)

Le TCP (Transmission Control Protocol) est le protocole le plus courant sur internet. Il est conçu pour une précision de 100 %.

* Le style de frappe : l'application frappe à la porte, attend que quelqu'un ouvre, lui serre la main, dit « Bonjour ! », puis s'en va poliment.
* Analogie : comme envoyer une lettre recommandée. C'est extrêmement fiable pour confirmer si quelqu'un est chez lui, mais la « poignée de main » prend une fraction de seconde à s'accomplir.

### 2. UDP (le lancer de carte postale)

L'UDP (User Datagram Protocol) est conçu pour la vitesse pure, souvent utilisé pour les flux vidéo en direct ou les jeux en ligne.

* Le style de frappe : l'application glisse une carte postale par la fente du courrier et écoute une fraction de seconde pour voir si quelqu'un à l'intérieur répond en criant. Elle n'attend pas de serrer la main.
* Analogie : comme lancer un avion en papier par-dessus une clôture. C'est incroyablement rapide, mais si personne ne répond, il est plus difficile d'être sûr à 100 % que la pièce est vide ou qu'on a simplement ignoré votre avion en papier.

## 4. Pourquoi un grand scan prend-il autant de temps ?

*« Pourquoi mon scan prend-il si longtemps ? »* La réponse est un simple calcul !

* Si vous scannez les ports connus en TCP uniquement, l'application vérifie environ 60 portes. Elle termine en un éclair.
* Si vous étendez la plage de 1 à 10 000 et sélectionnez à la fois TCP et UDP, l'application doit physiquement effectuer **20 000** frappes individuelles (**10 000** pour TCP et **10 000** pour UDP).

Comme l'application doit attendre une minuscule fraction de seconde à chaque porte pour voir si un appareil répond (afin de ne pas rater une caméra ou un routeur lent à répondre), vérifier des dizaines de milliers de portes demande de la patience.

Pour gagner du temps, commencez toujours par un scan des ports « connus » ! Ne lancez des scans personnalisés à large plage que si vous chassez un appareil caché très spécifique sur votre réseau.
