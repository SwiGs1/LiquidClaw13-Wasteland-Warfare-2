/obj/item/seeds/yucca
	name = "pack of banana yucca seeds"
	desc = "These seeds grow into a banana yucca plant."
	icon_state = "seed-yucca"
	species = "banana yucca"
	plantname = "banana yucca plant"
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "yucca-grow"
	icon_dead = "yucca-dead"
	product = /obj/item/reagent_containers/food/snacks/grown/yucca
	lifespan = 30
	endurance = 20
	yield = 3
	growthstages = 3
	production = 5
	maturation = 5

/obj/item/reagent_containers/food/snacks/grown/yucca
	seed = /obj/item/seeds/yucca
	name = "yucca fruit"
	desc = "Banana yucca is a soft, fleshy fruit full of seeds. Tasty!"
	icon_state = "yucca"
	filling_color = "#FF6347"

/obj/item/reagent_containers/food/snacks/grown/mutfruit/add_juice()
	if(..())
		reagents.add_reagent("nutriment", 5 + round((seed.potency / 20), 1))
		bitesize = 1 + round(reagents.total_volume / 3, 1)