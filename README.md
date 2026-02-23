# ricknmorty

A new Flutter project.

## Getting Started

У роботі з api використав:
/character з параметрами page і name для відображення списку персонажів і пошуку

/character/1,2,3 batch-запит персонажів за id, використовується на екрані епізоду щоб отримати імена. 

/episode/1,2,3 те саме для епізодів, використовується на екрані персонажа. id для batch-запитів витягуємо з url'ів, які вже є в моделях (episodeUrls і characterUrls)

Навігація проста, через Navigator.push. На наступний екран передаються уже завантажені дані (Character / Episode)
