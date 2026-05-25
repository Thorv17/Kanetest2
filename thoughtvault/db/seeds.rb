# CSI2441 Assignment 2 - MyQuote
# Student: Vinith Magheswaran (ID: 10676287)
# Database seed file - Idempotent seed data for development and testing
# Safe to re-run multiple times; uses find_or_create_by to prevent duplicates

puts "== Seeding categories =="

# Seven philosophical categories required by assignment specification
category_names = [
  "Metaphysics",
  "Axiology",
  "Epistemology",
  "Logic",
  "Ethics",
  "Political Philosophy",
  "Aesthetics"
]

category_names.each do |name|
  Category.find_or_create_by!(name: name)
  puts "  Category: #{name}"
end

puts "== Seeding mandatory test users =="

# Administrator account (required by assignment brief)
# Email: admin@myquotes.com | Password: admin123
admin = User.find_or_initialize_by(email: "admin@myquotes.com")
admin.fname    = "John"
admin.lname    = "Jones"
admin.is_admin = true
admin.status   = "Active"
admin.password = "admin123" if admin.new_record?
admin.save!
puts "  Admin: #{admin.email}"

# Standard user account (required by assignment brief)
# Email: vinceb@myemail.com | Password: vince123
standard = User.find_or_initialize_by(email: "vinceb@myemail.com")
standard.fname    = "Vincent"
standard.lname    = "Brown"
standard.is_admin = false
standard.status   = "Active"
standard.password = "vince123" if standard.new_record?
standard.save!
puts "  User:  #{standard.email}"

puts "== Seeding sample thinkers =="

# Sample philosophers/authors for demonstration quotes
thinkers = [
  { fname: "Aristotle",  lname: "",        birth_yr: "384 BCE", death_yr: "322 BCE",
    bio: "Ancient Greek philosopher and polymath, student of Plato." },
  { fname: "Immanuel",   lname: "Kant",    birth_yr: "1724",    death_yr: "1804",
    bio: "German philosopher, central figure in modern philosophy." },
  { fname: "Simone",     lname: "de Beauvoir", birth_yr: "1908", death_yr: "1986",
    bio: "French existentialist philosopher and feminist theorist." },
  { fname: "Marcus",     lname: "Aurelius", birth_yr: "121",    death_yr: "180",
    bio: "Roman emperor and Stoic philosopher." }
]

thinkers.each do |t|
  Author.find_or_create_by!(fname: t[:fname], lname: t[:lname]) do |a|
    a.birth_yr = t[:birth_yr]
    a.death_yr = t[:death_yr]
    a.bio      = t[:bio]
  end
  puts "  Thinker: #{t[:fname]} #{t[:lname]}"
end

puts "== Seeding sample public quotes =="

# Fetch references to seed data for quote creation
aristotle  = Author.find_by(fname: "Aristotle")
kant       = Author.find_by(fname: "Immanuel")
aurelius   = Author.find_by(fname: "Marcus")
ethics_cat = Category.find_by(name: "Ethics")
logic_cat  = Category.find_by(name: "Logic")
meta_cat   = Category.find_by(name: "Metaphysics")

# Sample public quotes with categories for homepage display
sample_quotes = [
  {
    content:   "The whole is more than the sum of its parts.",
    pub_year:  "350 BCE",
    note:      "A foundational idea in systems thinking.",
    is_public: true,
    author:    aristotle,
    user:      standard,
    categories: [meta_cat, logic_cat]
  },
  {
    content:   "Act only according to that maxim by which you can at the same time will that it should become a universal law.",
    pub_year:  "1785",
    note:      "The categorical imperative — Kant's supreme principle of morality.",
    is_public: true,
    author:    kant,
    user:      standard,
    categories: [ethics_cat]
  },
  {
    content:   "You have power over your mind, not outside events. Realise this, and you will find strength.",
    pub_year:  nil,
    note:      "Classic Stoic wisdom.",
    is_public: true,
    author:    aurelius,
    user:      standard,
    categories: [ethics_cat]
  }
]

sample_quotes.each do |sq|
  next if sq[:author].nil?
  # Skip if quote already exists for this user
  existing = Quote.find_by(content: sq[:content], user: sq[:user])
  next if existing

  # Build quote with tags inline so validation passes (requires at least one category)
  quote = Quote.new(
    content:   sq[:content],
    pub_year:  sq[:pub_year],
    note:      sq[:note],
    is_public: sq[:is_public],
    author:    sq[:author],
    user:      sq[:user]
  )
  sq[:categories].compact.each do |cat|
    quote.quote_categories.build(category: cat)
  end
  quote.save!
  puts "  Quote: #{sq[:content].truncate(60)}"
end

puts "== Seed complete! =="
