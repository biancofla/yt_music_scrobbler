import json
import os
import traceback
from datetime import datetime, timedelta, timezone
from typing import Dict, List

import boto3
from pylast import LastFMNetwork
from ytmusicapi import OAuthCredentials, YTMusic


class SSMClient:
    def __init__(self):
        self.ssm = boto3.client("ssm")
        self.prefix = os.environ.get("SSM_PREFIX", "/yt-music-scrobbler")

    def get_parameter(self, name: str, decrypt: bool = True) -> str:
        response = self.ssm.get_parameter(
            Name=f"{self.prefix}/{name}", WithDecryption=decrypt
        )
        return response["Parameter"]["Value"]

    def put_parameter(
        self,
        name: str,
        value: str,
        type: str = "SecureString",
        overwrite: bool = True,
    ) -> None:
        self.ssm.put_parameter(
            Name=f"{self.prefix}/{name}",
            Value=value,
            Type=type,
            Overwrite=overwrite,
        )


class LastFMClient:
    def __init__(
        self, api_key: str, api_secret: str, username: str, password_hash: str
    ):
        self.lastfm = LastFMNetwork(
            api_key=api_key,
            api_secret=api_secret,
            username=username,
            password_hash=password_hash,
        )

    def _sanitize_tracks(self, tracks: Dict) -> List[Dict]:
        return [
            {
                "artist": track["artist"],
                "title": track["title"],
                "timestamp": track["played_at"],
                "album": track["album"],
            }
            for track in tracks
        ]

    def scrobble_many(self, tracks: List[Dict]) -> None:
        self.lastfm.scrobble_many(tracks=self._sanitize_tracks(tracks))


class YTMusicClient:

    def __init__(
        self,
        client_id: str,
        client_secret: str,
        oauth_file: str,
    ):
        oauth_credentials = OAuthCredentials(
            client_id=client_id,
            client_secret=client_secret,
        )

        oauth, now = json.loads(oauth_file), int(
            datetime.now(timezone.utc).timestamp()
        )
        if now > oauth.get("expires_at"):
            oauth["access_token"] = oauth_credentials.refresh_token(
                refresh_token=oauth.get("refresh_token"),
            )["access_token"]
            oauth["expires_at"] = now + 3599
            SSMClient().put_parameter("google_oauth_file", json.dumps(oauth))

        self.ytmusic = YTMusic(oauth, oauth_credentials=oauth_credentials)

    def get_today_history(self) -> List[Dict]:
        today_history = list(
            filter(lambda x: x["played"] == "Today", self.ytmusic.get_history())
        )
        today_history.reverse()

        history, today = [], datetime.now(timezone.utc).replace(
            hour=0, minute=0, second=0, microsecond=0
        )
        for track in today_history:
            try:
                title = track["title"]
                artist = track["artists"][0]["name"]
                album = track["album"]["name"]
                duration = track["duration"]

                duration_min, duration_sec = track["duration"].split(":")
                played_at = today

                history.append(
                    {
                        "title": title,
                        "artist": artist,
                        "album": album,
                        "duration": duration,
                        "played_at": int(played_at.timestamp()),
                    }
                )

                today = played_at + timedelta(
                    minutes=int(duration_min), seconds=int(duration_sec)
                )
            except KeyError as e:
                print("[WARNING] Missing key in track data: ", e)
                continue

        return history


def lambda_handler(event, context) -> Dict:
    try:
        ssm_client = SSMClient()
        (
            client_id,
            client_secret,
            oauth_file,
            lastfm_api_key,
            lastfm_shared_secret,
            lastfm_username,
            lastfm_password_hash,
        ) = (
            ssm_client.get_parameter("google_client_id"),
            ssm_client.get_parameter("google_client_secret"),
            ssm_client.get_parameter("google_oauth_file"),
            ssm_client.get_parameter("lastfm_api_key"),
            ssm_client.get_parameter("lastfm_shared_secret"),
            ssm_client.get_parameter("lastfm_username"),
            ssm_client.get_parameter("lastfm_password_hash"),
        )

        yt_music_client = YTMusicClient(
            client_id=client_id,
            client_secret=client_secret,
            oauth_file=oauth_file,
        )
        history = yt_music_client.get_today_history()

        lastfm_client = LastFMClient(
            api_key=lastfm_api_key,
            api_secret=lastfm_shared_secret,
            username=lastfm_username,
            password_hash=lastfm_password_hash,
        )
        lastfm_client.scrobble_many(tracks=history)

        print(f"[INFO] Scrobbled {len(history)} tracks to Last.fm.")
        return {
            "statusCode": 200,
            "body": f"Scrobbled {len(history)} tracks to Last.fm.",
        }
    except Exception as e:
        print(traceback.format_exc())
        return {
            "statusCode": 500,
            "body": f"An error occurred during the scrobbling process: {str(e)}.",
        }


if __name__ == "__main__":
    lambda_handler(None, None)
