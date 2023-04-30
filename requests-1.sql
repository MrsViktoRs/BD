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