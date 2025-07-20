# Helpers for converting values to lua
{lib}: {
  writeIf = cond: msg:
    if cond
    then msg
    else "";

  yesNo = value:
    if value
    then "yes"
    else "no";

  nullString = value:
    if value == null
    then "nil"
    else "'${value}'";
}
