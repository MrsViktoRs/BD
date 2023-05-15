CREATE TABLE IF NOT EXISTS Album (
album_id SERIAL PRIMARY KEY,
name VARCHAR (60) NOT NULL,
year INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS Executor (
executor_id SERIAL PRIMARY KEY,
nickname VARCHAR (60) NOT NULL
);
CREATE TABLE IF NOT EXISTS Genres (
genre_id SERIAL PRIMARY KEY,
name VARCHAR (60) NOT NULL
);
CREATE TABLE IF NOT EXISTS Collection (
collection_id SERIAL PRIMARY KEY,
name VARCHAR (60) NOT NULL,
year INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS Tracks (
track_id SERIAL PRIMARY KEY,
name VARCHAR (60) NOT NULL,
duration NUMERIC NOT NULL,
album_id INTEGER REFERENCES Album(album_id)
);
CREATE TABLE IF NOT EXISTS CollectionTracks (
collection_id INTEGER NOT NULL REFERENCES Collection(collection_id),
tracks_id INTEGER NOT NULL REFERENCES Tracks(track_id),
CONSTRAINT pk_collectiontracks PRIMARY KEY (collection_id, tracks_id)
);
CREATE TABLE IF NOT EXISTS AlbumExecutor (
album_id INTEGER  REFERENCES Album(album_id),
executor_id INTEGER  REFERENCES Executor(executor_id),
CONSTRAINT pk_albumexecutor PRIMARY KEY (album_id, executor_id)
);
CREATE TABLE IF NOT EXISTS ExecutorGenres (
executor_id INTEGER  REFERENCES Executor(executor_id),
genre_id INTEGER  REFERENCES Genres(genre_id),
CONSTRAINT pk_executorgenres PRIMARY KEY (executor_id, genre_id)
);
--Поздно увидел что INSERT(Ы) так же нужно показывать, по такому же принципу заполнял все таблицы.
INSERT INTO tracks (track_id, name, duration)
VALUES ('20', 'ИМЯ' '2');
--Название и продолжительность самого длительного трека.
SELECT name, duration FROM tracks
WHERE duration = (SELECT MAX(duration) FROM tracks);
--Название треков, продолжительность которых не менее 3,5 минут.
SELECT name FROM tracks
WHERE duration > 3.5;
--Названия сборников, вышедших в период с 2018 по 2020 год включительно.
SELECT name FROM collection
WHERE year BETWEEN 2018 AND 2020;
--Исполнители, чьё имя состоит из одного слова.
SELECT nickname FROM executor
WHERE nickname NOT LIKE '% %';
--Название треков, которые содержат слово «мой» или «my».
SELECT name FROM tracks
WHERE name LIKE '%My%';
--Количество исполнителей в каждом жанре.
SELECT genre_id, COUNT(executor_id) FROM executorgenres
GROUP BY genre_id;
--Количество треков, вошедших в альбомы 2019–2020 годов.
SELECT COUNT(track_id) FROM tracks
WHERE album_id IN (SELECT album_id FROM album
					WHERE year BETWEEN 2019 AND 2020);
--Средняя продолжительность треков по каждому альбому.
SELECT album_id, AVG(duration) FROM tracks
GROUP BY album_id;
--Все исполнители, которые не выпустили альбомы в 2020 году.
SELECT nickname FROM executor
WHERE executor_id IN (SELECT executor_id FROM albumexecutor
					  WHERE album_id IN (SELECT album_id FROM album
					  WHERE year != 2020));
--Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами).
SELECT c.name FROM collection c
JOIN collectiontracks c2 ON c.collection_id = c2.collection_id
JOIN tracks t ON c2.tracks_id = t.track_id 
JOIN album a ON t.album_id = a.album_id 
JOIN albumexecutor a2 ON a.album_id = a2.album_id
JOIN executor e ON a2.executor_id = e.executor_id
WHERE e.nickname = 'Red zebra';