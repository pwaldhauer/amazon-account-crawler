# amazon.rb - Readme

Script zum aufsummieren der Amazon-Ausgaben.

Dieses Script crawlt mittels Mechanize durch das Amazon-Konto und addiert alle getätigten Bestellungen auf, damit man am Ende schöne Statistiken (Euro/Jahr) erstellen kann.

Aus der Reihe: Schnell zusammengehackt, keinerlei Anspruch auf Perfektion, aber geforkt und erweitert!

## 1. Requirements
1. Ruby
2. Rubygems
3. Rubygem: highline
4. Rubygem: mechanize

## 2. Benutzung

1. `ruby amazon.rb`
2. E-Mail und Passwort eingeben
3. Land wählen
4. Warten.

## 3. Todos

Insgesamt fehlen noch einige Sachen, aber ich bin wohl zu faul dazu. <del>Forkt es und macht es besser!</del>
Roger that!

1. <del>Geht nur auf amazon.de (nicht auf .com/co.uk)</del> Geht jetzt auch auf amazon.co.uk, ist prinzipiell einfach erweiterbar für alle Seiten, die das aktuelle Layout benutzen (Ja, amazon.com, ich schaue dich an!)
2. Daten werden nicht sinnvoll (als csv oder so) ausgegeben
3. Der Code ist nicht aufgeräumt oder schön -- sorry, erstes Ruby-Dings für mich
4. <del>Keinerlei Fehlerbehandlung, wenn er irgendwelche Felder nicht findet, oder XPath-Queries fehlschlagen</del> Sehr wenig Fehlerbehandlung. Nicht schön oder gut.
5. Requests auf die Order-Übersichts-Seiten könnten parallelisiert werden um das crawlen zu verschnellern
6. Sicher noch viel mehr
