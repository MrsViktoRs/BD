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
duration INTEGER NOT NULL,
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
INSERT INTO album(name, year) VALUES
	('This man', 2022),
	('Monki', 2019),
	('Train', 2020);
INSERT INTO tracks(name, album_id, duration) VALUES
	('Сердце', '1', '84'),
	('Белый снег', '1', '104'),
	('Dead Fish', '2', '144'),
	('Буква', '3', '110'),
	('My star', '3', '187'),
	('Gobb', '3', '214'),
	('Ruplic', '3', '143');
INSERT INTO executor(nickname) VALUES
	('Кассета'),
	('Red zebra'),
	('Toy machine'),
	('Капитан крюк');
INSERT INTO genres(name) VALUES
	('Rock'), 
	('Punk'), 
	('Rap');
INSERT INTO collection(name, year) VALUES
	('EeeeeeBoy', 2022),
	('Sport', 2023),
	('Dance', 2020),
	('Coolcoll', 2018);
INSERT INTO albumexecutor(album_id, executor_id) VALUES
	(1,3),
	(2,1),
	(3,2),
	(3,1);
INSERT INTO executorgenres(executor_id, genre_id) VALUES
	(1,3),
	(2,1),
	(3,1),
	(4,2),
	(3,3);
INSERT INTO collectiontracks(collection_id, tracks_id) VALUES
	(1,2),
	(1,4),
	(1,1),
	(2,1),
	(2,5),
	(2,6),
	(2,2),
	(3,6),
	(3,4),
	(3,1),
	(4,1),
	(4,2),
	(4,4),
	(4,5),
	(4,6);
--Название и продолжительность самого длительного трека.
SELECT name, duration FROM tracks
WHERE duration = (SELECT MAX(duration) FROM tracks);
--Название треков, продолжительность которых не менее 3,5 минут.
SELECT name FROM tracks
WHERE duration >= 210;
--Названия сборников, вышедших в период с 2018 по 2020 год включительно.
SELECT name FROM collection
WHERE year BETWEEN 2018 AND 2020;
--Исполнители, чьё имя состоит из одного слова.
SELECT nickname FROM executor
WHERE nickname NOT LIKE '% %';
--Название треков, которые содержат слово «мой» или «my». (Вариант 1)
SELECT name FROM tracks
WHERE name ILIKE 'My %'
OR name ILIKE '% My'
OR name ILIKE '% My %'
OR name ILIKE 'My';
--Название треков, которые содержат слово «мой» или «my». (Вариант 2)
SELECT name FROM tracks
WHERE string_to_array(lower(name), ' ') && ARRAY['my']; 
--Название треков, которые содержат слово «мой» или «my». (Вариант 3)
SELECT name FROM tracks
WHERE name ~* '(\Amy|my|\Zmy)';
--Количество исполнителей в каждом жанре.
SELECT g.name, COUNT(eg.executor_id) FROM executorgenres AS eg
LEFT JOIN genres g ON g.genre_id = eg.genre_id 
GROUP BY g.genre_id;
--Количество треков, вошедших в альбомы 2019–2020 годов.
SELECT COUNT(track_id) FROM tracks
WHERE album_id IN (SELECT album_id FROM album
					WHERE year BETWEEN 2019 AND 2020);
--Средняя продолжительность треков по каждому альбому.
SELECT album_id, AVG(duration) FROM tracks
GROUP BY album_id;
--Все исполнители, которые не выпустили альбомы в 2020 году.
SELECT nickname FROM executor
WHERE nickname NOT IN (SELECT nickname FROM executor e
		JOIN albumexecutor a ON a.executor_id = e.executor_id
		JOIN album a2 ON a.album_id = a2.album_id
		WHERE year = 2020);
--Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами).
SELECT c.name FROM collection c
JOIN collectiontracks c2 ON c.collection_id = c2.collection_id
JOIN tracks t ON c2.tracks_id = t.track_id 
JOIN album a ON t.album_id = a.album_id 
JOIN albumexecutor a2 ON a.album_id = a2.album_id
JOIN executor e ON a2.executor_id = e.executor_id
WHERE e.nickname = 'Red zebra';