-- sqlite3 ~/playlister.db ".read export_playlisterdb_to_tsv.sql"

.headers on
.mode tabs
.output albums.tsv

select GROUP_CONCAT(artist, '; ') as artists,
    album,
    track_count,
    release_date,
    added_at,
    playlist
from (
        select art.name as artist,
            a.name as album,
            a.id as album_id,
            a.total_tracks as track_count,
            substr(a.release_date, 1, 4) as release_date,
            pt.added_at,
            p.name as playlist,
            p.id as playlist_id
        from Album a
            join albumartist aa on aa.album_id = a.id
            join artist art on art.id = aa.artist_id
            join track t on t.album_id = a.id
            join playlisttrack pt on pt.track_id = t.id
            join playlist p on p.id = pt.playlist_id
        where p.name like 'starred%'
        group by a.id,
            art.id,
            p.id
        order by p.id,
            a.id,
            art.name
    )
group by album_id,
    playlist_id
order by added_at;

.output stdout
.headers off