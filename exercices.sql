--1. Liste des potions : Numéro, libellé, formule et constituant principal. (5 lignes)
SELECT *
FROM potion;

--2. Liste des noms des trophées rapportant 3 points. (2 lignes)
SELECT nom_categ AS nom_du_trophee
FROM categorie
WHERE nb_points = 3;

--3. Liste des villages (noms) contenant plus de 35 huttes. (4 lignes)
SELECT nom_village
FROM village
WHERE nb_huttes > 35;

--4. Liste des trophées (numéros) pris en mai / juin 52. (4 lignes)
SELECT num_trophee
FROM trophee
WHERE date_prise
BETWEEN '2052-05-01'
AND '2052-06-30';

--5. Noms des habitants commençant par 'a' et contenant la lettre 'r'. (3 lignes)
SELECT nom
FROM habitant
WHERE nom LIKE 'A%r%';

--6. Numéros des habitants ayant bu les potions numéros 1, 3 ou 4. (8 lignes)
SELECT DISTINCT num_hab
FROM absorber
WHERE num_potion IN (1, 3, 4);

--7. Liste des trophées : numéro, date de prise, nom de la catégorie et nom du preneur. (10lignes)
SELECT num_trophee, date_prise, code_cat, num_preneur
FROM trophee;

--8. Nom des habitants qui habitent à Aquilona. (7 lignes)
SELECT nom
FROM habitant
JOIN village ON habitant.num_village = village.num_village
WHERE nom_village = 'Aquilona';

--9. Nom des habitants ayant pris des trophées de catégorie Bouclier de Légat. (2 lignes)
SELECT nom
FROM habitant
JOIN trophee ON habitant.num_hab = trophee.num_preneur
JOIN categorie ON trophee.code_cat = categorie.code_cat
WHERE categorie.nom_categ = 'Bouclier de Légat';

--10. Liste des potions (libellés) fabriquées par Panoramix : libellé, formule et constituantprincipal. (3 lignes)
SELECT lib_potion
FROM potion
JOIN fabriquer ON potion.num_potion = fabriquer.num_potion
JOIN habitant ON fabriquer.num_hab = habitant.num_hab
WHERE nom = 'Panoramix';

--11. Liste des potions (libellés) absorbées par Homéopatix. (2 lignes)
SELECT DISTINCT lib_potion
FROM potion
JOIN absorber ON potion.num_potion = absorber.num_potion
JOIN habitant ON absorber.num_hab = habitant.num_hab
WHERE nom = 'Homéopatix';

--12. Liste des habitants (noms) ayant absorbé une potion fabriquée par l'habitant numéro 3. (4 lignes)
SELECT DISTINCT nom
FROM habitant
JOIN absorber ON habitant.num_hab = absorber.num_hab
JOIN fabriquer ON absorber.num_potion = fabriquer.num_potion
WHERE fabriquer.num_hab = 3;

--13. Liste des habitants (noms) ayant absorbé une potion fabriquée par Amnésix. (7 lignes)
SELECT DISTINCT nom
FROM habitant
JOIN absorber ON habitant.num_hab = absorber.num_hab
JOIN fabriquer ON absorber.num_potion = fabriquer.num_potion
WHERE fabriquer.num_hab = (
    SELECT num_hab
    FROM habitant
    WHERE nom = 'Amnésix'
);

--14. Nom des habitants dont la qualité n'est pas renseignée. (2 lignes)
SELECT nom
FROM habitant
WHERE num_qualite IS NULL;

--15. Nom des habitants ayant consommé la Potion magique n°1 (c'est le libellé de lapotion) en février 52. (3 lignes)
SELECT nom
FROM habitant
JOIN absorber ON habitant.num_hab = absorber.num_hab
JOIN potion ON absorber.num_potion = potion.num_potion
WHERE absorber.date_a
BETWEEN '2052-02-01'
AND '2052-03-01' AND absorber.num_potion = (
    SELECT num_potion
    FROM potion
    WHERE potion.lib_potion = 'Potion magique n°1' 
);

--16. Nom et âge des habitants par ordre alphabétique. (22 lignes)
SELECT nom, age
FROM habitant
ORDER BY nom;

--17. Liste des resserres classées de la plus grande à la plus petite : nom de resserre et nom du village. (3 lignes)
SELECT resserre.nom_resserre, village.nom_village
FROM resserre
JOIN village ON resserre.num_village = village.num_village
ORDER BY superficie DESC;

--***

--18. Nombre d'habitants du village numéro 5. (4)
SELECT COUNT(nom)
FROM habitant
WHERE num_village = 5;

--19. Nombre de points gagnés par Goudurix. (5)
SELECT SUM(nb_points)
FROM categorie
JOIN trophee ON categorie.code_cat = trophee.code_cat
JOIN habitant ON trophee.num_preneur = habitant.num_hab
WHERE habitant.nom = 'Goudurix';

--20. Date de première prise de trophée. (03/04/52)
SELECT MIN(date_prise)
FROM trophee;

--21. Nombre de louches de Potion magique n°2 (c'est le libellé de la potion) absorbées. (19)
SELECT SUM(quantite)
FROM absorber
JOIN potion ON absorber.num_potion = potion.num_potion
WHERE potion.lib_potion = 'Potion magique n°2';

--22. Superficie la plus grande. (895)
SELECT MAX(superficie)
FROM resserre;

--***

--23. Nombre d'habitants par village (nom du village, nombre). (7 lignes)
SELECT village.nom_village, COUNT(nom) AS nombre_habitant
FROM habitant
JOIN village ON habitant.num_village = village.num_village
GROUP BY village.nom_village;

--24. Nombre de trophées par habitant (6 lignes)
SELECT DISTINCT nom, COUNT(nom) AS nombre_trophee
FROM habitant
JOIN trophee ON habitant.num_hab = trophee.num_preneur
GROUP BY habitant.nom;

--25. Moyenne d'âge des habitants par province (nom de province, calcul). (3 lignes)
SELECT nom_province, AVG(age)
FROM province
JOIN village ON province.num_province = village.num_province
JOIN habitant ON village.num_village = habitant.num_village
GROUP BY nom_province;

--26. Nombre de potions différentes absorbées par chaque habitant (nom et nombre). (9lignes)
SELECT DISTINCT nom, COUNT(nom) AS nombre_potion
FROM habitant
JOIN absorber ON habitant.num_hab = absorber.num_hab
JOIN potion ON absorber.num_potion = potion.num_potion 
GROUP BY habitant.nom;

--27. Nom des habitants ayant bu plus de 2 louches de potion zen. (1 ligne)
SELECT nom
FROM habitant
JOIN absorber ON habitant.num_hab = absorber.num_hab
JOIN potion ON absorber.num_potion = potion.num_potion
WHERE potion.lib_potion = 'Potion Zen' AND absorber.quantite > 2;

--***
--28. Noms des villages dans lesquels on trouve une resserre (3 lignes)
SELECT nom_village
FROM village
JOIN resserre ON village.num_village = resserre.num_village
GROUP BY village.num_village, village.nom_village
HAVING COUNT(resserre.num_village) >= 1;

--29. Nom du village contenant le plus grand nombre de huttes. (Gergovie)
SELECT nom_village
FROM village
WHERE nb_huttes = (
    SELECT MAX(nb_huttes)
    FROM village
);

--30. Noms des habitants ayant pris plus de trophées qu'Obélix (3 lignes).
SELECT nom
FROM habitant
JOIN trophee ON habitant.num_hab = trophee.num_preneur
GROUP BY nom
HAVING COUNT(nom) > (
    SELECT COUNT(num_preneur)
    FROM trophee
    JOIN habitant ON trophee.num_preneur = habitant.num_hab
    WHERE habitant.nom = 'Obélix'
);
