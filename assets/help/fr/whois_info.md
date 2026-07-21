# Qu'est-ce que « Who Is » et la résolution DNS ?

Vous êtes-vous déjà demandé qui possède réellement un site web comme google.com ? Ou comment votre téléphone trouve automatiquement le bon ordinateur à l'autre bout du monde à partir d'une simple adresse web ?

Quand vous utilisez l'outil Who Is..., vous tirez le rideau sur l'annuaire administratif d'internet. Il utilise trois fonctions principales pour enquêter sur n'importe quel domaine ou adresse IP.

## 1. Qu'est-ce que WHOIS ? (Le cadastre numérique)

Chaque nom de site web (comme votresite.com) est une parcelle de bien immobilier numérique. Tout comme acheter une maison physique ou immatriculer une voiture, vous ne pouvez pas posséder un domaine de manière anonyme sans l'enregistrer.

WHOIS (littéralement demander *« Qui est responsable de ce domaine ? »*) est une gigantesque base de données publique qui répertorie les informations de propriété de chaque nom de domaine et adresse IP enregistrés sur la planète.

### L'analogie : la préfecture ou le cadastre

Quand vous recherchez une plaque d'immatriculation auprès des services des cartes grises, vous obtenez un dossier indiquant à qui appartient la voiture, quand elle a été immatriculée et comment contacter le propriétaire. Une recherche WHOIS fait exactement la même chose pour un site web.

### Quelles informations vous montre-t-elle ?

* Le titulaire (Registrant) : le nom de la personne ou de l'entreprise qui a acheté le domaine. (Remarque : beaucoup de particuliers utilisent des services de « protection de la vie privée » pour masquer leur adresse personnelle, mais les coordonnées de l'hébergeur restent visibles).
* Dates importantes : exactement quand le nom du site a été acheté pour la première fois, quand il a été mis à jour pour la dernière fois et — le plus important — quand il expire.
* Le bureau d'enregistrement (Registrar) : la « boutique » numérique où le propriétaire a acheté le domaine (comme GoDaddy, Namecheap ou Google Domains).

## 2. Qu'est-ce que la résolution DNS ? (L'annuaire téléphonique d'internet)

Les ordinateurs sont incroyablement doués en calcul, mais nuls en langues. Ils ne comprennent pas les noms comme `netflix.com`. Pour communiquer entre eux, ils utilisent des coordonnées numériques appelées adresses IP (comme `142.250.190.46`).

Les humains, en revanche, sont doués pour les noms mais nuls pour mémoriser des suites aléatoires de chiffres.

**La résolution DNS (Domain Name System)** est le pont entre ces deux mondes. Elle traduit un nom convivial pour l'humain en un nombre convivial pour l'ordinateur.

### L'analogie : l'application Contacts de votre téléphone

Quand vous voulez appeler votre ami Alex, vous ne mémorisez pas son numéro de téléphone à 10 chiffres. Vous appuyez simplement sur « Alex » dans votre liste de contacts, et votre téléphone traduit automatiquement ce nom en numéro de téléphone et le compose.

* Le DNS est la liste de contacts mondiale de tout internet. * Quand vous recherchez un domaine dans notre application, la résolution DNS s'exécute instantanément en arrière-plan et vous dit : « Hé, google.com fonctionne actuellement au numéro de téléphone 142.250.190.46. »

## 3. Qu'est-ce que la résolution inverse ? (L'identification d'appel numérique)

Mais que se passe-t-il si vous avez le numéro (l'adresse IP) et que vous voulez connaître le nom (le site web) ? C'est là qu'intervient la résolution inverse (aussi appelée DNS inverse ou recherche PTR).

Si un ordinateur inconnu essaie de se connecter à votre réseau domestique, ou si vous voyez une adresse IP étrange dans vos journaux réseau, vous pouvez coller cette adresse IP dans notre outil. L'application demandera à l'annuaire mondial : « Quel nom de site web est enregistré pour ce numéro précis ? »

### L'analogie : l'identification d'appel (ou recherche téléphonique inversée)

Si votre téléphone sonne et affiche un numéro inconnu comme `1-800-555-0199`, vous hésiterez peut-être à répondre. Mais si l'identification d'appel de votre téléphone traduit ce numéro et affiche **« Support Apple »**, vous savez instantanément qui appelle.

* La résolution inverse est l'identification d'appel des adresses internet.
* Elle vous permet de retraduire un numéro anonyme et intimidant comme `172.217.16.142` en un nom convivial et reconnaissable comme `google.com`.

## Résumé de l'outil « Who Is... »

En combinant ces trois fonctions, notre outil vous offre une « enquête de fond » complète sur n'importe quelle cible numérique :

1. La résolution DNS vous indique l'adresse IP (le « numéro de téléphone ») du nom d'un site web.
2. La résolution inverse vous indique le nom du site web (l'« identification d'appel ») d'une adresse IP mystérieuse.
3. WHOIS vous indique le véritable propriétaire légal, le bureau d'enregistrement et les dates d'expiration de cette propriété.
