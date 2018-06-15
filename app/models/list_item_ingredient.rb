class ListItemIngredient < ActiveRecord::Base
  belongs_to :list_item

  as_enum :unit, {
      teaspoon: 0,
      tablespoon: 1,
      fluid_ounce: 2,
      cup: 3,
      pint: 4,
      quart: 5,
      gallon: 6,
      milliliter: 7,
      liter: 8,
      pound: 15,
      ounce: 16,
      milligram: 17,
      gram: 18,
      kilogram: 19,

      head: 100,
      whole: 101,
      stalk: 102,
      bunch: 103

    }
end
