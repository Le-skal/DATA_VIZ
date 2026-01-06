# 📊 Analyse S&P 500 - Visualisation de Données Financières

## 🎯 Objectif du Projet

Ce projet réalise une analyse complète et interactive des données du **S&P 500** (les 50 plus grandes entreprises américaines) en temps réel. Les données sont récupérées automatiquement via l'API **Yahoo Finance** grâce au package R `tidyquant`.

---

## 📁 Structure du Projet

Le projet est divisé en **6 parties**, chacune explorant un aspect différent de la visualisation de données :

### **partie_1.R** - 📈 Analyse Exploratoire
**Objectif :** Comprendre la distribution et la composition du dataset

**Étapes de nettoyage des données :**
1. Vérification des valeurs manquantes (NA)
2. Détection et suppression des doublons
3. Suppression des lignes avec NA dans colonnes critiques
4. Vérification de cohérence (prix/volumes négatifs)
5. Validation des dates et périodes

**Visualisations créées :**
- Histogramme des prix de fermeture actuels
- Top 15 actions par prix
- Répartition par secteur (Technology, Finance, Healthcare, etc.)
- Volatilité moyenne par secteur (écart-type des rendements)
- Volume moyen de trading par secteur

**Concepts clés :**
- **Nettoyage de données** (data cleaning)
- Distribution statistique
- Agrégation par catégorie (secteur)
- Calcul de volatilité

---

### **partie_2.R** - ⏱️ Analyses Temporelles
**Objectif :** Étudier l'évolution des prix dans le temps

**Visualisations créées :**
- Timeline du prix moyen par secteur **avec smoothing curve (loess)**
- Évolution du volume de trading (area chart)
- Heatmap des rendements (secteur × mois)
- Box plot des rendements quotidiens
- Évolution normalisée des Top 5 actions (indice 100)

**Concepts clés :**
- Séries temporelles
- **Courbe de lissage** (`geom_smooth`)
- Heatmaps multivariées
- Normalisation des données
- Rendements financiers (returns)

---

### **partie_3.R** - 🗺️ Visualisation Géographique
**Objectif :** Analyser la répartition géographique des entreprises aux USA

**Visualisations créées :**
- Distribution des sièges sociaux par état (USA)
- Prix moyen par état
- Scatter plot géographique (latitude/longitude)
- Heatmap secteur × état
- **Carte USA interactive** : États colorés selon le nombre de sociétés

**Concepts clés :**
- Cartographie avec `maps`
- Données géospatiales (lat/lon)
- Agrégation géographique
- Choropleth map (carte choroplèthe)

---

### **partie_4.R** - 🎬 Animations
**Objectif :** Créer des animations dynamiques pour montrer l'évolution temporelle

**Animations créées :**
- **sp500_price_evolution.gif** : Évolution des prix (box plot animé)
- **sp500_sector_change.gif** : Changement cumulé par secteur
- **sp500_top5_ranking.gif** : Classement dynamique des Top 5 actions

**Concepts clés :**
- Animation avec `gganimate`
- Transitions temporelles (`transition_time`)
- Création de GIFs

**Paramètres :**
- 100 frames, 10 fps
- Durée : ~10 secondes par animation

---

### **partie_5.R** - 🔍 Graphiques Interactifs (Plotly)
**Objectif :** Créer des visualisations interactives avec zoom, hover, etc.

**Visualisations créées :**
- **Scatter plot** : Prix vs Volume (taille = changement 30j)
- **Timeline interactive** : Top 5 actions avec hover
- **Box plot interactif** : Distribution des prix par secteur
- **Heatmap de corrélation** : Matrice de corrélation entre secteurs

**Concepts clés :**
- Interactivité avec `plotly`
- Tooltips personnalisés
- Matrices de corrélation

---

### **partie_6.R** - 🖥️ Dashboard Shiny Interactif
**Objectif :** Créer une application web interactive avec filtres dynamiques

**Fonctionnalités :**

**5 Onglets :**
1. **Vue principale** : Timeline des prix avec statistiques clés
2. **Analyse par secteur** : Distribution et volatilité
3. **Données filtrées** : Tableau interactif
4. **Statistiques** : Résumés et rendements
5. **Comparaison** : Comparaison des actions (min/moyen/max)

**Filtres disponibles :**
- Secteur (Technology, Finance, Healthcare, etc.)
- Actions spécifiques (multi-sélection)
- Plage de prix (slider)
- Plage de dates (calendrier)

**Concepts clés :**
- Application web Shiny
- Réactivité (`reactive()`)
- Interface utilisateur (UI/Server)

---

## 🛠️ Technologies Utilisées

| Package | Usage |
|---------|-------|
| **tidyverse** | Manipulation de données (dplyr, tidyr) |
| **ggplot2** | Visualisations statiques |
| **tidyquant** | Récupération données financières (Yahoo Finance) |
| **plotly** | Graphiques interactifs |
| **gganimate** | Animations |
| **shiny** | Application web interactive |
| **maps** | Cartes géographiques USA |
| **gifski** | Encodage GIF pour animations |

---

## 📊 Données Utilisées

### Source : **Yahoo Finance** (via API gratuite)

**50 actions du S&P 500 :**
- **Technology** : AAPL, MSFT, GOOGL, NVDA, META, AMD, INTC, etc.
- **Finance** : JPM, V, MA, BRK.B, PYPL
- **Healthcare** : JNJ, UNH, ABT, ABBV, GILD
- **Consumer** : AMZN, TSLA, WMT, HD, DIS, MCD, KO, COST, PEP, NFLX
- **Energy** : XOM, CVX
- **Industrial** : BA, MMM
- **Real Estate** : CCI

**Période :** Dernière année (365 jours)

**Mise à jour :** Données en temps réel (à chaque exécution)

---

## 📈 Indicateurs Financiers Calculés

| Indicateur | Formule | Interprétation |
|------------|---------|----------------|
| **Prix de fermeture** | `close` | Valeur de l'action |
| **Volume** | `volume` | Nombre d'actions échangées |
| **Rendement** | `(close - lag(close)) / lag(close) * 100` | Performance quotidienne (%) |
| **Volatilité** | `sd(rendements)` | Risque / variabilité |
| **Prix normalisé** | `close / first(close) * 100` | Évolution relative (indice) |

---

## 🔑 Points Clés pour la Présentation

### 1. **Originalité**
✅ Données en temps réel (pas de CSV statique)
✅ 50 actions du S&P 500
✅ 6 types de visualisations différentes

### 2. **Techniques Avancées**
✅ Animations (gganimate)
✅ Dashboard interactif (Shiny)
✅ Visualisations géographiques
✅ Graphiques interactifs (Plotly)

### 3. **Interprétation Financière**
- **Volatilité** : Mesure le risque (Technology = plus volatile)
- **Volume** : Indique la liquidité
- **Rendements** : Performance quotidienne
- **Corrélation** : Mouvements synchronisés entre secteurs

### 4. **Scalabilité**
- Facile d'ajouter d'autres actions
- Paramètres modifiables (plage de dates, fps animations, etc.)
- Code modulaire et réutilisable

---

## 📝 Notes

- Les données sont récupérées automatiquement à chaque exécution
- Les GIFs sont sauvegardés dans le dossier du projet
- Le dashboard Shiny peut être déployé en ligne (shinyapps.io)