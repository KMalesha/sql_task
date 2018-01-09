CREATE TEMP TABLE users(id bigserial,
                        group_id bigint);
INSERT INTO users(group_id)
VALUES (1), (1), (1), (2), (1), (3);


SELECT u1.group_id,
       u1.id AS min_id from
  (SELECT u2.id, u2.group_id, lead(u2.group_id) over(ORDER BY u2.id DESC) AS next_group_id
   FROM users u2
   ORDER BY u2.id ASC) AS u1
WHERE u1.group_id IS DISTINCT FROM u1.next_group_id;


SELECT u1.group_id,
       count(id) AS COUNT from
  (SELECT u2.id, u2.group_id, row_number() OVER (ORDER BY u2.id) - row_number() OVER (PARTITION BY u2.group_id
                                                                                      ORDER BY u2.id) AS sub
   FROM users u2
   ORDER BY u2.id) AS u1
GROUP BY u1.group_id,
         u1.sub;
