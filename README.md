# Pharmacy-Overview
Various pharmacy-related graphs and tables

1.	Κάνουμε εγκατάσταση το R και R studio (https://ftp.cc.uoc.gr/mirrors/CRAN/)

1a. Ανοίγουμε το παραπάνω link και επιλέγουμε “Download R for Windows” και έπειτα “install R for the first time”

1b. Κατεβάζουμε το R Studio (https://www.rstudio.com/products/rstudio/download/)

2. Δημιουργούμε μέσα στον σκληρό δίσκο έναν φάκελο με το όνομα “My pharmacy”

2a. Μέσα στον φάκελο My pharmacy δημιουργούμε 4 υπό-φακέλους “Ilyda exports”, “Prescriptions”, “Tameio”, “Tziros”

2b. Μέσα στον φάκελο “Ilyda exports” δημιουργούμε δύο υπο-φακέλους, έναν με το όνομα “Farmaka” και έναν με το όνομα “Parafarmaka”. Μέσα στον φάκελο “Farmaka” δημιουργούμε έναν φάκελο με το όνομα “2020” και έναν φάκελο με το όνομα “2021”. Το ίδιο και μέσα στον φάκελο “Parafarmaka”, δημιουργούμε έναν φάκελο με το όνομα “2020” και έναν φάκελο με το όνομα “2021.

2c. Μέσα στον φάκελο Tziros δημιουργούμε δύο υπό-φακέλους, έναν με το όνομα 2020 και έναν με το όνομα 2021. 


![](folders.PNG)

3.	Μπαίνουμε στο e-prescriptions και κατεβάζουμε τις συνταγές κάθε ημέρας μία μία αποθηκεύοντας τες σε μορφή pdf. Όλες οι συνταγές θα βρίσκονται στον φάκελο “Prescriptions”.


4.	Μπαίνουμε στο πρόγραμμα Dioscurides . Για κάθε μήνα θα χρειαστεί να εξάγουμε 4 αρχεία σε μορφή Excel από το Dioscurides

4a. Στατιστικά -> Μεικτό Κέρδος (Τζίρος)

4b. Στατιστικά -> Φάρμακα

4c. Στατιστικά -> Παραφάρμακα

4d. Ταμείο -> Ταμείο χρονιάς

5.	Ανοίγουμε το R Studio

6.	Κάνουμε copy- paste στο console αυτό και περιμένουμε να γίνει η εγκατάσταση: install.packages(c("tidyverse", "readxl", "lubridate", "janitor", "scales", "openxlsx", "ggrepel", "broom", "infer", "pdftools", "tm", "glue")

7.	Πατάμε File -> New file -> R Markdown

8.	Στον τίτλο βάζουμε My Pharmacy το Author το αφήνουμε κενό και πατάμε Ok

9.	Πατάμε Ctrl + A επιλέγοντας όλο το περιεχόμενο και το σβήνουμε πατώντας Delete

10.Κάνουμε copy-paste όλο τον κώδικα μέσα στο R Markdown

11.	Πατάμε Ctrl + Alt + R και περιμένουμε να τρέξει όλος ο κώδικας

12.	Πατάμε File -> New File -> Shiny Web App

13.	Επιλέγουμε όνομα εφαρμογής π.χ. «My Pharmacy App”

14.	Πατάμε Ctrl + A επιλέγοντας όλο το περιεχόμενο και το σβήνουμε πατώντας Delete

15.	Κάνουμε copy- paste όλο τον κώδικα της εφαρμογής αυτή την φορά

16.	Πατάμε Ctrl + Shift + Enter
