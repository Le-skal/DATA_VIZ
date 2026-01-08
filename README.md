# Analyse S&P 500 - Projet de Visualisation de Données

## Contexte et Choix du Sujet

### Pourquoi l'analyse du S&P 500 ?

Le S&P 500 (Standard & Poor's 500) est l'un des indices boursiers les plus importants au monde, regroupant les 500 plus grandes entreprises cotées aux États-Unis. Ce projet a été choisi pour plusieurs raisons stratégiques :

1. **Pertinence Économique** : Le S&P 500 représente environ 80% de la capitalisation boursière totale du marché américain. Comprendre sa dynamique permet de saisir les grandes tendances économiques mondiales.

2. **Données Réelles et Accessibles** : Contrairement à des jeux de données académiques fictifs, les données boursières sont réelles, actualisées quotidiennement et accessibles gratuitement via des API (yfinance). Cela rend le projet concret et applicable.

3. **Complexité Multi-Dimensionnelle** : Les données boursières combinent plusieurs dimensions (temps, géographie, secteurs, prix, volumes), ce qui permet d'explorer différentes techniques de visualisation.

4. **Applications Pratiques** : Les compétences développées sont directement transférables vers :
   - L'analyse financière et la gestion de portefeuille
   - Le data journalism économique
   - La business intelligence dans tous les secteurs
   - La prise de décision basée sur les données

5. **Apprentissage de Python & R** : Ce projet permet de maîtriser les deux langages les plus utilisés en data science, avec des implémentations parallèles pour comparer les approches.

### Problématique

**Comment visualiser efficacement les tendances du marché boursier pour identifier les opportunités et risques sectoriels, géographiques et temporels ?**

---

## Objectifs Pédagogiques

Ce projet vise à développer des compétences clés en data science et visualisation :

### 1. Acquisition et Nettoyage de Données
- Récupération automatique de données en temps réel via API (yfinance)
- Gestion des données manquantes et des erreurs de téléchargement
- Validation et cohérence des données (prix négatifs, doublons, etc.)
- Transformation et agrégation de données multi-sources

### 2. Analyse Exploratoire de Données (EDA)
- Calcul de statistiques descriptives (moyenne, médiane, écart-type)
- Identification des distributions et outliers
- Analyse de corrélations entre variables
- Détection de patterns temporels et saisonniers

### 3. Maîtrise des Outils de Visualisation
- **Matplotlib/Seaborn** : Graphiques statiques professionnels
- **Plotly** : Visualisations interactives avec zoom, hover, filtres
- **Animations** : Création de GIFs pour montrer l'évolution temporelle
- **Dash** : Développement de dashboards web interactifs

### 4. Choix de la Bonne Visualisation
- Histogrammes pour les distributions
- Line plots pour les évolutions temporelles
- Heatmaps pour les matrices de corrélation
- Box plots pour comparer les dispersions
- Cartes géographiques pour la dimension spatiale
- Animations pour la dimension temporelle dynamique

### 5. Communication de Résultats
- Raconter une histoire avec les données (data storytelling)
- Créer des visualisations claires et interprétables
- Présenter des insights actionnables pour la prise de décision

---

## Ce Qu'on Apprend à Travers Ce Projet

### Compétences Techniques

**Python Data Science Stack**
- Manipulation de DataFrames avec Pandas
- Calculs vectorisés avec NumPy
- Visualisation statique avec Matplotlib/Seaborn
- Interactivité avec Plotly et Dash
- Automatisation de l'acquisition de données

**Concepts Financiers**
- Calcul de rendements et volatilité
- Analyse de corrélation entre actifs
- Évaluation du risque sectoriel
- Identification de tendances de marché
- Normalisation de prix pour comparaison

**Techniques de Visualisation**
- Encodage visuel (couleur, taille, position)
- Graphiques multi-dimensionnels
- Animation et interactivité
- Composition de dashboards
- Principes de design de l'information

### Insights Métier

1. **Domination Technologique** : Comprendre pourquoi et comment le secteur tech domine le marché moderne

2. **Géographie de l'Innovation** : Visualiser la concentration du pouvoir économique en Californie et sur les côtes

3. **Relation Risque/Rendement** : Identifier que les secteurs à forte croissance (tech) sont aussi les plus volatils

4. **Cycles Sectoriels** : Détecter les rotations sectorielles (quand les investisseurs migrent d'un secteur à l'autre)

5. **Liquidité et Capitalisation** : Comprendre le lien entre volume de trading, prix et intérêt des investisseurs

### Applications Professionnelles

Les compétences de ce projet sont directement applicables à :

- **Finance** : Analyse de portefeuille, gestion des risques, trading algorithmique
- **Business Intelligence** : Tableaux de bord pour la direction, reporting automatisé
- **Marketing** : Analyse de tendances, segmentation de marché
- **Consulting** : Présentation de données aux clients, recommandations stratégiques
- **Data Journalism** : Création de visualisations pour articles économiques
- **Recherche Académique** : Méthodologie d'analyse reproductible

---

## Valeur Ajoutée du Projet

### Approche Comparative Python vs R

Ce projet est développé en **Python** (`sp500_python/`) ET en **R** (`sp500_R/`), permettant de :
- Comparer les syntaxes et philosophies des deux langages
- Identifier les forces de chaque outil (Plotly en Python, ggplot2 en R)
- Développer une polyvalence technique précieuse sur le marché du travail

### Architecture Progressive

Le projet est structuré en 6 parties qui suivent une logique pédagogique :
1. **Exploration** : Se familiariser avec les données
2. **Temporel** : Analyser l'évolution dans le temps
3. **Spatial** : Comprendre la dimension géographique
4. **Animation** : Dynamiser la compréhension temporelle
5. **Interactivité** : Permettre l'exploration autonome
6. **Dashboard** : Intégrer tout dans une application web

Cette progression permet d'apprendre graduellement, de la visualisation statique simple au dashboard interactif complexe.

### Reproductibilité et Automatisation

- Code entièrement reproductible avec `requirements.txt`
- Données actualisées automatiquement à chaque exécution
- Pipeline d'analyse réutilisable pour d'autres indices (CAC40, DAX, Nikkei)

---

## Structure du Projet

```
TP6/
├── sp500_python/          # Implémentation Python
│   ├── partie_1.ipynb     # Analyse exploratoire
│   ├── partie_2.ipynb     # Analyses temporelles
│   ├── partie_3.ipynb     # Visualisation géographique
│   ├── partie_4.ipynb     # Animations
│   ├── partie_5.ipynb     # Graphiques interactifs Plotly
│   ├── partie_6.py        # Dashboard Dash
│   └── requirements.txt   # Dépendances Python
│
├── sp500_R/               # Implémentation R (optionnel)
│   └── ...                # Scripts R équivalents
│
└── README.md              # Cette documentation
```

---

## Documentation des Visualisations

Cette section explique ce que chaque graphique montre dans les 5 notebooks d'analyse du S&P 500.

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

## Conclusion et Apprentissages Clés

### Ce Que Ce Projet Nous Enseigne

Au terme de cette analyse approfondie du S&P 500, plusieurs enseignements fondamentaux émergent :

#### 1. La Puissance de la Visualisation de Données

Les données brutes boursières (12,250 lignes × 8 colonnes) sont illisibles pour un humain. Grâce aux 20+ visualisations créées, nous transformons ces chiffres en **insights actionnables** :
- Un histogramme révèle instantanément la distribution des prix
- Une heatmap temporelle montre les patterns saisonniers invisibles dans les tableaux
- Une animation capture l'évolution dynamique que des graphiques statiques ne peuvent pas transmettre

**Leçon** : La visualisation n'est pas qu'esthétique, elle est un outil analytique indispensable pour comprendre des données complexes.

#### 2. Le Choix de la Visualisation Adapte le Message

Chaque type de graphique communique différemment :
- **Box plots** → Comparaison de distributions (volatilité sectorielle)
- **Line plots** → Évolution temporelle (tendances de prix)
- **Heatmaps** → Matrices de corrélation (relations sectorielles)
- **Cartes géographiques** → Dimension spatiale (concentration en Californie)
- **Animations** → Dynamique temporelle (évolution des classements)

**Leçon** : Un data scientist compétent ne maîtrise pas qu'un outil, mais sait **choisir le bon outil pour la bonne question**.

#### 3. L'Importance du Nettoyage de Données

Sur 50 actions ciblées, 1 a échoué (BRK.B), nécessitant une gestion des erreurs. Le projet intègre :
- Détection et suppression des valeurs manquantes
- Vérification de cohérence (prix négatifs, doublons)
- Standardisation des formats (colonnes, dates)

**Leçon** : 80% du travail en data science consiste à préparer les données. Sans nettoyage rigoureux, les visualisations sont trompeuses.

#### 4. Insights Économiques Concrets

L'analyse révèle des tendances structurelles du marché moderne :

**Domination Tech** : Le secteur Technology représente 60% des actions analysées et domine en capitalisation. Cela reflète la transformation digitale de l'économie mondiale.

**Géographie de l'Innovation** : La Californie concentre 40%+ des sièges sociaux, confirmant le rôle central de la Silicon Valley dans l'économie du 21ème siècle.

**Trade-off Risque/Rendement** : Les secteurs à forte croissance (Tech, Energy) sont aussi les plus volatils. Les investisseurs cherchant la stabilité privilégient Consumer et Healthcare.

**Corrélations Élevées** : La plupart des secteurs évoluent ensemble (corrélation > 0.7), limitant les bénéfices de la diversification sectorielle pure.

**Leçon** : Les données ne mentent pas. Elles confirment ou infirment nos hypothèses sur le monde réel.

#### 5. L'Automatisation et la Reproductibilité

Grâce à `yfinance`, les données se mettent à jour automatiquement. Le même code peut :
- Analyser le CAC40 français
- Comparer différentes périodes (crash de 2008, COVID-2020)
- Être adapté pour des cryptomonnaies ou des matières premières

**Leçon** : Un bon projet de data science est **générique et réutilisable**, pas limité à un cas unique.

#### 6. La Complémentarité des Outils

Le projet utilise volontairement plusieurs bibliothèques :
- **Matplotlib** : Contrôle fin, publications académiques
- **Seaborn** : Statistiques visuelles élégantes
- **Plotly** : Interactivité pour l'exploration
- **Dash** : Déploiement web pour les non-techniciens

**Leçon** : Il n'y a pas de "meilleur outil" absolu. Chaque bibliothèque a ses forces, et un expert sait les combiner.

### Compétences Transférables Acquises

À l'issue de ce projet, nous maîtrisons :

**Techniques**
- Récupération automatique de données via API
- Pipeline complet d'analyse (load → clean → analyze → visualize)
- Création de dashboards interactifs prêts pour la production
- Génération de rapports reproductibles (Jupyter Notebooks)

**Analytiques**
- Calcul de métriques financières (rendements, volatilité, corrélation)
- Détection de patterns temporels et saisonniers
- Analyse comparative multi-dimensionnelle
- Communication visuelle de résultats complexes

**Méthodologiques**
- Structuration d'un projet data science de A à Z
- Documentation et reproductibilité du code
- Choix de la visualisation appropriée au message
- Présentation de résultats à un public non-technique

### Perspectives et Extensions Possibles

Ce projet ouvre de nombreuses pistes d'approfondissement :

**Analyses Avancées**
- Prédiction de prix avec Machine Learning (LSTM, Random Forest)
- Analyse de sentiment Twitter/Reddit sur les actions
- Détection d'anomalies et de crash potentiels
- Optimisation de portefeuille (frontière efficiente de Markowitz)

**Visualisations Supplémentaires**
- Réseau de corrélation entre actions (graph network)
- Candlestick charts pour le trading technique
- Sankey diagrams pour les flux sectoriels
- 3D scatter plots (prix × volume × volatilité)

**Déploiement**
- Hébergement du dashboard Dash sur Heroku/AWS
- Notifications automatiques sur changements importants
- Intégration avec des outils de BI (Tableau, Power BI)
- API REST pour consommer les analyses

### Message Final

Ce projet démontre que la **data science n'est pas qu'un empilement de techniques**, mais une **démarche intellectuelle** :

1. **Poser les bonnes questions** (Quels secteurs sont volatils ? Où sont concentrées les entreprises ?)
2. **Acquérir et préparer les données** (API, nettoyage, validation)
3. **Explorer et analyser** (statistiques, corrélations, tendances)
4. **Visualiser et communiquer** (graphiques adaptés, storytelling)
5. **Générer des insights actionnables** (recommandations d'investissement)

Les compétences développées ici sont **universelles** et s'appliquent à tout domaine générant des données : santé, marketing, logistique, sport, climat, etc.

En maîtrisant l'analyse du S&P 500, nous ne faisons pas qu'apprendre la finance. Nous acquérons une **méthodologie reproductible** pour transformer n'importe quel jeu de données complexe en **intelligence exploitable**.

C'est là toute la puissance de la visualisation de données : **rendre visible l'invisible, et transformer l'information en décision**.

---

## Références et Ressources

**Sources de Données**
- [yfinance](https://pypi.org/project/yfinance/) - API Python pour Yahoo Finance
- [S&P 500 sur Wikipedia](https://en.wikipedia.org/wiki/S%26P_500) - Documentation de l'indice

**Documentation des Bibliothèques**
- [Pandas](https://pandas.pydata.org/docs/) - Manipulation de données
- [Matplotlib](https://matplotlib.org/stable/contents.html) - Visualisation statique
- [Seaborn](https://seaborn.pydata.org/) - Visualisation statistique
- [Plotly](https://plotly.com/python/) - Graphiques interactifs
- [Dash](https://dash.plotly.com/) - Framework de dashboards

**Concepts Financiers**
- [Volatilité et Écart-Type](https://www.investopedia.com/terms/v/volatility.asp)
- [Corrélation entre Actifs](https://www.investopedia.com/terms/c/correlation.asp)
- [Analyse Sectorielle](https://www.investopedia.com/terms/s/sector-analysis.asp)

---

**Projet réalisé dans le cadre du TP Visualisation de Données**
**Formation** : Bachelor 3 - ECE Paris
**Date** : Janvier 2025

**Technologies** : Python 3.11, Jupyter Notebook, Pandas, Matplotlib, Seaborn, Plotly, Dash
