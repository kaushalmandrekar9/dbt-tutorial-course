WITH

-- Aggregate measures
order_item_measures AS (
	SELECT
		order_id,
		SUM(item_sale_price) AS total_sale_price,
		SUM(product_cost) AS total_product_cost,
		SUM(item_profit) AS total_profit,
		SUM(item_discount) AS total_discount,

	FROM {{ ref('int_ecommerce__order_items_products') }}
	GROUP BY 1
)



SELECT
	od.order_id,
	od.created_at AS order_created_at,
	od.shipped_at AS order_shipped_at,
	od.delivered_at AS order_delivered_at,
	od.returned_at AS order_returned_at,
	od.status AS order_status,
	od.num_items_ordered,
	om.total_sale_price,
	om.total_product_cost,
	om.total_profit,
	om.total_discount

	-- Columns from our templated Jinja statement
	-- We could just hard code these if we wanted, e.g.: total_sold_menswear, total_sold_womenswear
	-- In practise we'd calculate this column in the model itself, but it's
	-- a good way to demonstrate how to use an ephemeral materialisation
FROM {{ ref('stg_ecommerce__orders') }} AS od
LEFT JOIN order_item_measures AS om
	ON od.order_id = om.order_id