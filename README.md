# MIA_Script-Sentence-Card-and-Look-Up
Script for the MIA/AJATT community to make sentence cards easier as well as looking up words in qolibri faster.

CHANGES SINCE FIRST RELEASE:

2018-10-18:
Removed the use of the qolibriCharacterLimit variable. Now the jisho lookup funciton only searches in jisho, no matter how small the searched text is.
Fixed a bug that the qolibri lookup function checked for the qolibriCharacterLimit even though that shouldn't make a difference.

2018-10-22:
Fixed the delay between a few actions. You can change the delay by changing the global 'sleepDuration' variable.
Fixed so the script keeps spacing when copying over to jisho and qolibri, before the script got rid of all the spaces.
