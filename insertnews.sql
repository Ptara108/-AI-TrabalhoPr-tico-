INSERT INTO news(news) 
	select 'A tua prima 4'
    from news
    WHERE not exists(select id_N from news where news.news = 'A tua prima 4')
    LIMIT 1;
	