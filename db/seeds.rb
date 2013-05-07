licenses = [
  { name: "Attribution", code: "CC BY" },
  { name: "Attribution-ShareAlike", code: "CC BY-SA" },
  { name: "Attribution-NoDerivs", code: "CC BY-ND" },
  { name: "Attribution-NonCommercial", code: "CC BY-NC" },
  { name: "Attribution-NonCommercial-ShareAlike", code: "CC BY-NC-SA" },
  { name: "Attribution-NonCommercial-NoDerivs", code: "CC BY-NC-ND" }
]

licenses.each do |license|
  License.find_or_create_by_name_and_code(license[:name], license[:code])
end

categories = [
  "Nature",
  "Wildlife",
  "Architecture",
  "Sport",
  "Family",
  "Still Life",
  "Street",
  "Landscape",
  "Portraiture",
  "Journalism",
  "People",
  "Travel",
  "Art",
  "Wedding",
  "Pets",
  "Events",
  "Vehicles",
  "Crafts",
  "Abstract",
  "Music"
]

categories.each do |category|
  Category.find_or_create_by_name(category)
end
