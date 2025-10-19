## **MovieQuiz (ENG)**

MovieQuiz is an app featuring quizzes about movies from the top 250 and the most popular films according to IMDb.

## **Links**

[Figma Design](https://www.figma.com/file/l0IMG3Eys35fUrbvArtwsR/YP-Quiz?node-id=34%3A243)

[API IMDb](https://tv-api.com/api#Top250Movies-header)

[Fonts](https://code.s3.yandex.net/Mobile/iOS/Fonts/MovieQuizFonts.zip)

## **App Description**

A single-page application featuring quizzes about movies from the top 250 and the most popular IMDb films. The user answers questions about the movie's rating in sequence. After each round, the app displays statistics on the number of correct answers and the user's best results. The goal is to answer all 10 questions of the round correctly.

## **Functional Requirements**

1) When the app starts, a splash screen is displayed;
2) After launching, the app shows a question screen with a question text, an image, and two answer options: "Yes" and "No", only one of which is correct;
3) The quiz question is based on the IMDb rating of the movie on a 10-point scale, e.g., "Is the rating of this movie higher than 6?";
4) The user can select one of the answer options and receive feedback on whether it is correct, with the photo's border changing color accordingly;
5) After selecting an answer, the next question automatically appears after 1 second;
6) After completing a round of 10 questions, an alert appears with the user's statistics and the option to play again;
7) The statistics include: 
    - the current round's result (the number of correct answers out of 10 questions), 
    - the number of quizzes played, 
    - the record (best round result during the session, date and time of that round),
    - the overall quiz performance in percentage (average accuracy);
8) The user can start a new round by pressing the "Play Again" button on the alert;
9) If data cannot be loaded, the user sees an alert with a message indicating that something went wrong, along with a button to retry the network request.

## **Technical Requirements**

1) The app should support iPhone devices running iOS 15, with only portrait mode available;
2) UI elements adapt to the screen resolutions of iPhones, layouts for iPad are not provided;
3) The screens match the design — correct fonts of the required sizes are used, all text is positioned correctly, and the placement of all elements, button sizes, and margins are exactly as in the design.

==============================

## **MovieQuiz (RUS)**

MovieQuiz - это приложение с квизами о фильмах из топ-250 рейтинга и самых популярных фильмах по версии IMDb.

## **Ссылки**

[Макет Figma](https://www.figma.com/file/l0IMG3Eys35fUrbvArtwsR/YP-Quiz?node-id=34%3A243)

[API IMDb](https://imdb-api.com/api#Top250Movies-header)

[Шрифты](https://code.s3.yandex.net/Mobile/iOS/Fonts/MovieQuizFonts.zip)

## **Описание приложения**

Одностраничное приложение с квизами о фильмах из топ-250 рейтинга и самых популярных фильмов IMDb. Пользователь приложения последовательно отвечает на вопросы о рейтинге фильма. По итогам каждого раунда игры показывается статистика о количестве правильных ответов и лучших результатах пользователя. Цель игры — правильно ответить на все 10 вопросов раунда.

## **Функциональные требования**
1) При запуске приложения показывается сплеш-скрин;
2) После запуска приложения показывается экран вопроса с текстом вопроса, картинкой и двумя вариантами ответа, “Да” и “Нет”, только один из них правильный;
3) Вопрос квиза составляется относительно IMDb рейтинга фильма по 10-балльной шкале, например: "Рейтинг этого фильма больше 6?";
4) Можно нажать на один из вариантов ответа на вопрос и получить отклик о том, правильный он или нет, при этом рамка фотографии поменяет цвет на соответствующий;
5) После выбора ответа на вопрос через 1 секунду автоматически появляется следующий вопрос;
6) После завершения раунда из 10 вопросов появляется алерт со статистикой пользователя и возможностью сыграть ещё раз;
7) Статистика содержит:
    - результат текущего раунда (количество правильных ответов из 10 вопросов),
    - количество сыгранных квизов, 
    - рекорд (лучший результат раунда за сессию, дата и время этого раунда),
    - статистику сыгранных квизов в процентном соотношении (среднюю точность);
8) Пользователь может запустить новый раунд, нажав в алерте на кнопку "Сыграть еще раз";
9) При невозможности загрузить данные пользователь видит алерт с сообщением о том, что что-то пошло не так, а также кнопкой, по нажатию на которую можно повторить сетевой запрос.

## **Технические требования**
1) Приложение должно поддерживать устройства iPhone с iOS 15, предусмотрен только портретный режим;
2) Элементы интерфейса адаптируются под разрешения экранов iPhone, вёрстка под iPad не предусмотрена;
3) Экраны соответствует макету — использованы верные шрифты нужных размеров, все надписи находятся на нужном месте, расположение всех элементов, размеры кнопок и отступы — точно такие же, как в макете.
