String getTimerString() {
  int time = getTimeSeconds();
  return toTwoDigets(time / 60) + ":" + toTwoDigets(time % 60);
}

int getTimeSeconds() {
  if (gameStatus == GAME_OVER)
    return lastTime;
  return timerStartTime == 0 ? 0 : getUnixTime() - timerStartTime;
}
