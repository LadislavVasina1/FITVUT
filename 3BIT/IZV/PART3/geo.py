#!/usr/bin/python3.10
# coding=utf-8
import pandas as pd
import geopandas
import matplotlib.pyplot as plt
import contextily as ctx
import numpy as np
from sklearn.cluster import MiniBatchKMeans


def make_geo(df: pd.DataFrame) -> geopandas.GeoDataFrame:
    """
    @Author: Ladislav Vašina, xvasin11
    Convert given dataframe to geopandas.GeoDataFrame with correct coding

    :param df: pandas dataFrame containing data about car crashes
    :return: dataframe converted to GeoDataFrame
    """

    df['date'] = pd.to_datetime(df['p2a'])
    headers = ["p1", "p36", "p37", "p2a", "weekday(p2a)", "p2b", "p6", "p7", "p8", "p9", "p10", "p11", "p12", "p13a",
               "p13b", "p13c", "p14", "p15", "p16", "p17", "p18", "p19", "p20", "p21", "p22", "p23", "p24", "p27",
               "p28",
               "p34", "p35", "p39", "p44", "p45a", "p47", "p48a", "p49", "p50a", "p50b", "p51", "p52", "p53", "p55a",
               "p57", "p58", "h", "i", "j", "k", "l", "n", "o", "p", "q", "r", "s", "t"]

    df[headers] = df[headers].astype('category')
    df = df.dropna(subset=['d', 'e'])
    gdf = geopandas.GeoDataFrame(df, geometry=geopandas.points_from_xy(df['d'], df['e']), crs="EPSG:5514")
    return gdf


def plot_geo(gdf: geopandas.GeoDataFrame, fig_location: str = None, show_figure: bool = False):
    """
    @Author: Ladislav Vašina, xvasin11
    Function plots map visualising car crashes that happened because of drug/alcohol use (2018-2021)

    :param gdf: GeoDataFrame with the data about crashes
    :param fig_location: path for saving generated graphs
    :param show_figure: Bool stating if user wants to show generated map
    :return: nothing (shows or saves the plot)
    """

    region_to_plot = ['PAK']
    # Filter by data by selected region and convert map's crs
    years_to_plot = [2018, 2019, 2020, 2021]
    drivers_influence_types = [3, 4, 5, 6, 7, 8, 9]
    data_to_plot = gdf[gdf['region'].isin(region_to_plot)].to_crs('EPSG:3857')
    # Filter data so that it includes only crashes where driver was under the influence
    data_to_plot = data_to_plot[
        data_to_plot['date'].dt.year.isin(years_to_plot) & data_to_plot['p11'].isin(drivers_influence_types)]
    fig, ax = plt.subplots(2, 2, figsize=(10, 7), gridspec_kw={'hspace': 0, 'wspace': 0.2})

    for i, axes in enumerate(ax.reshape(-1)):
        current_year = 2018 + i
        data_to_plot_tmp = data_to_plot[data_to_plot['date'].dt.year == current_year]
        data_to_plot_tmp.plot(ax=axes, markersize=1, color="red")
        ctx.add_basemap(axes,
                        crs=data_to_plot_tmp.crs.to_string(),
                        source=ctx.providers.OpenStreetMap.Mapnik,
                        zoom=10,
                        attribution_size=2)
        axes.set_title(f"{region_to_plot[0]} kraj ({current_year})")
        axes.set_axis_off()

    if fig_location:
        plt.savefig(fig_location, dpi=200)
    if show_figure:
        plt.show()
    plt.close()


def plot_cluster(gdf: geopandas.GeoDataFrame, fig_location: str = None, show_figure: bool = False):
    """
    @Author: Ladislav Vašina, xvasin11
    Function plots map visualising cluster of car crashes

    :param gdf: GeoDataFrame with the data about crashes
    :param fig_location: path for saving generated graphs
    :param show_figure: Bool stating if user wants to show generated map
    :return: nothing (shows or saves the plot)
    """

    region_to_plot = ['PAK']
    wanted_road_types = [1, 2, 3]
    # Filtering our data to contain only wanted region and road type
    data_to_plot = gdf[gdf['region'].isin(region_to_plot) & gdf['p36'].isin(wanted_road_types)].to_crs('EPSG:3857')

    # Getting crash points and reshaping them to correct shape
    x = data_to_plot.geometry.x
    y = data_to_plot.geometry.y
    points = np.dstack([x, y]).reshape(-1, 2)

    data_to_plot['clusters'] = MiniBatchKMeans(n_clusters=16).fit(points).labels_
    data_to_plot = data_to_plot.dissolve(by="clusters", aggfunc={"p1": "count"})

    # Plotting the map
    fig, ax = plt.subplots(1, 1, figsize=(10, 7))
    data_to_plot.plot(ax=ax,
                      markersize=1,
                      column='p1',
                      legend=True,
                      legend_kwds={'label': "Počet nehod v úseku", 'orientation': "horizontal", 'shrink': 0.75,
                                   'anchor': (0.5, 1)},
                      cmap='plasma')
    ctx.add_basemap(ax,
                    crs=data_to_plot.crs.to_string(),
                    source=ctx.providers.OpenStreetMap.Mapnik,
                    zoom=10,
                    attribution_size=2)
    ax.set_title(f'Nehody v {region_to_plot[0]} kraji na silnicích 1. 2. a 3. třídy (2016 - 2021)')
    ax.set_axis_off()
    plt.tight_layout()

    if fig_location:
        plt.savefig(fig_location, dpi=200)
    if show_figure:
        plt.show()
    plt.close()


if __name__ == "__main__":
    """
    Main program function
    """

    gdf = make_geo(pd.read_pickle("accidents.pkl.gz"))
    plot_geo(gdf, "geo1.png", True)
    plot_cluster(gdf, "geo2.png", True)
