# Analyse S&P 500 - Documentation des Visualisations

Cette documentation explique ce que chaque graphique montre dans les 5 notebooks d'analyse du S&P 500.

---

## PARTIE 1 : Analyse Exploratoire (`partie_1.ipynb`)

Cette partie présente une vue d'ensemble des données S&P 500 avec des statistiques descriptives.

### Graphique 1 : Histogramme des prix de fermeture actuels
**Ce qu'on observe :**
- La distribution des prix de clôture des 49 actions analysées
- La majorité des actions se concentrent dans les tranches de prix basses (0-300 USD)
- Quelques actions très chères créent une distribution asymétrique
- Permet d'identifier si le portefeuille contient plutôt des actions bon marché ou premium

### Graphique 2 : Top 15 stocks par prix de fermeture
**Ce qu'on observe :**
- Les 15 actions les plus chères du S&P 500 dans notre échantillon
- Généralement dominé par les valeurs technologiques (NVDA, GOOGL, ASML, etc.)
- Code couleur par secteur pour identifier les secteurs premium
- Montre que les actions technologiques ont tendance à avoir les prix unitaires les plus élevés

### Graphique 3 : Distribution par secteur
**Ce qu'on observe :**
- Le nombre d'entreprises dans chaque secteur
- Le secteur **Technology** domine largement avec environ 30+ actions
- Les secteurs **Consumer**, **Healthcare** et **Finance** suivent
- **Energy**, **Industrial** et **Real Estate** sont moins représentés
- Reflète la composition moderne du S&P 500 orientée tech

### Graphique 4 : Volatilité par secteur
**Ce qu'on observe :**
- La volatilité moyenne (écart-type des rendements) par secteur
- Les secteurs les plus risqués vs les plus stables
- Généralement, **Energy** et **Technology** sont plus volatils
- **Consumer** et **Healthcare** tendent à être plus stables
- Aide les investisseurs à évaluer le risque sectoriel

### Graphique 5 : Volume moyen par secteur
**Ce qu'on observe :**
- Le volume de trading moyen en millions d'actions échangées
- **Technology** domine généralement avec les volumes les plus élevés
- Indique la liquidité et l'intérêt des investisseurs par secteur
- Un volume élevé = meilleure liquidité et facilité d'achat/vente

---

## PARTIE 2 : Analyses Temporelles (`partie_2.ipynb`)

Cette partie analyse l'évolution dans le temps des actions et secteurs.

### Graphique 1 : Évolution du prix moyen par secteur
**Ce qu'on observe :**
- La trajectoire des prix moyens de chaque secteur sur l'année
- **Technology** montre généralement la croissance la plus forte
- Permet d'identifier les secteurs en tendance haussière ou baissière
- On peut voir les corrélations entre secteurs (mouvements similaires)
- Les périodes de volatilité du marché affectent tous les secteurs simultanément

### Graphique 2 : Évolution du volume de trading par secteur
**Ce qu'on observe :**
- Graphique en aires empilées montrant le volume total par secteur
- Les pics de volume indiquent des périodes de forte activité (annonces, événements)
- **Technology** représente la plus grande part du volume total
- Permet d'identifier les périodes d'intérêt accru des investisseurs
- Les volumes baissent généralement pendant les vacances et périodes calmes

### Graphique 3 : Heatmap - Rendements par secteur et mois
**Ce qu'on observe :**
- Matrice colorée avec rendements moyens mensuels par secteur
- **Vert** = rendements positifs, **Rouge** = rendements négatifs
- Permet d'identifier les mois forts/faibles pour chaque secteur
- Révèle les patterns saisonniers (certains secteurs performent mieux à certains mois)
- Montre les périodes de correction du marché (toute la colonne en rouge)

### Graphique 4 : Box plot des rendements par secteur
**Ce qu'on observe :**
- La distribution complète des rendements quotidiens par secteur
- La médiane (ligne centrale) montre le rendement typique
- Les quartiles montrent la dispersion des rendements
- Les outliers (points isolés) indiquent les jours de mouvements extrêmes
- Permet de comparer la stabilité entre secteurs
- La ligne rouge à 0% sépare gains et pertes

### Graphique 5 : Évolution du prix des Top 5 actions
**Ce qu'on observe :**
- Évolution normalisée des 5 plus grandes capitalisations (AAPL, MSFT, GOOGL, AMZN, NVDA)
- Prix normalisé à 100 au début permet de comparer la performance relative
- NVDA montre souvent la croissance la plus spectaculaire
- Permet d'identifier quelle action a le mieux/moins bien performé
- Montre la corrélation entre ces géants tech

---

## PARTIE 3 : Visualisation Géographique (`partie_3.ipynb`)

Cette partie analyse la localisation géographique des sièges sociaux aux États-Unis.

### Graphique 1 : Distribution des stocks par état
**Ce qu'on observe :**
- Top 15 états avec le plus de sièges sociaux S&P 500
- **Californie (CA)** domine largement (Silicon Valley + LA)
- **New York (NY)**, **Texas (TX)** et **Washington (WA)** suivent
- Reflète les hubs économiques et technologiques américains
- Montre la concentration géographique du pouvoir économique

### Graphique 2 : Prix moyen par état
**Ce qu'on observe :**
- Le prix moyen des actions par état
- Les états avec des entreprises tech (CA, WA) ont généralement des prix plus élevés
- Reflète le type d'industrie dominant dans chaque état
- Permet d'identifier les états avec les entreprises les plus valorisées

### Graphique 3 : Scatter géographique (lat/lon)
**Ce qu'on observe :**
- Visualisation des sièges sociaux sur une carte latitude/longitude
- Taille des points proportionnelle au prix de l'action
- Couleur par secteur
- Concentration massive sur la côte Ouest (Californie)
- Concentration financière sur la côte Est (New York)
- Le reste du pays est moins dense

### Graphique 4 : Heatmap secteur par état
**Ce qu'on observe :**
- Matrice montrant la spécialisation sectorielle de chaque état
- **Californie** : fortement orientée Technology
- **New York** : Finance et divers secteurs
- **Texas** : Energy et Technology
- **New Jersey** : Healthcare et Consumer
- Révèle l'écosystème industriel de chaque région

### Graphique 5 : Carte USA avec nombre de sociétés par état
**Ce qu'on observe :**
- Carte choroplèthe interactive des États-Unis
- États colorés selon le nombre de sièges sociaux
- **Californie** en rouge foncé (concentration maximale)
- **États du centre** souvent vides ou faiblement représentés
- Visualisation claire de la disparité géographique
- Hover pour voir détails (nombre exact, prix moyen)

---

## PARTIE 4 : Animations (`partie_4.ipynb`)

Cette partie crée 3 animations GIF pour visualiser l'évolution temporelle.

### Animation 1 : `sp500_price_evolution.gif`
**Ce qu'on observe :**
- Évolution des box plots de prix pour les Top 10 actions semaine par semaine
- Montre comment la distribution des prix change au fil du temps
- Les box plots révèlent la volatilité de chaque action
- Permet de voir les tendances haussières/baissières en mouvement
- Code couleur par secteur

### Animation 2 : `sp500_sector_change.gif`
**Ce qu'on observe :**
- Barres horizontales montrant le changement cumulé de prix par secteur
- Les barres grandissent/rétrécissent selon la performance sectorielle
- Permet d'identifier quel secteur surperforme à chaque période
- La barre traverse l'axe 0% pour montrer gains/pertes
- Révèle les cycles sectoriels et rotations d'investissement

### Animation 3 : `sp500_top5_ranking.gif`
**Ce qu'on observe :**
- Classement dynamique des 5 actions les plus chères
- Les barres changent de longueur selon l'évolution des prix
- Le classement se réorganise quand une action dépasse une autre
- Montre la compétition entre les actions premium
- Code couleur par secteur pour identifier les secteurs dominants

---

## PARTIE 5 : Graphiques Interactifs Plotly (`partie_5.ipynb`)

Cette partie utilise Plotly pour créer des visualisations interactives.

### Graphique Interactif 1 : Prix vs Volume (Scatter)
**Ce qu'on observe :**
- Nuage de points avec prix en Y, volume en X
- **Taille des bulles** = ampleur du changement de prix sur 30 jours
- **Couleur** = secteur
- Permet d'identifier les actions très tradées vs peu liquides
- Les grosses bulles = forte volatilité récente
- Interaction : hover pour voir détails, zoom, pan

### Graphique Interactif 2 : Évolution temporelle des Top 5 stocks
**Ce qu'on observe :**
- Lignes interactives montrant l'évolution des prix des 5 géants
- Permet de zoomer sur des périodes spécifiques
- Hover unifié montre toutes les valeurs à une date donnée
- Facilite la comparaison des trajectoires
- Permet d'identifier les corrélations et divergences

### Graphique Interactif 3 : Distribution des prix par secteur (Box plot)
**Ce qu'on observe :**
- Box plots interactifs montrant la distribution complète par secteur
- Technology a généralement la plus grande dispersion de prix
- Permet de comparer la variabilité entre secteurs
- Interaction : hover pour statistiques détaillées (médiane, quartiles, outliers)
- Identifie les secteurs avec les prix les plus homogènes

### Graphique Interactif 4 : Heatmap des corrélations secteur
**Ce qu'on observe :**
- Matrice de corrélation entre les prix moyens des secteurs
- **Rouge** = corrélation positive forte (mouvements similaires)
- **Bleu** = corrélation négative (mouvements opposés)
- La plupart des secteurs sont positivement corrélés (marché se déplace ensemble)
- Certains secteurs comme Energy peuvent avoir des corrélations différentes
- Valeurs numériques affichées dans chaque cellule
- Utile pour la diversification de portefeuille

---

## PARTIE 6 : Dashboard Interactif Dash (`partie_6.py`)

Ce fichier crée un dashboard web interactif avec Dash permettant de :
- Sélectionner dynamiquement des actions et secteurs
- Filtrer par période temporelle
- Visualiser plusieurs métriques simultanément
- Explorer les données de manière personnalisée

---

## Fichiers Générés

- **sp500_price_evolution.gif** : Animation des box plots de prix
- **sp500_sector_change.gif** : Animation du changement sectoriel
- **sp500_top5_ranking.gif** : Animation du classement Top 5

---

## Technologies Utilisées

- **Pandas** : Manipulation de données
- **NumPy** : Calculs numériques
- **Matplotlib** : Graphiques statiques
- **Seaborn** : Graphiques statistiques avancés
- **Plotly** : Graphiques interactifs
- **yfinance** : Récupération des données boursières
- **Dash** : Dashboard web interactif

---

## Insights Clés des Analyses

1. **Domination Technologique** : Le secteur Technology domine en nombre d'actions, volume de trading et croissance des prix

2. **Concentration Géographique** : La Californie héberge la majorité des entreprises tech du S&P 500

3. **Volatilité Sectorielle** : Energy et Technology sont les secteurs les plus volatils, tandis que Consumer Staples est plus stable

4. **Corrélations Fortes** : La plupart des secteurs évoluent dans la même direction, rendant la diversification sectorielle moins efficace

5. **Giants Tech** : AAPL, MSFT, GOOGL, AMZN et NVDA représentent une part disproportionnée de la capitalisation et du volume

---

## Utilisation

Pour exécuter les notebooks :

```bash
# Installer les dépendances
pip install -r requirements.txt

# Lancer Jupyter
jupyter notebook

# Pour le dashboard Dash
python partie_6.py
```

---

**Auteur** : Analyse S&P 500 - TP Visualisation de Données
**Date** : Janvier 2025
