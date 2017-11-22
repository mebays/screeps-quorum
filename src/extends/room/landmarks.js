
Room.prototype.getSuicideBooth = function () {
  // Identify spawn closest to storage, to make reclaimed energy easier to store.
  let spawn = false
  if (this.storage) {
    spawn = this.storage.pos.findClosestByRange(this.structures[STRUCTURE_SPAWN])
  } else if (this.structures[STRUCTURE_SPAWN].length) {
    spawn = this.structures[STRUCTURE_SPAWN][0]
  }

  if (!spawn) {
    return false
  }

  // Pick the location immediately above the spawn and recycle there.
  return new RoomPosition(spawn.pos.x, spawn.pos.y - 1, spawn.room.name)
}
