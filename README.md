# amazon.rb - Readme

Script zum aufsummieren der Amazon.de-Ausgaben.

Dieses Script crawlt mittels Mechanize durch das Amazon-Konto und addiert alle getätigten Bestellungen auf, damit man am Ende schöne Statistiken (Euro/Jahr) erstellen kann.

## 1. Requirements
1. Ruby
2. Rubygems
3. Rubygem: highline
4. Rubygem: mechanize

## 2. Benutzung

1. `ruby amazon.rb`
2. E-Mail und Passwort eingeben
3. Warten.

## 3. Todos

Insgesamt fehlen noch einige Sachen, aber ich bin wohl zu faul dazu. Forkt es und macht es besser!

1. Geht nur auf amazon.de (nicht auf .com/co.uk)
2. Daten werden nicht sinnvoll (als csv oder so) ausgegeben
3. Der Code ist nicht aufgeräumt oder schön -- sorry, erstes Ruby-Dings für mich
4. Requests auf die Order-Übersichts-Seiten könnten parallelisiert werden um das crawlen zu verschnellern
5. Sicher noch viel mehr

