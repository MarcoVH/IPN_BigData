import pandas as pd
import numpy as np
import datetime
import calendar

df = pd.read_csv('velocidades.csv')

preguntas = ['No. de registros',
             'Vehículos diferentes',
             'No. de días diferentes',
             'Rango de Fechas',
             'Meses completos',
             'Horario de la flota',
             'Velocidad máxima registrada',
             'Vehículos que registran la velocidad máxima',
             'No. de Vehículos que rebasan el límite de velocidad',
             'Vehículos que rebasan el límite de velocidad',
             'Horas con mayor frecuencia de excesos de velocidad']

df['fecha'] = pd.to_datetime(df['fecha'])
df['horae'] = pd.to_datetime(df['hora'], format='%H:%M:%S', utc=True)
df['horae'] = df.horae.dt.hour

aux = df[df['velocidad']>80].groupby(by= ['horae']).count()
horas_ex = list(aux[aux['id'] == aux['id'].max()].index)

df['mes'] = pd.DatetimeIndex(df['fecha']).month
df['ano'] = pd.DatetimeIndex(df['fecha']).year

meses_completos = []
for y in df['ano'].unique():
    for m in df['mes'].unique():
        if df.loc[:,'fecha'].min().date() <= datetime.date(y, m, 1):
            if datetime.date(y, m, calendar.monthrange(y,m)[1]) <= df.loc[:,'fecha'].max().date():
                meses_completos.append(str(y)+ "-" +str(m))

df['anomes'] = df['ano'].map(str)+"-"+df['mes'].map(str)
aux = df[df['anomes'].isin(meses_completos)]
aux = aux[['anomes', 'velocidad']]
velocidad_promedio_mes = aux.groupby(by='anomes').mean()

respuestas = [len(df),
              len(df['Vehiculo'].unique()),
              len(df['fecha'].unique()),
              'De ' + str(df.loc[:,'fecha'].min().date()) + ' a ' + str(df.loc[:,'fecha'].max().date()),
              (df.loc[:,'fecha'].max() - df.loc[:,'fecha'].min())// np.timedelta64(1, 'M'),
              'De ' + str(df.loc[:,'hora'].min()) + ' a ' + str(df.loc[:,'hora'].max()),
              df.loc[:,'velocidad'].max(),
              list(df.loc[df['velocidad'] == df.loc[:,'velocidad'].max(),'Vehiculo'].unique()),
              len(df.loc[df['velocidad'] > 80, 'Vehiculo'].unique()),
              list(df.loc[df['velocidad'] > 80, 'Vehiculo'].unique()),
              horas_ex,
              ]

resultado = pd.DataFrame(
    {
        'Concepto': preguntas,
        'Valor': respuestas
    }
)

resultado.to_csv('resultado.csv', sep=',', encoding="latin-1")

velocidad_promedio_mes.to_csv('velocidad_promedio_mes.csv', sep=",", encoding="latin-1")