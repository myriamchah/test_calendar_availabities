## Test technique gestion des disponibilités - Descriptif

L'objectif ici est d'écrire une méthode permettant de connaître les disponibilités d'un agenda
en fonction des événements attachés à celui-ci.
La méthode prend en entrée une date et recherche toutes les disponibilités sur les 7 jours
suivants en fonction des événements existants.

Les évènements sont de deux types:

 - 'opening' qui correspondent à des périodes de disponibilité pour une journée donnée, et peuvent être récurrentes à la semaine.
 - 'appointment' qui sont des périodes d'occupation.

La mission : faire passer le test unitaire ci-joint et rajouter les tests des cas aux limites qui te semblent pertinents.


## Exemple de retour attendu:

[{"date":"2014/08/04","slots":["12:00","13:30"]},{"date":"2014/08/05","slots":["09:00", "09:30"]},
{"date":"2014/08/06","slots":[]},{"date":"2014/08/07","slots":["15:30","16:30","16:45","17:00"]},
{"date":"2014/08/08","slots":[]},{"date":"2014/08/09","slots":["14:00", "14:30"],"substitution":null},
{"date":"2015/08/10","slots":[]}]
