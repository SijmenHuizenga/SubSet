# Analyse SubSet

##Dit is hoe de game werkt
In beeld heb je een aantal kaarten. Dit aantal kaarten varieert tussen 9 en 12 afhankelijk of je het originele of een versimpelde verzie speelt. De bedoeling is om drie kaarten te selecteren die een ‘set’ vormen. Als deze kaarten een set vormen, worden deze kaarten van het bord verwijdert en komen er nieuwe kaarten uit de stapel. 

De stapel bevat in het begin van het spel alle mogelijke kaarten(27 of 256). Er worden steeds een aantal op tafel gelegd. Vervolgens pakt de speler een set totdat er geen sets meer op tafel liggen of totdat de stapel leeg is. Elke keer als de speler een kaart pakt, wordt het puntenaantal met 1 verhoogd. Het aantal punten is de score van de speler. 

##Welke eigenschappen?
Elke kaart heeft een aantal eigenschappen. In de verkleinde versie zijn er 3 eigenschappen:
  *	De hoeveelheid (1, 2, 3)
  *	De vorm (rechthoek, driehoek, ovaal)
  *	De kleur van de vorm (rood, geel, blauw)

In de originele versie is er nog een extra eigenschap:
  * De kleur van de kaart (oranje, groen, paars)

Alle mogelijke kaarten zijn te vinden [hier](https://github.com/SijmenHuizenga/SubSet/blob/master/afbeeldingen/27Kaarten.png) en [hier](https://github.com/SijmenHuizenga/SubSet/blob/master/afbeeldingen/81Kaarten.png).

##Wanneer is het een set?
Een set heeft 3 kaarten. Een set kenmerkt zicht dat binnen elke eigenschappen alles verschillend is, of alles anders is.  Hier zijn wat voorbeelden:
![voorbeeld 1](https://raw.githubusercontent.com/SijmenHuizenga/SubSet/master/afbeeldingen/voorbeeld1.png)<br>
kleur: rood, rood, rood  (overal zelfde)<br>
achtergrond kleur: oranje, oranje, oranje  (overal zelfde)<br>
vorm: rechthoek, rechthoek, rechthoek  (overal zelfde)<br>
hoeveelheid: 3, 2, 1    (overal anders)<br>
**Dus dit is een valid set!**<br>
![voorbeeld 2](https://raw.githubusercontent.com/SijmenHuizenga/SubSet/master/afbeeldingen/voorbeeld2.png)<br>
Kleur: rood, geel, blauw  (overal anders) <br>
Achtergrond kleur: oranje, groen, paars   (overal anders) <br>
Vorm: rechthoek, rechthoek, rechthoek   (overal gelijk) <br>
Hoeveelheid: 3, 2, 1   (overal anders) <br>
**Dus dit is een valid set!**<br>
![voorbeeld 3](https://raw.githubusercontent.com/SijmenHuizenga/SubSet/master/afbeeldingen/voorbeeld3.png)<br>
kleur: rood, rood, rood  (overal anders)<br>
achtergrond kleur: oranje, groen, paars   (overal anders)<br>
vorm: driehoek, driehoek, driehoek   (overal gelijk)<br>
hoeveelheid: 3, 3, 2   (**deels gelijk, deels anders**)<br>
**Dus dit niet een valid set!**
