select news.news from news
	where news.id_N IN(
		select id_N from (
			select count(id_N) as countN, id_N 
            from(
				select * from N_W 
                where N_W.id_W IN (
					select words.id_W from words
						where words.word IN ('prima', 'tua', 'escola')
				)
			) as tabela
            group by id_N
		)as tabela2
        where countN = (
			select count(distinct words.id_W) 
				from words 
                where words.word in ('prima', 'tua', 'escola'))
);