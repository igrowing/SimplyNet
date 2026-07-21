# Qu'est-ce qu'un Ping ?

Vous êtes-vous déjà demandé ce qui se passe quand votre ordinateur ou votre téléphone « pingue » un site web ? Ou pourquoi le support technique vous demande toujours de lancer un « test de ping » quand internet est lent ?

Malgré son nom d'apparence technique, le ping est l'outil de diagnostic le plus simple de toute l'informatique réseau. Voici un guide en langage clair sur ce qu'il est, ce qu'il fait et comment il fonctionne dans notre application.

## 1. L'analogie : le sonar du sous-marin (ou l'écho)

Le terme « Ping » vient en réalité de la technologie sonar des sous-marins.

Imaginez un sous-marin flottant dans l'océan sombre. Pour voir s'il y a une montagne ou un autre navire à proximité, il émet une impulsion sonore — un fort « Ping ! » — dans l'eau.

Si le son heurte un objet, il revient sous forme d'écho.

En mesurant le temps que met l'écho à revenir, le sous-marin peut calculer exactement à quelle distance se trouve l'objet.

Si aucun écho ne revient, le sous-marin sait qu'il n'y a rien là-bas.

Dans le monde numérique, votre téléphone fait exactement la même chose. Il envoie une petite impulsion numérique à un autre ordinateur ou site web et attend que cet ordinateur renvoie l'impulsion.

## 2. Pourquoi en avons-nous besoin ?

Le ping vous aide à répondre à trois questions essentielles sur votre connexion :

### A. « Cet ordinateur est-il allumé et connecté ? » (Disponibilité)

Si vous pinguez un appareil (comme votre smart TV, votre routeur ou google.com) et qu'il répond, vous savez qu'il est allumé et connecté au réseau. Si le ping échoue, c'est que l'appareil est éteint, que le câble est débranché, ou qu'un pare-feu bloque le trafic.

### B. « Quelle est la vitesse de ma connexion ? » (Latence)

Le temps que met votre ping pour faire l'aller-retour se mesure en millisecondes (ms).

* De 1 à 20 ms : ultra-rapide (parfait pour les jeux en ligne ou les appels vidéo).
* De 20 à 100 ms : bon, vitesse de navigation normale.
* Plus de 150 ms : lent, saccadé ou retardé.

### C. « Ma connexion est-elle stable ? » (Perte de paquets et gigue)

Si vous lancez une balle de tennis contre un mur 10 fois, vous vous attendez à ce qu'elle rebondisse 10 fois.

* Si vous pinguez un site web 50 fois et que seuls 45 pings reviennent, vous avez 10 % de perte de paquets (Packet Loss). Cela signifie que votre connexion est instable et que des données se perdent en chemin.
* Si certains pings prennent 10 ms mais d'autres 500 ms, vous avez une gigue (Jitter) élevée, ce qui signifie que votre connexion est irrégulière.

## 3. IP, Hostname et FQDN : comment adresser votre cible

Quand vous demandez à notre application de pinguer quelque chose, vous devez lui indiquer où envoyer l'impulsion. Vous pouvez saisir trois types d'adresses différents :

### 1. Adresse IP (les coordonnées GPS)

Une adresse IP (Internet Protocol) est une suite de nombres, comme 192.168.1.1 ou 142.250.190.46.

* Ce que c'est : c'est l'adresse exacte et physique d'un ordinateur sur le réseau. Les ordinateurs ne comprennent que les adresses IP.
* Analogie : pensez-y comme aux coordonnées exactes de latitude et de longitude d'une maison. C'est très précis, mais très difficile à mémoriser pour les humains.

### 2. Hostname (le surnom convivial)

Un Hostname est un nom simple et lisible attribué à un seul appareil sur un réseau local, comme MyLaptop, OfficePrinter ou LivingRoomSpeaker.

* Ce que c'est : c'est un surnom local. Chez vous, vous pouvez demander à votre téléphone de pinguer OfficePrinter, et votre routeur traduira ce surnom en son adresse IP.
* Analogie : c'est comme dire « la chambre de maman » ou « la cuisine ». Cela fonctionne parfaitement chez vous, mais si vous allez chez un inconnu et dites « va dans la chambre de maman », il ne saura pas de quelle pièce vous parlez.

### 3. FQDN (l'adresse postale complète)

FQDN signifie Fully Qualified Domain Name (nom de domaine pleinement qualifié). Quelques exemples : www.google.com, mail.yahoo.com ou support.apple.com.

* Ce que c'est : c'est le nom complet, officiel et sans ambiguïté d'un serveur sur l'internet mondial. Comme il contient à la fois le surnom d'hôte spécifique (www) et le domaine enregistré (google.com), il n'y a aucune confusion sur l'ordinateur de la planète dont vous parlez.
* Analogie : pensez-y comme à une adresse postale internationale complète, avec le Nom, la Rue, la Ville et le Pays. Elle est unique et fonctionne depuis n'importe où dans le monde.

## 4. Fonctions spéciales de l'outil Ping

Quand vous utilisez l'outil Ping, vous avez le contrôle total sur le déroulement du test :

* Personnalisez la durée du Ping (Nombre) : au lieu de pinguer indéfiniment ou de lancer un test fixe, vous pouvez indiquer exactement combien de fois pinguer (par exemple 10, 50 ou 100 fois). Cela vous permet de lancer un test de stabilité à long terme sur plusieurs minutes, pour voir si votre Wi-Fi souffre de coupures intermittentes quand vous passez dans une autre pièce.
* Arrêtez à tout moment (bouton Arrêter) : si vous avez lancé un test de stabilité de 100 pings mais que vous avez immédiatement repéré une forte perte de paquets ou des journaux d'erreurs, vous n'êtes pas obligé d'attendre la fin du test. Vous pouvez appuyer sur Arrêter à tout moment. Notre application coupe instantanément le processus réseau en arrière-plan, arrête la consommation de la batterie et calcule immédiatement les statistiques moyennes finales des pings qui ont réussi à se terminer.
