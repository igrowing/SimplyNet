# Test de débit

SimplyNet mesure votre connexion internet en transférant des données vers et depuis un serveur de test et en les chronométrant. Trois valeurs sont rapportées :

- **Téléchargement** — la vitesse à laquelle les données atteignent votre appareil, en Mbps. Plus c'est élevé, mieux c'est.
- **Envoi** — la vitesse à laquelle votre appareil envoie des données, en Mbps. Plus c'est élevé, mieux c'est.
- **Ping** — le délai aller-retour vers le serveur, en millisecondes. Plus c'est bas,
  mieux c'est.

## Choisir un fournisseur

Le menu déroulant sous le bouton **Démarrer le test** sélectionne le backend de test
utilisé.

## Comparaison des services de test de débit

| Caractéristique | Cloudflare (par défaut) | Ookla |
|---|---|---|
| Objectif de mesure | Vitesse réelle de navigation web | Capacité théorique absolue de la ligne |
| Statut de confidentialité | 100 % anonyme. Aucun suivi | Collecte l'IP, la localisation et les données de l'appareil |
| Méthode technique | Téléchargement progressif à flux unique | Saturation réseau à flux multiples |
| Idéal pour | Évaluer les performances internet quotidiennes | Vérifier les débits annoncés par le FAI |

### Via Cloudflare (par défaut)

Utilise les points de terminaison publics `speed.cloudflare.com` de Cloudflare. Aucun compte ni consentement supplémentaire n'est requis, et aucun identifiant personnel n'est partagé au-delà des informations normales que toute requête à un site web transporte (comme votre adresse IP, nécessaire pour livrer la réponse).

C'est l'option recommandée pour la plupart des utilisateurs.

### Via Ookla

Utilise le réseau mondial de serveurs speedtest.net d'Ookla — la même infrastructure derrière le célèbre service Speedtest. Les serveurs Ookla sont exploités par des tiers dans le monde entier, de sorte qu'un test se connecte au serveur le plus proche et le plus accessible.

Comme cela implique des serveurs tiers, choisir Ookla demande votre consentement la première fois. **Ookla collecte et partage votre adresse IP, les identifiants de votre appareil et vos données de localisation.** Votre choix est mémorisé afin de ne plus vous le redemander ; vous pouvez revenir à Cloudflare à tout moment.

Quand Ookla est actif, le bouton **Démarrer le test** devient ambre pour vous rappeler qu'un backend tiers est utilisé. Cloudflare rétablit le bouton bleu.

## Conseils pour des résultats précis

- Testez en Wi-Fi ou en données mobiles selon ce que vous voulez mesurer.
- Fermez les autres applications susceptibles d'utiliser le réseau.
- Lancez le test plusieurs fois — les résultats varient selon les conditions du réseau et la charge du serveur.
- Les liaisons à très haut débit peuvent être limitées par l'appareil ou la méthode de test plutôt que par votre connexion réelle.

## Confidentialité

Les résultats sont stockés uniquement sur votre appareil sous **Mesures précédentes**. Vous pouvez les effacer à tout moment depuis la section historique. SimplyNet ne téléverse vos résultats nulle part.
