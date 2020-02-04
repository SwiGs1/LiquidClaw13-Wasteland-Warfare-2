/obj/item/seeds/prickly
	name = "pack of prickly pear seeds"
	desc = "These seeds grow into a prickly pear cactus."
	icon_state = "seed-prickly"
	species = "prickly pear"
	plantname = "Prickly Pear Cactus"
	growing_icon = 'icons/obj/hydroponics/growing_fruits.dmi'
	icon_grow = "prickly-grow"
	icon_dead = "prickly-dead"
	icon_harvest = "prickly-harvest"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	product = /obj/item/reagent_containers/food/snacks/grown/prickly
	lifespan = 40
	endurance = 25
	yield = 4
	growthstages = 4
	production = 6
	maturation = 6

/obj/item/reagent_containers/food/snacks/grown/prickly
	seed = /obj/item/seeds/prickly
	name = "prickly pear"
	desc = "A prickly pear is a pear-shaped fruit full of juice that tastes similar to watermelon."
	icon_state = "prickly"
	filling_color = "#FF6347"

/obj/item/reagent_containers/food/snacks/grown/prickly/add_juice()
	if(..())
		reagents.add_reagent("nutriment", 2 + round((seed.potency / 20), 1))
		reagents.add_reagent("water", 2 + round((seed.potency / 20), 1))
		bitesize = 1 + round(reagents.total_volume / 3, 1)