"""
PARTIE 6 : DASHBOARD INTERACTIF DASH - S&P 500

Dashboard interactif pour visualiser et analyser les données du S&P 500
"""

import pandas as pd
import numpy as np
import yfinance as yf
from datetime import datetime, timedelta
import dash
from dash import dcc, html, Input, Output, dash_table
import plotly.express as px
import plotly.graph_objects as go
import warnings
warnings.filterwarnings('ignore')

# ============================================================================
# CHARGEMENT DES DONNÉES
# ============================================================================

sp500_symbols = [
    "AAPL", "MSFT", "GOOGL", "AMZN", "NVDA", "META", "TSLA", "BRK.B", "JNJ", "V",
    "WMT", "JPM", "PG", "MA", "UNH", "HD", "DIS", "CRM", "MCD", "KO",
    "NFLX", "CSCO", "PEP", "ABT", "ABBV", "MMM", "XOM", "CVX", "BA", "COST",
    "AMD", "INTC", "QCOM", "PYPL", "TXN", "ADBE", "IBM", "AVGO", "ACN", "GILD",
    "CDNS", "MRVL", "OKTA", "CCI", "ANET", "SNPS", "ASML", "NOW", "PANW", "LRCX"
]

sector_info = pd.DataFrame({
    'symbol': ["AAPL", "MSFT", "GOOGL", "AMZN", "NVDA", "META", "TSLA", "BRK.B", "JNJ", "V",
               "WMT", "JPM", "PG", "MA", "UNH", "HD", "DIS", "CRM", "MCD", "KO",
               "NFLX", "CSCO", "PEP", "ABT", "ABBV", "MMM", "XOM", "CVX", "BA", "COST",
               "AMD", "INTC", "QCOM", "PYPL", "TXN", "ADBE", "IBM", "AVGO", "ACN", "GILD",
               "CDNS", "MRVL", "OKTA", "CCI", "ANET", "SNPS", "ASML", "NOW", "PANW", "LRCX"],
    'sector': ["Technology", "Technology", "Technology", "Consumer", "Technology", "Technology", "Consumer", "Finance", "Healthcare", "Finance",
               "Consumer", "Finance", "Consumer", "Finance", "Healthcare", "Consumer", "Consumer", "Technology", "Consumer", "Consumer",
               "Technology", "Technology", "Consumer", "Healthcare", "Healthcare", "Industrial", "Energy", "Energy", "Industrial", "Consumer",
               "Technology", "Technology", "Technology", "Finance", "Technology", "Technology", "Technology", "Technology", "Technology", "Healthcare",
               "Technology", "Technology", "Technology", "Real Estate", "Technology", "Technology", "Technology", "Technology", "Technology", "Technology"]
})

print("Chargement des données S&P 500...")
end_date = datetime.now()
start_date = end_date - timedelta(days=365)

# Télécharger les données
sp500_data_list = []
for symbol in sp500_symbols:
    try:
        data = yf.download(symbol, start=start_date, end=end_date, progress=False)
        if not data.empty:  # Vérifier que des données ont été récupérées
            # Aplatir les colonnes si MultiIndex
            if isinstance(data.columns, pd.MultiIndex):
                data.columns = data.columns.get_level_values(0)
            data = data.reset_index()
            data['symbol'] = symbol
            sp500_data_list.append(data)
        else:
            print(f"Aucune donnée pour {symbol}")
    except Exception as e:
        print(f"Erreur pour {symbol}: {e}")

# Concaténer les données verticalement
sp500_data = pd.concat(sp500_data_list, axis=0, ignore_index=True)

# Standardiser les noms de colonnes
sp500_data.columns = sp500_data.columns.str.lower().str.replace(' ', '_')

# Joindre les secteurs
sp500_data = sp500_data.merge(sector_info, on='symbol', how='left')

print(f"Données chargées: {len(sp500_data)} lignes")
print(f"Actions récupérées: {sp500_data['symbol'].nunique()}")

# ============================================================================
# INITIALISATION DE L'APPLICATION DASH
# ============================================================================

app = dash.Dash(__name__)
app.title = "S&P 500 Analytics Dashboard"

# ============================================================================
# LAYOUT DE L'APPLICATION
# ============================================================================

app.layout = html.Div([
    html.H1("S&P 500 Analytics Dashboard",
            style={'textAlign': 'center', 'color': '#1f77b4', 'marginBottom': 30}),

    html.Div([
        # SIDEBAR
        html.Div([
            html.H3("Filtres", style={'marginBottom': 20}),

            # Filtre par secteur
            html.Label("Secteur:", style={'fontWeight': 'bold'}),
            dcc.Dropdown(
                id='sector-filter',
                options=[{'label': 'Tous', 'value': 'Tous'}] +
                        [{'label': s, 'value': s} for s in sorted(sector_info['sector'].unique())],
                value='Tous',
                style={'marginBottom': 20}
            ),

            # Filtre par symbole
            html.Label("Actions (top 10):", style={'fontWeight': 'bold'}),
            dcc.Dropdown(
                id='symbol-filter',
                options=[{'label': s, 'value': s} for s in ["AAPL", "MSFT", "GOOGL", "AMZN", "NVDA", "META", "TSLA", "BRK.B", "JNJ", "V"]],
                value=[],
                multi=True,
                style={'marginBottom': 20}
            ),

            # Filtre par plage de prix
            html.Label("Plage de prix (USD):", style={'fontWeight': 'bold'}),
            dcc.RangeSlider(
                id='price-range',
                min=0,
                max=500,
                step=10,
                value=[0, 500],
                marks={i: f'${i}' for i in range(0, 501, 100)},
                tooltip={"placement": "bottom", "always_visible": True}
            ),

            html.Br(),
            html.Br(),

            # Filtre par plage de dates
            html.Label("Plage de dates:", style={'fontWeight': 'bold'}),
            dcc.DatePickerRange(
                id='date-range',
                start_date=start_date,
                end_date=end_date,
                display_format='YYYY-MM-DD',
                style={'marginBottom': 20}
            ),

            html.Hr(),
            html.H4("À propos"),
            html.P("Dashboard en temps réel des données du S&P 500.")

        ], style={'width': '20%', 'display': 'inline-block', 'verticalAlign': 'top',
                  'padding': 20, 'backgroundColor': '#f8f9fa'}),

        # MAIN CONTENT
        html.Div([
            dcc.Tabs(id='tabs', value='tab-main', children=[
                # TAB 1: VUE PRINCIPALE
                dcc.Tab(label='Vue principale', value='tab-main', children=[
                    html.H3("Évolution du prix", style={'marginTop': 20}),
                    dcc.Graph(id='main-plot', style={'height': '600px'}),

                    html.H4("Statistiques clés", style={'marginTop': 30}),
                    html.Div([
                        html.Div([
                            html.H4("Actions", style={'textAlign': 'center'}),
                            html.H2(id='total-actions', style={'textAlign': 'center', 'color': '#3c8dbc'})
                        ], style={'width': '24%', 'display': 'inline-block', 'padding': 20,
                                 'backgroundColor': '#fff', 'border': '1px solid #ddd', 'margin': '0 0.5%'}),

                        html.Div([
                            html.H4("Prix moyen (USD)", style={'textAlign': 'center'}),
                            html.H2(id='avg-price', style={'textAlign': 'center', 'color': '#00a65a'})
                        ], style={'width': '24%', 'display': 'inline-block', 'padding': 20,
                                 'backgroundColor': '#fff', 'border': '1px solid #ddd', 'margin': '0 0.5%'}),

                        html.Div([
                            html.H4("Prix max (USD)", style={'textAlign': 'center'}),
                            html.H2(id='max-price', style={'textAlign': 'center', 'color': '#f39c12'})
                        ], style={'width': '24%', 'display': 'inline-block', 'padding': 20,
                                 'backgroundColor': '#fff', 'border': '1px solid #ddd', 'margin': '0 0.5%'}),

                        html.Div([
                            html.H4("Prix min (USD)", style={'textAlign': 'center'}),
                            html.H2(id='min-price', style={'textAlign': 'center', 'color': '#dd4b39'})
                        ], style={'width': '24%', 'display': 'inline-block', 'padding': 20,
                                 'backgroundColor': '#fff', 'border': '1px solid #ddd', 'margin': '0 0.5%'})
                    ])
                ]),

                # TAB 2: ANALYSE PAR SECTEUR
                dcc.Tab(label='Analyse par secteur', value='tab-sector', children=[
                    html.H3("Distribution par secteur", style={'marginTop': 20}),
                    dcc.Graph(id='sector-plot', style={'height': '500px'}),

                    html.H3("Volatilité par secteur", style={'marginTop': 30}),
                    dcc.Graph(id='volatility-plot', style={'height': '500px'})
                ]),

                # TAB 3: TABLEAU DE DONNÉES
                dcc.Tab(label='Données filtrées', value='tab-data', children=[
                    html.H3("Tableau des prix actuels", style={'marginTop': 20}),
                    dash_table.DataTable(
                        id='data-table',
                        style_table={'overflowX': 'auto'},
                        style_cell={'textAlign': 'left', 'padding': '10px'},
                        style_header={'backgroundColor': '#1f77b4', 'color': 'white', 'fontWeight': 'bold'}
                    )
                ]),

                # TAB 4: STATISTIQUES
                dcc.Tab(label='Statistiques', value='tab-stats', children=[
                    html.H3("Résumé des statistiques", style={'marginTop': 20}),
                    html.Div([
                        html.Div(id='stats-summary', style={'width': '48%', 'display': 'inline-block',
                                                           'verticalAlign': 'top', 'padding': 20}),
                        html.Div(id='price-summary', style={'width': '48%', 'display': 'inline-block',
                                                           'verticalAlign': 'top', 'padding': 20})
                    ]),

                    html.H3("Rendements par secteur", style={'marginTop': 30}),
                    dcc.Graph(id='returns-plot', style={'height': '500px'})
                ]),

                # TAB 5: COMPARAISON
                dcc.Tab(label='Comparaison', value='tab-comparison', children=[
                    html.H3("Comparaison des actions sélectionnées", style={'marginTop': 20}),
                    dcc.Graph(id='comparison-plot', style={'height': '600px'}),

                    html.H3("Volume de trading", style={'marginTop': 30}),
                    dcc.Graph(id='volume-plot', style={'height': '500px'})
                ])
            ])
        ], style={'width': '78%', 'display': 'inline-block', 'verticalAlign': 'top', 'padding': 20})
    ])
])

# ============================================================================
# CALLBACKS
# ============================================================================

@app.callback(
    [Output('main-plot', 'figure'),
     Output('total-actions', 'children'),
     Output('avg-price', 'children'),
     Output('max-price', 'children'),
     Output('min-price', 'children'),
     Output('sector-plot', 'figure'),
     Output('volatility-plot', 'figure'),
     Output('data-table', 'data'),
     Output('data-table', 'columns'),
     Output('stats-summary', 'children'),
     Output('price-summary', 'children'),
     Output('returns-plot', 'figure'),
     Output('comparison-plot', 'figure'),
     Output('volume-plot', 'figure')],
    [Input('sector-filter', 'value'),
     Input('symbol-filter', 'value'),
     Input('price-range', 'value'),
     Input('date-range', 'start_date'),
     Input('date-range', 'end_date')]
)
def update_dashboard(sector_filter, symbol_filter, price_range, start_date, end_date):
    # Filtrer les données
    filtered_data = sp500_data.copy()

    if sector_filter != 'Tous':
        filtered_data = filtered_data[filtered_data['sector'] == sector_filter]

    if symbol_filter and len(symbol_filter) > 0:
        filtered_data = filtered_data[filtered_data['symbol'].isin(symbol_filter)]

    filtered_data = filtered_data[
        (filtered_data['close'] >= price_range[0]) &
        (filtered_data['close'] <= price_range[1]) &
        (filtered_data['date'] >= start_date) &
        (filtered_data['date'] <= end_date)
    ]

    if len(filtered_data) == 0:
        empty_fig = go.Figure()
        empty_fig.add_annotation(text="Aucune donnée disponible", xref="paper", yref="paper",
                                x=0.5, y=0.5, showarrow=False, font=dict(size=20))
        return (empty_fig, "0", "$0.00", "$0.00", "$0.00", empty_fig, empty_fig,
                [], [], "Aucune donnée", "Aucune donnée", empty_fig, empty_fig, empty_fig)

    # GRAPHIQUE PRINCIPAL
    main_fig = px.line(filtered_data.sort_values('date'), x='date', y='close',
                       color='symbol', title='Évolution du prix',
                       labels={'date': 'Date', 'close': 'Prix (USD)', 'symbol': 'Action'})
    main_fig.update_layout(hovermode='x unified')

    # STATISTIQUES CLÉS
    n_actions = filtered_data['symbol'].nunique()
    avg_price = f"${filtered_data['close'].mean():.2f}"
    max_price = f"${filtered_data['close'].max():.2f}"
    min_price = f"${filtered_data['close'].min():.2f}"

    # DISTRIBUTION PAR SECTEUR
    sector_counts = filtered_data.groupby('sector').size().reset_index(name='count')
    sector_fig = px.bar(sector_counts, x='sector', y='count', color='sector',
                       title='Distribution par secteur',
                       labels={'sector': 'Secteur', 'count': 'Nombre'})
    sector_fig.update_layout(showlegend=False)

    # VOLATILITÉ PAR SECTEUR
    filtered_data_sorted = filtered_data.sort_values(['symbol', 'date'])
    filtered_data_sorted['returns'] = filtered_data_sorted.groupby('symbol')['close'].pct_change() * 100
    volatility = filtered_data_sorted.groupby('sector')['returns'].std().reset_index()
    volatility.columns = ['sector', 'volatility']
    volatility_fig = px.bar(volatility, x='sector', y='volatility', color='volatility',
                           title='Volatilité par secteur',
                           labels={'sector': 'Secteur', 'volatility': 'Volatilité (%)'})

    # TABLEAU DE DONNÉES
    latest_prices = filtered_data.sort_values('date').groupby('symbol').tail(1)
    table_data = latest_prices[['symbol', 'sector', 'close', 'volume', 'date']].sort_values('close', ascending=False)
    table_data.columns = ['Action', 'Secteur', 'Prix (USD)', 'Volume', 'Date']
    table_data['Date'] = table_data['Date'].dt.strftime('%Y-%m-%d')
    table_dict = table_data.to_dict('records')
    table_columns = [{"name": i, "id": i} for i in table_data.columns]

    # STATISTIQUES
    stats_text = html.Div([
        html.H4("=== RÉSUMÉ STATISTIQUE ==="),
        html.P(f"Nombre de lignes: {len(filtered_data)}"),
        html.P(f"Nombre d'actions: {filtered_data['symbol'].nunique()}"),
        html.P(f"Nombre de secteurs: {filtered_data['sector'].nunique()}"),
        html.P(f"Plage de dates: {filtered_data['date'].min().strftime('%Y-%m-%d')} à {filtered_data['date'].max().strftime('%Y-%m-%d')}")
    ])

    price_stats = html.Div([
        html.H4("Statistiques des prix"),
        html.P(f"Moyenne: ${filtered_data['close'].mean():.2f}"),
        html.P(f"Médiane: ${filtered_data['close'].median():.2f}"),
        html.P(f"Min: ${filtered_data['close'].min():.2f}"),
        html.P(f"Max: ${filtered_data['close'].max():.2f}"),
        html.P(f"Écart-type: ${filtered_data['close'].std():.2f}")
    ])

    # RENDEMENTS PAR SECTEUR
    returns_sector = filtered_data_sorted.dropna(subset=['returns']).groupby('sector')['returns'].mean().reset_index()
    returns_fig = px.bar(returns_sector, x='sector', y='returns',
                        title='Rendements quotidiens moyens par secteur',
                        labels={'sector': 'Secteur', 'returns': 'Rendement moyen (%)'})

    # COMPARAISON
    comparison_data = filtered_data.groupby('symbol').agg({
        'close': ['mean', 'max', 'min']
    }).reset_index()
    comparison_data.columns = ['symbol', 'avg_price', 'max_price', 'min_price']
    comparison_data = comparison_data.sort_values('avg_price', ascending=False).head(10)

    comparison_fig = go.Figure()
    comparison_fig.add_trace(go.Bar(
        x=comparison_data['symbol'],
        y=comparison_data['avg_price'],
        error_y=dict(
            type='data',
            symmetric=False,
            array=comparison_data['max_price'] - comparison_data['avg_price'],
            arrayminus=comparison_data['avg_price'] - comparison_data['min_price']
        ),
        name='Prix moyen'
    ))
    comparison_fig.update_layout(title='Comparaison des prix (min/moyen/max)',
                                xaxis_title='Action', yaxis_title='Prix (USD)')

    # VOLUME
    volume_data = filtered_data.groupby('symbol')['volume'].mean().reset_index()
    volume_data['volume'] = volume_data['volume'] / 1e6
    volume_data = volume_data.sort_values('volume', ascending=False).head(10)
    volume_fig = px.bar(volume_data, x='symbol', y='volume', color='volume',
                       title='Volume de trading moyen',
                       labels={'symbol': 'Action', 'volume': 'Volume (millions)'})
    volume_fig.update_layout(showlegend=False)

    return (main_fig, str(n_actions), avg_price, max_price, min_price,
            sector_fig, volatility_fig, table_dict, table_columns,
            stats_text, price_stats, returns_fig, comparison_fig, volume_fig)

# ============================================================================
# LANCER L'APPLICATION
# ============================================================================

if __name__ == '__main__':
    print("\n" + "="*60)
    print("Dashboard S&P 500 démarré!")
    print("Ouvrez votre navigateur à l'adresse: http://127.0.0.1:8050/")
    print("="*60 + "\n")
    app.run(debug=True, port=8050)
