def read(file)
  File.open(file).read.split("\n").map.with_index do |row, i|
    next if i == 0
    row.split(",").map(&:strip)
  end.compact
rescue
  []
end

class Taxer
  BASE_TAX      = 0.1
  IMPORTED_TAX  = 0.05
  EXCLUDE       = ['pills', 'chocolate', 'book'].freeze

  def initialize(item)
    @item = item
  end

  def tax
    b_tax = exclude? ? 0 : BASE_TAX
    i_tax = @item.imported? ? IMPORTED_TAX : 0

    taxes = b_tax + i_tax

    @item.price * taxes
  end

  def exclude?
    EXCLUDE.any? { |e| @item.product.include?(e) }
  end
end

Item = Struct.new(:quantity, :product, :unit_price) do
  def to_s
    "#{ quantity }, #{ product }, #{ sub_total.round(2) }"
  end

  def price
    (quantity * unit_price)
  end

  def sub_total
    ( price + tax )
  end

  def tax
    Taxer.new(self).tax
  end

  def imported?
    product.match?(/^imported/)
  end
end

def main(input)
  return unless input.size.positive?

  total = 0
  taxes = 0

  input.map{ |i| Item.new(i[0].to_i, i[1], i[2].to_f) }.each do |item|
    total += item.sub_total
    taxes += item.tax

    puts item.to_s
  end

  taxes = taxes + 0.05 - (taxes % 0.05)
  puts "Sales Taxes: #{ taxes.round(2) }"
  puts "Total: #{ total.round(2) }"
end

input_1 = read("input_1.csv")
input_2 = read("input_2.csv")
input_3 = read("input_3.csv")

main(input_1)
p ''
main(input_2)
p ''
main(input_3)
