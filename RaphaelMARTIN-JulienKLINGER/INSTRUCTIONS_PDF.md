# Instructions pour convertir le README en PDF

## Étape 1 : Installer les dépendances Python

Ouvrez un terminal et exécutez :

```bash
pip install markdown pdfkit
```

## Étape 2 : Installer wkhtmltopdf

### Windows

**Option A - Avec Chocolatey (Recommandé)** :
```bash
choco install wkhtmltopdf
```

**Option B - Installation manuelle** :
1. Télécharger depuis : https://wkhtmltopdf.org/downloads.html
2. Installer le fichier .exe
3. Ajouter au PATH :
   - Ouvrir "Modifier les variables d'environnement système"
   - Variables d'environnement → PATH
   - Ajouter : `C:\Program Files\wkhtmltopdf\bin`
4. Redémarrer le terminal

## Étape 3 : Exécuter le script

```bash
cd "C:\Users\User\OneDrive\Desktop\dataviz\RaphaelMARTIN-JulienKLINGER"
python convert_to_pdf.py
```

## Résultat

Le fichier `README.pdf` sera créé dans le même dossier avec :
- ✅ Toutes les images incluses
- ✅ CSS personnalisé appliqué
- ✅ Formatage Markdown conservé
- ✅ Liens cliquables
- ✅ Table des matières
- ✅ Coloration syntaxique du code

## Dépannage

### Erreur "wkhtmltopdf not found"

Vérifiez que wkhtmltopdf est dans le PATH :
```bash
wkhtmltopdf --version
```

Si la commande ne fonctionne pas, réinstallez et redémarrez le terminal.

### Images manquantes dans le PDF

Les chemins d'images doivent être relatifs au README.md. Le script charge automatiquement toutes les images du dossier courant.

### PDF trop volumineux

Réduisez la qualité des images en modifiant dans le script :
```python
'image-quality': 80,  # Au lieu de 100
'dpi': 150,           # Au lieu de 300
```
