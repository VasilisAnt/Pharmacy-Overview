# Pharmacy-Overview
Various pharmacy-related graphs and tables

1. Κάνουμε εγκατάσταση το R: Ανοίγουμε το link (https://ftp.cc.uoc.gr/mirrors/CRAN/) και επιλέγουμε “Download R for Windows”, έπειτα “install R for the first time” και μετά "Download R 4.1.2 for Windows". 

3. Κατεβάζουμε το R Studio: Ανοίγουμε το link (https://www.rstudio.com/products/rstudio/download/) και επιλέγουμε download στο free RStudio Desktop και έπειτα "Download RStudio for Windows".

4. Δημιουργούμε μέσα στον σκληρό δίσκο έναν φάκελο με το όνομα “My pharmacy”

5. Μέσα στον φάκελο My pharmacy δημιουργούμε 4 υπό-φακέλους “Ilyda exports”, “Prescriptions”, “Tameio”, “Tziros”

6. Μέσα στον φάκελο “Ilyda exports” δημιουργούμε δύο υπο-φακέλους, έναν με το όνομα “Farmaka” και έναν με το όνομα “Parafarmaka”. Μέσα στον φάκελο “Farmaka” δημιουργούμε έναν φάκελο με το όνομα “2020” και έναν φάκελο με το όνομα “2021”. Το ίδιο και μέσα στον φάκελο “Parafarmaka”, δημιουργούμε έναν φάκελο με το όνομα “2020” και έναν φάκελο με το όνομα “2021.

7. Μέσα στον φάκελο Tziros δημιουργούμε δύο υπό-φακέλους, έναν με το όνομα 2020 και έναν με το όνομα 2021. 


![](folders.PNG)

8. Μπαίνουμε στο e-prescriptions και κατεβάζουμε τις συνταγές κάθε ημέρας μία-μία και τις αποθηκεύουμε σε μορφή pdf. Όλες οι συνταγές θα πρέπει να βρίσκονται στον φάκελο “Prescriptions”.

9. Μπαίνουμε στο πρόγραμμα Dioscurides.

10. Για κάθε μήνα θα χρειαστεί να εξάγουμε 4 αρχεία σε μορφή Excel από το Dioscuride:

10a. Στατιστικά-Γραφήματα -> Diosc MIS Πληροφοριακό Σύστημα -> Συνολικά Στατιστικά -> Μεικτό Κέρδος -> Επιλογή ημερομηνίας (ανά μήνα) -> Εμφάνιση Εξαγωγή σε Αρχείο -> ΟΚ -> Export Report -> Format: Microsoft Excel 97-2000 – Data only (XLS), Destination: Disk file -> OK

Τοποθετούμε αυτό το αρχείο xls στην αντίστοιχο φάκελο της χρονιάς που ανήκει ο μήνας που κάναμε εξαγωγή μέσα στον φάκελο "Tziros".

![](2021_tziros.PNG)

10b. Πωλήσεις Φαρμάκων -> 14. Αναλυτικά Ανά Είδος -> Επιλογή ημερομηνίας (ανά μήνα) -> Εμφάνιση Εξαγωγή σε Αρχείο -> ΟΚ -> Export Report -> Format: Microsoft Excel 97-2000 – Data only (XLS), Destination: Disk file -> OK

Τοποθετούμε αυτό το αρχείο xls στην αντίστοιχο φάκελο της χρονιάς που ανήκει ο μήνας που κάναμε εξαγωγή μέσα στον φάκελο "Farmaka" που βρίσκεται μέσα στον φάκελο "Ilyda exports".

![](2021_farmaka.PNG)

10c. Πωλήσεις Παραφαρμάκων -> 8. Αναλυτικά Ανά Είδος -> Επιλογή ημερομηνίας (ανά μήνα) -> Εμφάνιση Εξαγωγή σε Αρχείο -> ΟΚ -> Export Report -> Format: Microsoft Excel 97-2000 – Data only (XLS), Destination: Disk file -> OK

Τοποθετούμε αυτό το αρχείο xls στην αντίστοιχο φάκελο της χρονιάς που ανήκει ο μήνας που κάναμε εξαγωγή μέσα στον φάκελο "Parafarmaka" που βρίσκεται μέσα στον φάκελο "Ilyda exports".

![](2021_parafarmaka.PNG)

10d. Στοιχεία Λογιστηρίου -> Κατάσταση Ελέγχου Κινήσεων -> Επιλογή Ημερομηνίας (Από 1/1 του τρέχοντος έτους μέχρι την τελευταία μέρα του μήνα που μόλις τελείωσε) -> Εκτύπωση -> Εξαγωγή σε αρχείο MS Excel ή κειμένου (check if it should xls or xlsx)

Τοποθετούμε αυτό το αρχείο xls μέσα στον φάκελο "Tameio".

![](tameio.PNG)

11. Μετά που θα κατεβάσουμε τα 4 αρχεία θα τα ανοίξουμε έναν-ένα και θα τα κάνουμε αποθήκευση σε μορφή xlsx. Τα 4 αρχεία σε μορφή xlsx θα είναι αυτά που θα χρησιμοποιήσουμε. 

12. Ανοίγουμε το R Studio

13. Κάνουμε copy- paste στο console αυτό και περιμένουμε να γίνει η εγκατάσταση: install.packages(c("tidyverse", "readxl", "lubridate", "janitor", "scales", "openxlsx", "ggrepel", "broom", "infer", "pdftools", "tm", "glue")

14. Πατάμε File -> New file -> R Markdown

15. Στον τίτλο βάζουμε My Pharmacy το Author το αφήνουμε κενό και πατάμε Ok

16. Πατάμε Ctrl + A επιλέγοντας όλο το περιεχόμενο και το σβήνουμε πατώντας Delete

17. Κάνουμε copy-paste όλο τον κώδικα μέσα στο R Markdown

18. Πατάμε Ctrl + Alt + R και περιμένουμε να τρέξει όλος ο κώδικας

19. Πατάμε File -> New File -> Shiny Web App

20. Επιλέγουμε όνομα εφαρμογής π.χ. «My Pharmacy App”

21. Πατάμε Ctrl + A επιλέγοντας όλο το περιεχόμενο και το σβήνουμε πατώντας Delete

22. Κάνουμε copy- paste όλο τον κώδικα της εφαρμογής αυτή την φορά

23. Πατάμε Ctrl + Shift + Enter
